// 📦 Package imports:
import 'package:dio/dio.dart';

abstract class IApiClient {
  Dio get client;
  Future<void> initialize();
}
