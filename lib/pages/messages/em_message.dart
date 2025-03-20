import 'package:flutter/material.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:image_picker/image_picker.dart';

class EmMessage extends StatefulWidget {
  const EmMessage({super.key});
  @override
  State<EmMessage> createState() => _EmMessageState();
}

class _EmMessageState extends State<EmMessage> {
  final TextEditingController _targetIdController = TextEditingController();
  ChatType _chatType = ChatType.Chat;
  //chatType radio 选择控件
  //添加Radio组件构建
  Widget _buildChatTypeRadio() {
    return Wrap(spacing: 5, children: [
      const Align(alignment: Alignment.centerLeft, child: Text('ChatType')),
      RadioListTile<ChatType>(
          title: const Text('单聊'),
          value: _chatType,
          groupValue: ChatType.Chat,
          onChanged: (value) => {
                setState(() {
                  _chatType = ChatType.Chat;
                })
              }),
      RadioListTile<ChatType>(
          title: const Text('群聊'),
          value: _chatType,
          groupValue: ChatType.GroupChat,
          onChanged: (value) => {
                setState(() {
                  _chatType = ChatType.GroupChat;
                })
              }),
      RadioListTile<ChatType>(
          title: const Text('聊天室'),
          value: _chatType,
          groupValue: ChatType.ChatRoom,
          onChanged: (value) => {
                setState(() {
                  _chatType = ChatType.ChatRoom;
                })
              }),
    ]);
  }

  //发送消息
  Widget _buildSendButtonCard() {
    return Column(
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '发送消息',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        ElevatedButton(
          onPressed: _sendTextMessage,
          child: const Text('发送文本消息'),
        ),
        ElevatedButton(
          onPressed: _sendImageMessage,
          child: const Text('发送图片消息'),
        ),
      ],
    );
  }

  //发送文本消息
  void _sendTextMessage() async {
    print('sendTextMessage');
    // String _chatId = _targetIdController.text;

    //弹起可输入内容的对话框
    String? _messageContent;
    _messageContent = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: const Text('请输入消息内容'),
              content: TextField(
                  decoration: const InputDecoration(
                    hintText: '请输入消息内容',
                  ),
                  onChanged: (value) {
                    _messageContent = value;
                  }),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, null),
                  child: const Text('取消'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, _messageContent),
                  child: const Text('确定'),
                ),
              ]);
        });
    if (_messageContent == null) {
      return;
    }
    print('messageContent: ${_messageContent} ${_chatType}');
    //发送消息
    var msg = EMMessage.createTxtSendMessage(
      targetId: _targetIdController.text,
      chatType: _chatType,
      content: _messageContent as String,
    );
    try {
      await EMClient.getInstance.chatManager.sendMessage(msg);
      // 弹出发送后的提示
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('发送成功'),
          duration: Duration(seconds: 1),
        ),
      );
      print('send success');
    } on EMError catch (e) {
      print('send failed: ${e}');
    }
  }

  //发送图片消息
  void _sendImageMessage() async {
    //调起系统相册选择图片
    final picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;
      print('image: ${image.path}');
      //发送图片消息
      var msg = EMMessage.createImageSendMessage(
        targetId: _targetIdController.text,
        chatType: _chatType,
        filePath: image.path,
      );
      await EMClient.getInstance.chatManager.sendMessage(msg);
    } catch (e) {
      print('pick image failed: ${e}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('登录'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              //每个Row之间增加一个title,且title居左对齐
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '输入表单',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              Row(
                children: [
                  //目标ID
                  Expanded(
                    child: TextField(
                      controller: _targetIdController,
                      decoration: const InputDecoration(
                        labelText: '目标ID',
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              //chatType radio
              _buildChatTypeRadio(),
              //send button card
              _buildSendButtonCard(),
              const SizedBox(height: 10),
            ])));
  }
}
