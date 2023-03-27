import 'package:flutter/material.dart';
import 'package:toonflix/screens/join_screen.dart';
import 'dart:convert';

import 'package:toonflix/services/jwt_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController pwController = TextEditingController();
  bool isLoading = false;

  Future<void> _login() async {
    String id = idController.text;
    String pw = pwController.text;

    var response = await dio.post(
      '/user/login',
      data: {
        'id': id,
        'password': pw,
      },
    );

    setState(() {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.data);
        saveTokens(data['accessToken'], data['refreshToken']);
        isLoading = true;
      } else {
        isLoading = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        title: const Text(
          "오늘의 웹툰",
          style: TextStyle(
            fontSize: 24,
          ),
        ),
      ),
      body: GestureDetector(
        onTapCancel: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: idController,
                    decoration: const InputDecoration(
                      labelText: 'ID',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: pwController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          _login();
                          if (isLoading) {
                            Navigator.pushReplacementNamed(context, '/home');
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('로그인 실패'),
                                  content:
                                      const Text('아이디 또는 비밀번호가 일치하지 않습니다.'),
                                  actions: [
                                    TextButton(
                                      child: const Text('확인'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        splashColor: const Color.fromARGB(
                            255, 5, 91, 8), // 터치효과에 따라 색상 지정
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.green),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: const Text(
                            'Login',
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              // PadgeROuteBuilder : 더 다양한 애니메이션 적용 가능,
                              builder: (context) => const JoinScreen(),
                              fullscreenDialog: true,
                            ),
                          );
                        },
                        splashColor: Colors.green, // 터치효과에 따라 색상 지정
                        child: Container(
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.green), // 테두리 색상 지정
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: const Text('Join'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
