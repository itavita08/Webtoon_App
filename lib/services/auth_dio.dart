import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:toonflix/services/jwt_service.dart';
import '../screens/login_screen.dart';

Future<Dio> authDio() async {
  const String apiUrl = 'http://localhost:3000';
  var dio = Dio(BaseOptions(baseUrl: apiUrl));

  dio.interceptors.clear();

  dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) async {
    final accessToken = await getAccessToken();

    options.headers['Authorization'] = 'Bearer $accessToken';
    return handler.next(options);
  }, onError: (error, handler) async {
    if (error.response?.statusCode == 401) {
      final refreshToken = await getRefreshToken();

      var refreshDio = Dio();

      refreshDio.interceptors
          .add(InterceptorsWrapper(onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          await storage.deleteAll();
          showDialog(
            context: error.response?.data['message'],
            builder: (BuildContext context) {
              return AlertDialog(
                content: Text('${error.response?.data['message']}'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                        fullscreenDialog: true,
                      ),
                    ),
                    child: const Text('확인'),
                  ),
                ],
              );
            },
          );
        }
        return handler.next(error);
      }));

      final refreshResponse = await refreshDio
          .get('/refresh', data: {'refreshToken': refreshToken});

      final newAccessToken = refreshResponse.data['accessToken'];
      final newRefreshToken = refreshResponse.data['refreshToken'];

      await saveTokens(newAccessToken, newRefreshToken);

      error.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';

      final clonedRequest = await dio.request(error.requestOptions.path,
          options: Options(
              method: error.requestOptions.method,
              headers: error.requestOptions.headers),
          data: error.requestOptions.data,
          queryParameters: error.requestOptions.queryParameters);

      return handler.resolve(clonedRequest);
    }
    return handler.next(error);
  }));
  return dio;
}
