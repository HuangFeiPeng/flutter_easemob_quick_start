import 'package:flutter/material.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
/* pages */
import 'pages/home/home.dart';
import 'pages/login/em_login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the ap// state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter 环信API调用测试'),
      // home: const HomePage(),
      initialRoute: '/home',
      routes: {
        '/home': (context) => const HomePage(),
        '/login': (context) => const EmLogin(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //调用初始化SDK
  @override
  void initState() {
    super.initState();
    _initEMSDK();
    _addEventListener();
  }

  void _initEMSDK() async {
    final options =
        EMOptions.withAppKey('easemob-demo#support', autoLogin: false);

    try {
      await EMClient.getInstance.init(options);
      print('SDK初始化成功');
      // 可以在这里添加初始化后的操作
      // 例如自动登录：await EMClient.getInstance.login("username", "password");
    } catch (e) {
      print('SDK初始化失败: $e'); // 添加错误捕获
    }
  }

  static const String CONNECTION_EVENT_HANDLER = 'CONNECTION_EVENT_HANDLER';
  static const String MESSAGE_EVENT_HANDLER = 'MESSAGE_EVENT_HANDLER';

  get autoLogin => null;

  void _addEventListener() {
    print('loginIM');
    // 连接监听
    EMClient.getInstance.addConnectionEventHandler(
      CONNECTION_EVENT_HANDLER,
      EMConnectionEventHandler(
        onConnected: () {
          print('onConnected');
        },
        onDisconnected: () {
          print('onDisconnected');
        },
        onTokenDidExpire: () {},
        onTokenWillExpire: () {},
        onUserAuthenticationFailed: () {},
        onUserDidForbidByServer: () {},
        onUserDidChangePassword: () {},
        onUserDidLoginFromOtherDevice: (info) {},
        onUserDidLoginTooManyDevice: () {},
        onUserDidRemoveFromServer: () {},
        onUserKickedByOtherDevice: () {},
        onAppActiveNumberReachLimit: () {},
        onOfflineMessageSyncStart: () {},
        onOfflineMessageSyncFinish: () {},
      ),
    );
    // 消息监听
    final onMessageHandler = EMChatEventHandler(
      onMessagesReceived: (messages) => {
        print('onMessagesReceived: ${messages.length}'),
        for (var message in messages)
          {
            print('message type: ${message.body}'),
            print('message: ${message.msgId}'),
            //弹出toast提示收到消息,屏幕居中提示
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    '收到消息:消息类型:${message.body.type} + 消息ID: ${message.msgId}'),
                duration: const Duration(seconds: 1),
              ),
            ),
          }
      },
      // onCmdMessagesReceived: (messages) {},
    );
    EMClient.getInstance.chatManager
        .addEventHandler(MESSAGE_EVENT_HANDLER, onMessageHandler);
  }

  void _loginIM() async {
    print('loginIM');
    String _username = 'hfp';
    String _password = '1';
    try {
      await EMClient.getInstance.login(_username, _password);
      print('login success');
    } on EMError catch (e) {
      print('login failed: ${e}');
    }
  }

  void _sendTextMessage() {
    String _chatId = 'pfh';
    String _messageContent = 'hello world！';
    var msg = EMMessage.createTxtSendMessage(
      targetId: _chatId,
      content: _messageContent,
    );
    EMClient.getInstance.chatManager.sendMessage(msg);
    //弹出toast提示发送成功,屏幕居中提示
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('发送成功'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                child: const Text('登录IM'),
                onPressed: _loginIM,
              ),
              ElevatedButton(
                child: const Text('发送文本消息'),
                onPressed: _sendTextMessage,
              )
            ],
          ),
        ));
  }

  @override
  void dispose() {
    print('dispose...');
    super.dispose();
    // 移除连接监听
    EMClient.getInstance.removeConnectionEventHandler(CONNECTION_EVENT_HANDLER);
    // 移除消息监听
    EMClient.getInstance.chatManager.removeEventHandler(MESSAGE_EVENT_HANDLER);
  }
}
