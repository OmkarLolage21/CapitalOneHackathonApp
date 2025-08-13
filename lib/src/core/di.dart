import 'package:hive_flutter/hive_flutter.dart';
import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class AppDI {
  static Future<void> init() async {
    await Hive.initFlutter();
    // register Hive adapters if any
  }
}

final baseUrlProvider = Provider<String>((ref) =>
    const String.fromEnvironment('API_BASE', defaultValue: 'https://n8n.example.com'));

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: ref.read(baseUrlProvider),
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 30),
    headers: {'Accept': 'application/json'},
  ));
  dio.interceptors.addAll([
    RetryInterceptor(dio: dio, retries: 3),
    PrettyDioLogger(requestBody: true, responseBody: false),
  ]);
  return dio;
});