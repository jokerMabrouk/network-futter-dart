library update.dart;

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import './utils/network_config.dart';

import 'src/network_base.dart';

import './exception/network_exception.dart';

abstract class UpdateWebRequestServices {
  Future<RESPONSE_MAP_TYPE> updateRequest({
    required String endPoint,
    required int id,
    required RESPONSE_MAP_TYPE updateBody,
  });
}

class DioUpdateWebRequestServices implements UpdateWebRequestServices {
  @override
  Future<RESPONSE_MAP_TYPE> updateRequest({
    required String endPoint,
    required int id,
    required RESPONSE_MAP_TYPE updateBody,
  }) async {
    try {
      final String body = jsonEncode({'data': updateBody});
      return await NetworkBase.dioConnection
          .put(
            '$endPoint/$id',
            data: body,
            queryParameters: NetworkConfig.POPULATE_API_QUERY,
          )
          .then((response) => response.data);
    } on DioError catch (dioError) {
      print(
          '\n\n\n\nDio Error message is $dioError\n Dio Error Type is ${dioError.type}\n\n\n\n\n');
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

  ////////////////////////////////////////////////////////////////////////
}
