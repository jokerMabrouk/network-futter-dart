library get.dart;

import 'dart:io';

import 'package:dio/dio.dart';

import './utils/network_config.dart';

import 'src/network_base.dart';

import './exception/network_exception.dart';

abstract class GetWebRequestServices {
  Future<RESPONSE_MAP_TYPE> getRequest(String endPoint);

  Future<RESPONSE_MAP_TYPE> getIdFilterRequest({
    required String endPoint,
    required int id,
  });

  Future<RESPONSE_MAP_TYPE> getSingleEntityFilterRequest({
    required String endPoint,
    required String entityName,
    required String value,
  });

  Future<RESPONSE_MAP_TYPE> getRelationalFilterRequest({
    required String endPoint,
    required String attribute,
    required String entityName,
    required String value,
  });
}

class DioGetWebRequestService implements GetWebRequestServices {
  @override
  Future<RESPONSE_MAP_TYPE> getRequest(String endPoint) async {
    try {
      return await NetworkBase.dioConnection
          .get(
            endPoint,
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

  @override
  Future<RESPONSE_MAP_TYPE> getIdFilterRequest({
    required String endPoint,
    required int id,
  }) async {
    try {
      return await NetworkBase.dioConnection
          .get(
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

  /// TODO: Upgarde Filter in Get request.
  @override
  Future<RESPONSE_MAP_TYPE> getSingleEntityFilterRequest({
    required String endPoint,
    required String entityName,
    required String value,
  }) async {
    final Map<String, String> parameters = {
      'filters[' + entityName + '][\$eq]': value,
      ...NetworkConfig.POPULATE_API_QUERY
    };

    try {
      return await NetworkBase.dioConnection
          .get(
            endPoint,
            queryParameters: parameters,
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

  @override
  Future<RESPONSE_MAP_TYPE> getRelationalFilterRequest({
    required String endPoint,
    required String attribute,
    required String entityName,
    required String value,
  }) async {
    final Map<String, String> parameters = {
      'filters[' + attribute + '][' + entityName + '][\$eq]': value,
      ...NetworkConfig.POPULATE_API_QUERY
    };

    try {
      return await NetworkBase.dioConnection
          .get(
            endPoint,
            queryParameters: parameters,
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
}
