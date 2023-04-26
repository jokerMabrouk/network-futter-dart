import 'package:network/services/get.dart';
import 'package:network/network.dart';
import 'package:network/utils/network_config.dart';

void main() async {
  NetworkConfig.baseUrl = 'http://192.168.1.100:1337/api';
  // NetworkConfig.baseUrl = 'https://pub.dev';
  NetworkConfig.connectTimeoutSeconds = 25;
  NetworkConfig.receiveTimeoutSeconds = 25;

  print(NetworkConfig.staticToString());
  NetworkBase.initialize();

  DioGetWebRequestService()
      .getRequest('/clients')
      .then(print)
      .catchError(print);
}

/*
import 'package:dio/dio.dart';

/// More examples see https://github.com/cfug/dio/blob/main/example
void main() async {
  final dio = Dio();
  final response = await dio.get('https://pub.dev');
  print(response.data);
}
*/