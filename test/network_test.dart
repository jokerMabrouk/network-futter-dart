import 'package:dio/dio.dart';
import 'package:network/auth.dart';
import 'package:network/delete.dart';
import 'package:network/exception/network_exception.dart';
import 'package:network/post.dart';
import 'package:network/update.dart';
import 'package:test/test.dart';
import 'package:network/get.dart';
import 'package:network/network.dart';
import 'package:network/utils/network_config.dart';

void main() {
  /*group('A group of tests', () {
    final awesome = Awesome();

    setUp(() {
      // Additional setup goes here.
    });

    test('First Test', () {
      expect(awesome.isAwesome, isTrue);
    });
  });*/

  /// ** ******* * Get Request. ********* /
  group('DIO Get Test', () {
    // NetworkConfig.baseUrl = 'http://192.168.1.100:1337/api';
    // // NetworkConfig.baseUrl = 'https://pub.dev';
    // NetworkConfig.connectTimeoutSeconds = 25;
    // NetworkConfig.receiveTimeoutSeconds = 25;

    // print(NetworkConfig.staticToString());
    // NetworkBase.initialize();
    // setUp(() {
    //   NetworkConfig.baseUrl = 'http://192.168.1.100:1337/api';
    //   // NetworkConfig.baseUrl = 'https://pub.dev';
    //   NetworkConfig.connectTimeoutSeconds = 25;
    //   NetworkConfig.receiveTimeoutSeconds = 25;

    //   print(NetworkConfig.staticToString());
    //   NetworkBase.initialize();
    // });

    setUpAll(() {
      NetworkConfig.baseUrl = 'http://192.168.1.100:1337/api';
      // NetworkConfig.baseUrl = 'https://pub.dev';
      NetworkConfig.connectTimeoutSeconds = 25;
      NetworkConfig.receiveTimeoutSeconds = 25;

      print(NetworkConfig.staticToString());
      NetworkBase.initialize();
    });

    // ter

    // ********* * Get all request. ******* /
    test(
      'Clients error',
      () async {
        try {
          var response = await DioGetWebRequestService().getRequest('/clients');
          expect(response, isMap);
        } catch (error) {
          expect(error, ServerError);
        }
      },
    );

    test(
      'Cities Response',
      () async {
        RESPONSE_MAP_TYPE response =
            await DioGetWebRequestService().getRequest('/cities');
        expect(
          response,
          isMap,
        );
      },
    );

    // ********* * Get By ID request. ******* /
    test(
      'ID filter Network with out exception',
      () async {
        final map = await DioGetWebRequestService().getIdFilterRequest(
          endPoint: '/areas',
          id: 1,
        );
        expect(map, isMap);
      },
    );

    test(
      'ID filter Network with exception',
      () async {
        try {
          var response = await DioGetWebRequestService()
              .getIdFilterRequest(endPoint: '/clients', id: 1);
          expect(response, isMap);
        } catch (error) {
          expect(error, ServerError);
        }
      },
    );

    // ********* * Filter By Single entity request. ******* /
    test(
      'Field filter Network with out exception',
      () async {
        final map =
            await DioGetWebRequestService().getSingleEntityFilterRequest(
          endPoint: '/areas',
          entityName: 'nameen',
          value: 'Helwan',
        );
        expect(map, isMap);
      },
    );

    test(
      'Field filter Network with exception',
      () async {
        try {
          var response =
              await DioGetWebRequestService().getSingleEntityFilterRequest(
            endPoint: '/clients',
            entityName: 'phoneno',
            value: '052316445897956',
          );

          expect(response, ServerError);
        } catch (error) {
          expect(error, ServerError);
        }
      },
    );

    // ********* * Filter By Relational entity request. ******* /
    test(
      'Attribute field filter Network with out exception',
      () async {
        final map = await DioGetWebRequestService().getRelationalFilterRequest(
          endPoint: '/cities',
          attribute: 'areas',
          entityName: 'nameen',
          value: 'Helwan',
        );
        expect(map, isMap);
      },
    );

    test(
      'Attribute Field filter Network with exception',
      () async {
        try {
          var response =
              await DioGetWebRequestService().getRelationalFilterRequest(
            endPoint: '/clients',
            attribute: 'user',
            entityName: 'username',
            value: 'postman test',
          );

          expect(response, ServerError);
        } catch (error) {
          expect(error, ServerError);
        }
      },
    );
  });

  /// ** ******* * Authentication Request. ********* /
  group('DIO Authentication Test', () {
    /// ** ******* * Read Created Bearer{token}. ******** /
    test(
      'Read Strapi Bearer {No Exceptions}',
      () async {
        final userBody = await DioAuthWebRequestServices().readAuthToken(
          endPoint: '/auth/local',
          email: 'junk@postman.com',
          password: 'password1234',
        );
        expect(userBody, isMap);
      },
    );

    test(
      'Read Strapi Bearer {With Server Exceptions}',
      () async {
        try {
          final userBody = await DioAuthWebRequestServices().readAuthToken(
            endPoint: '/auth/local',
            email: 'junk2@postman.com',
            password: 'password1234',
          );
          expect(userBody, isMap);
        } catch (error) {
          print('Error');
          expect(error, ServerError);
        }
      },
    );

    /// ** ******* * Created New Bearer{token}. ******** /
    test(
      'Post Strapi New User {Without Server Exceptions}',
      () async {
        try {
          final userBody = await DioAuthWebRequestServices().createAuthToken(
            endPoint: '/auth/local',
            userName: 'Dart test',
            email: 'junk2@postman.com',
            password: 'password1234',
          );
          expect(userBody, isMap);
        } catch (error) {
          print('Post Strapi New User {Without Server Exceptions}: $Error');
          expect(error, ServerError);
        }
      },
    );

    test(
      'Post Strapi New User {With Server Exceptions}',
      () async {
        try {
          final userBody = await DioAuthWebRequestServices().createAuthToken(
            endPoint: '/auth/local/register',
            userName: 'Dart test',
            email: 'junk2@postman.com',
            password: 'password1234',
          );
          expect(userBody, isNotEmpty);
        } catch (error) {
          print('Error');
          expect(error, ServerError);
        }
      },
    );
  });

  /// ** ******* * Post Request. ********* /
  group('DIO Post Test', () {
    /// ** ******* * Post Data. ******** /
    test('Post Strapi {No Exceptions}', () async {
      final postResponse = await DioPostWebRequestServices().postRequest(
        endPoint: '/post-tests',
        postBody: {'name': 'Dart Test'},
      );
      expect(postResponse, isMap);
    });

    test('Post Strapi {With Server Exceptions}', () async {
      try {
        final postResponse = await DioPostWebRequestServices().postRequest(
          endPoint: '/clients',
          postBody: {'name': 'Dart Test'},
        );
        expect(postResponse, isMap);
      } catch (error) {
        print('Error');
        expect(error, ServerError);
      }
    });
  });

  /// ** ******* * Update Request. ********* /
  group('DIO Update Test', () {
    /// ** ******* * Update Data. ******** /
    test('Update Strapi {No Exceptions}', () async {
      final postResponse = await DioUpdateWebRequestServices().updateRequest(
        endPoint: '/post-tests',
        id: 2,
        updateBody: {'name': 'Dart Test-20'},
      );
      expect(postResponse, isMap);
    });

    test('Update Strapi {With Server Exceptions}', () async {
      try {
        final postResponse = await DioUpdateWebRequestServices().updateRequest(
          endPoint: '/clients',
          updateBody: {'name': 'Dart Test'},
          id: 1,
        );
        expect(postResponse, isMap);
      } catch (error) {
        print('Error');
        expect(error, ServerError);
      }
    });
  });

  /// ** ******* * Delete Request. ********* /
  group('DIO Delete Test', () {
    /// ** ******* * Delete Data. ******** /
    test('Delete Strapi {No Exceptions}', () async {
      final postResponse = await DioDeleteWebRequestServices().deleteRequest(
        endPoint: '/post-tests',
        id: 1,
      );

      print(postResponse);
      expect(postResponse, isMap);
    });

    test('Delete Strapi {With Server Exceptions}', () async {
      try {
        final postResponse = await DioDeleteWebRequestServices().deleteRequest(
          endPoint: '/clients',
          id: 1,
        );
        expect(postResponse, isMap);
      } catch (error) {
        print('Error');
        expect(error, ServerError);
      }
    });
  });
}
