import 'package:flutter/material.dart';
import 'package:toonflix/screens/home_screen.dart';
import 'package:toonflix/services/jwt_service.dart';

class JoinScreen extends StatefulWidget {
  const JoinScreen({super.key});

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isLoading = false;

  Future<void> _submit() async {
    final String name = _nameController.text;
    final String id = _idController.text;
    final String password = _passwordController.text;

    final response = await dio.post(
      '/user/join',
      data: {
        'name': name,
        'id': id,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      isLoading = true;
    } else {
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('회원가입')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: '이름',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _idController,
              decoration: const InputDecoration(
                hintText: '아이디',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                hintText: '비밀번호',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _submit();
                if (isLoading) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      // PadgeROuteBuilder : 더 다양한 애니메이션 적용 가능,
                      builder: (context) => HomeScreen(),
                      fullscreenDialog: true,
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('회원가입 실패'),
                        content: const Text('회원가입 실패'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('확인'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: const Text('회원가입'),
            ),
          ],
        ),
      ),
    );
  }
}
