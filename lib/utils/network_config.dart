import 'dart:typed_data';

class NetworkConfig {
  static late final String baseUrl;
  static late final int connectTimeoutSeconds;
  static late final int receiveTimeoutSeconds;
  static const Map<String, String> POPULATE_API_QUERY = {'populate': '*'};
  static late String bearerToken;

  
  static String staticToString() {
    return '''
Base url is $baseUrl,
connect Timeout Seconds is $connectTimeoutSeconds,
receive Timeout Seconds is $receiveTimeoutSeconds,
POPULATE API QUERY is $POPULATE_API_QUERY,
''';
  }
}
