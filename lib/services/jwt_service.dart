import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const String apiUrl = 'http://localhost:3000/webtoon';
final Dio dio = Dio(BaseOptions(baseUrl: apiUrl));
const FlutterSecureStorage storage = FlutterSecureStorage();

void setupInterceptors() {
  dio.interceptors.add(
    InterceptorsWrapper(onRequest: (options, handler) async {
      final accessToken = await storage.read(key: 'acessToken');
      if (accessToken != null) {
        options.headers['Authorization'] = 'Bearer $accessToken';
      } else {
        options.headers.remove('Authorization');
      }
      return handler.next(options);
    }, onResponse: (response, handler) async {
      if (response.statusCode == 401) {
        await storage.delete(key: 'accessToken');
        // Navigator.pushAndRemoveUntil(context, '/login', (_) => false);
      }
      return handler.next(response);
    }),
  );
}

Future<void> saveTokens(String accessToken, String refreshToken) async {
  await storage.write(key: 'accessToken', value: accessToken);
  await storage.write(key: 'refreshToken', value: refreshToken);
}

Future<void> clearTokens() async {
  await storage.delete(key: 'accessToken');
  await storage.delete(key: 'refreshToken');
}

Future<String?> getAccessToken() async {
  return await storage.read(key: 'accessToken');
}

Future<String?> getRefreshToken() async {
  return await storage.read(key: 'refreshToken');
}

Future<bool> hasTokens() async {
  final accessToken = await storage.read(key: 'accessToken');
  final refreshToken = await storage.read(key: 'refreshToken');

  return accessToken != null && refreshToken != null;
}

Future<String?> refreshAccessToken() async {
  final refreshToken = await getRefreshToken();

  if (refreshToken == null) {
    return null;
  }
  try {
    final response =
        await dio.post('/refresh', data: {'refreshToken': refreshToken});
    final accessToken = response.data['accessToken'];
    final newRefreshToken = response.data['refreshToken'];

    saveTokens(accessToken, newRefreshToken);

    return accessToken;
  } on DioError {
    return null;
  }
}
