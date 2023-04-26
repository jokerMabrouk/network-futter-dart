library delete.dart;

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import './utils/network_config.dart';

import 'src/network_base.dart';

import './exception/network_exception.dart';

abstract class DeleteWebRequestServices {
  Future<RESPONSE_MAP_TYPE> deleteRequest({
    required String endPoint,
    required int id,
  });
}

class DioDeleteWebRequestServices implements DeleteWebRequestServices {
  @override
  Future<RESPONSE_MAP_TYPE> deleteRequest({
    required String endPoint,
    required int id,
  }) async {
    try {
      return await NetworkBase.dioConnection
          .delete(
            '$endPoint/$id',
            queryParameters: NetworkConfig.POPULATE_API_QUERY,
          )
          .then((response) => response.data);
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

  ////////////////////////////////////////////////////////////////////////
}
