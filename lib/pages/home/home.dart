import 'package:flutter/material.dart';
import 'package:flutter_easemob_quick_start/pages/login/em_login.dart'; // 导入登录页面

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('主页'),
      // ),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          ),
          onPressed: () {
            // 导航到登录页面
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EmLogin()),
            );
          },
          child: const Text('前往登录'),
        ),
      ),
    );
  }
}
