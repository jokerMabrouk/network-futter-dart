import 'dart:io';
import 'package:dio/dio.dart';
import '../utils/network_config.dart';

typedef RESPONSE_MAP_TYPE = Map<String, dynamic>;

class NetworkBase {
  static late final Dio dioConnection;
  static late final BaseOptions dioConnectionBaseOptions;

  static void initialize() {
    dioConnectionBaseOptions = BaseOptions(
      baseUrl: NetworkConfig.baseUrl,
      receiveDataWhenStatusError: true,
      connectTimeout: Duration(
        seconds: NetworkConfig.connectTimeoutSeconds,
      ),
      receiveTimeout: Duration(
        seconds: NetworkConfig.receiveTimeoutSeconds,
      ),
      headers: {
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.contentTypeHeader: 'application/json',
      },
    );

    dioConnection = Dio(dioConnectionBaseOptions);
  }

  static void saveBearerToken(String token) =>
      dioConnection.options.headers[HttpHeaders.authorizationHeader] = token;
}
