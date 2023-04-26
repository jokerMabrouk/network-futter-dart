library auth.dart;

import 'dart:convert';

import 'package:dio/dio.dart';

import '../src/network_base.dart';

import '../utils/network_config.dart';

import '../exception/network_exception.dart';

abstract class AuthWebRequestServices {
  Future<RESPONSE_MAP_TYPE> createAuthToken(
      {required String endPoint,
      required String userName,
      required String email,
      required String password});

  Future<RESPONSE_MAP_TYPE> readAuthToken({
    required String endPoint,
    required String email,
    required String password,
  });
}

class DioAuthWebRequestServices implements AuthWebRequestServices {
  @override
  Future<RESPONSE_MAP_TYPE> createAuthToken(
      {required String endPoint,
      required String userName,
      required String email,
      required String password}) async {
    try {
      final String body = jsonEncode(
        {
          'username': userName,
          'email': email,
          'password': password,
        },
      );

      print(NetworkBase.dioConnection.options.baseUrl);

      final Response response = await NetworkBase.dioConnection.post(
        endPoint,
        data: body,
        queryParameters: NetworkConfig.POPULATE_API_QUERY,
      );

      NetworkConfig.bearerToken = 'bearer' + response.data['jwt'];

      NetworkBase.saveBearerToken(NetworkConfig.bearerToken);

      return response.data;
    } on DioError catch (dioError) {
      if ((dioError.type == DioErrorType.receiveTimeout) ||
          (dioError.type == DioErrorType.sendTimeout) ||
          (dioError.type == DioErrorType.connectionError)) {
        throw (TimeOutError);
      } else if (dioError.type == DioErrorType.badResponse) {
        throw (ServerError);
      } else if (dioError.type == DioErrorType.badCertificate) {
        throw (AuthenticationError);
      } else {
        throw (UnknownError);
      }
    }
  }

  @override
  Future<RESPONSE_MAP_TYPE> readAuthToken({
    required String endPoint,
    required String email,
    required String password,
  }) async {
    try {
      final String body = jsonEncode(
        {
          'identifier': email,
          'password': password,
        },
      );

      print(NetworkBase.dioConnection.options.baseUrl);

      final Response response = await NetworkBase.dioConnection.post(
        endPoint,
        data: body,
        queryParameters: NetworkConfig.POPULATE_API_QUERY,
      );

      NetworkConfig.bearerToken = 'bearer' + response.data['jwt'];

      NetworkBase.saveBearerToken(NetworkConfig.bearerToken);

      return response.data;
    } on DioError catch (dioError) {
      if ((dioError.type == DioErrorType.receiveTimeout) ||
          (dioError.type == DioErrorType.sendTimeout) ||
          (dioError.type == DioErrorType.connectionError)) {
        throw (TimeOutError);
      } else if (dioError.type == DioErrorType.badResponse) {
        throw (ServerError);
      } else if (dioError.type == DioErrorType.badCertificate) {
        throw (AuthenticationError);
      } else {
        throw (UnknownError);
      }
    }
  }
}
