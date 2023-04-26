library post.dart;

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

import './utils/network_config.dart';

import 'src/network_base.dart';

import './exception/network_exception.dart';

abstract class PostWebRequestServices {
  Future<RESPONSE_MAP_TYPE> postRequest({
    required String endPoint,
    required RESPONSE_MAP_TYPE postBody,
  });

  Future<RESPONSE_MAP_TYPE> postNewImageRequest({
    required String endPoint,
    required String imagePath,
    required String imageName,
  });
}

class DioPostWebRequestServices implements PostWebRequestServices {
  @override
  Future<RESPONSE_MAP_TYPE> postRequest({
    required String endPoint,
    required RESPONSE_MAP_TYPE postBody,
  }) async {
    try {
      final String body = jsonEncode({'data': postBody});

      return await NetworkBase.dioConnection
          .post(
            endPoint,
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

  @override
  Future<RESPONSE_MAP_TYPE> postNewImageRequest({
    required String endPoint,
    required String imagePath,
    required String imageName,
  }) async {
    final formData = FormData.fromMap(
      {
        'files': await MultipartFile.fromFile(
          imagePath,
          filename: imageName,
          contentType: MediaType('image', ''),
        ),
      },
    );

    try {
      return await NetworkBase.dioConnection
          .post(
            endPoint,
            data: formData,
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
}
