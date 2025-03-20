import 'package:flutter/material.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';

class EmLogin extends StatefulWidget {
  const EmLogin({super.key});

  @override
  State<EmLogin> createState() => _EmLoginState();
}

class _EmLoginState extends State<EmLogin> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _accessTokenController = TextEditingController();
  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  //用户名密码登录
  void _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    print('>>>>登录输出框 ${username}' '${password}');
    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请输入用户名和密码'),
        ),
      );
      return;
    }
    try {
      await EMClient.getInstance.loginWithPassword(username, password);
    } on EMError catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('登录失败：${e.description}'),
        ),
      );
    }
  }

  //token登录
  void _loginWithToken() async {
    final userId = _usernameController.text;
    final accessToken = _accessTokenController.text;
    if (_usernameController.text.isEmpty ||
        _accessTokenController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请输入用户名和Token'),
        ),
      );
      return;
    }
    try {
      await EMClient.getInstance.loginWithToken(userId, accessToken);
      // 弹出提示
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('登录成功'),
        ),
      );
    } on EMError catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('登录失败：${e.description}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('登录'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // 登录表单
              // 账号输入框
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: '账号',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              // 密码输入框
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: '密码',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _accessTokenController,
                decoration: const InputDecoration(
                  labelText: 'accessToken',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),
              // 登录按钮
              ElevatedButton(
                onPressed: () {
                  // 调用登录API
                  _login();
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('登录'),
              ),
              const SizedBox(height: 20),
              //Token登录按钮
              ElevatedButton(
                onPressed: () async {
                  final accessToken = _accessTokenController.text;
                  if (accessToken.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('请输入accessToken'),
                      ),
                    );
                    return;
                  }
                  _loginWithToken();
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Token登录'),
              ),
              const SizedBox(height: 20),
              //退出登录按钮
              ElevatedButton(
                onPressed: () async {
                  try {
                    await EMClient.getInstance.logout();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('退出登录成功'),
                      ),
                    );
                  } on EMError catch (e) {
                    debugPrint("logout error: ${e.code} ${e.description}");
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('退出登录'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
