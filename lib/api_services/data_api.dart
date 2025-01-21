import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:one_love/views/auth/login_screen.dart';
import '../controllers/auth_controller.dart';
import '../views/auth/welcome_screen.dart';
import 'api_exceptions.dart';
import 'api_urls.dart';

// This is the DataApiService class. It contains two methods, get and post, to access the api
// for both information retrieval and data updates. There is also a helper method named _processResponse
// which determines which response to send based on the response code received from the api.
class DataApiService {
  DataApiService._();

  // Stores timeout duration needed for api calls
  // ignore: constant_identifier_names
  static const int TIME_OUT_DURATION = 120;

  AuthController authController = Get.find();

  // final BaseController _baseController = BaseController.instance;

  static final DataApiService _instance = DataApiService._();

  static DataApiService get instance => _instance;

  bool isExpired(DateTime expiryDate) {
    final currentDate = DateTime.now();
    return expiryDate.isBefore(currentDate);
  }

  Future<dynamic> delete(String api) async {

    print(api);

    var uri = Uri.parse(BASE_URL + api);
    print(BASE_URL + api);
    try {
      var response = await http.delete(uri, headers: {
        // please uncomment it
        // "Authorization": "Bearer ${authController.accessToken.value}",
      }).timeout(const Duration(seconds: TIME_OUT_DURATION));
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
          'API not responded in time', uri.toString());
    }
  }

  //GET
  Future<dynamic> get(String api) async {

    print(api);

    var uri = Uri.parse(BASE_URL + api);
    print(BASE_URL + api);
    try {
      var response = await http.get(uri, headers: {
        "Authorization": "Bearer ${authController.accessToken.value}",
      }).timeout(const Duration(seconds: TIME_OUT_DURATION));
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
          'API not responded in time', uri.toString());
    }
  }


  Future<dynamic> getGemini(String body) async {


    var uri = Uri.parse( "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=AIzaSyCMSu9ZdUgXZpQVXKPZPIDFJUtS5JKFOX4");
    print(uri.path);
    try {
      var response = await http.post(uri,body: body, headers: {
        "Content-Type": "application/json",
      }).timeout(const Duration(seconds: TIME_OUT_DURATION));
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
          'API not responded in time', uri.toString());
    }
  }

  //POST
  Future<dynamic> Auth(
    String api,
    dynamic body, ) async {

    Uri uri = Uri.parse(BASE_URL + api);
    print(BASE_URL + api);
    print(body);
    try {

        http.Response response = await http
            .post(
              uri,
              headers: {
                // please uncomment it
                // "Authorization": "Bearer ${authController.accessToken.value}",
                // "App-lang":"en"

                'token': '6Eq22gR5aEkw2'
              },
              body: body,
            )
            .timeout(const Duration(seconds: TIME_OUT_DURATION));
        print(response);
        return _processResponse(response);

    } on SocketException {
      throw FetchDataException('No Internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
          'API not responded in time', uri.toString());
    }
  }

  //POST
  Future<dynamic> post(
      String api,
      dynamic body, ) async {

    Uri uri = Uri.parse(BASE_URL + api);
    print(BASE_URL + api);
    print(body);
    try {

      http.Response response = await http
          .post(
        uri,
        headers: {

          "Authorization": "Bearer ${authController.accessToken.value}",
        },
        body: body,
      )
          .timeout(const Duration(seconds: TIME_OUT_DURATION));
      print(response);
      return _processResponse(response);

    } on SocketException {
      throw FetchDataException('No Internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
          'API not responded in time', uri.toString());
    }
  }

Future<dynamic> multiPartImage(
      String api, List<String?> imageFile,String fieldName, Map<String, String> body,
      ) async {


    var uri = Uri.parse(BASE_URL + api);
    print(uri);
    print(body);
    try {
      var headers = {
        // please uncomment it
        // 'Authorization': 'Bearer ${authController.accessToken.value}'
      };
      print('before');
      var request = http.MultipartRequest('POST', uri);


      if (imageFile.isNotEmpty) {
        for(int i=0;i<imageFile.length;i++){
          if(imageFile[i]!=null){
            request.files
                .add(await http.MultipartFile.fromPath(fieldName, imageFile[i]!));
          }

        }

      }
      // request.files
      //     .add(await http.MultipartFile.fromPath('image', imageFile.first));
      request.fields.addAll(body);
      // please uncomment it
      // request.headers.addAll(headers);
      print(request.fields);
      print(request.files);
      http.StreamedResponse response = await request
          .send()
          .timeout(const Duration(seconds: TIME_OUT_DURATION));
      final respStr = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        // print(await response.stream.bytesToString());
        return respStr;
      } else {
        print(response.reasonPhrase);
        return respStr;
      }
    } on SocketException {
      throw FetchDataException('No Internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
          'API not responded in time', uri.toString());
    }
  }

  Future<dynamic> multiPartEditProfile(
      String api, String? imageFile ,String fieldName, Map<String, String> body,
      ) async {


    var uri = Uri.parse(BASE_URL + api);
    print(uri);
    print(body);
    try {
      var headers = {
        // please uncomment it
        // 'Authorization': 'Bearer ${authController.accessToken.value}'
      };
      print('before');
      var request = http.MultipartRequest('POST', uri);

    if(imageFile!=null){
      request.files
          .add(await http.MultipartFile.fromPath(fieldName, imageFile));
    }

      request.fields.addAll(body);
      // please uncomment it
      // request.headers.addAll(headers);
      print(request.fields);
      print(request.files);
      http.StreamedResponse response = await request
          .send()
          .timeout(const Duration(seconds: TIME_OUT_DURATION));
      final respStr = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        // print(await response.stream.bytesToString());
        return respStr;
      } else {
        print(response.reasonPhrase);
        return respStr;
      }
    } on SocketException {
      throw FetchDataException('No Internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException(
          'API not responded in time', uri.toString());
    }
  }

  // Helper method that determines response based on response code
  dynamic _processResponse(var response, {bool multipart = false}) async {
    // ignore: prefer_typing_uninitialized_variables

    var responseJson;
    if (multipart) {
      responseJson = await response.stream.bytesToString();
    } else {
      responseJson = utf8.decode(response.bodyBytes);
    }
    debugPrint('responseJson');
    print('RESPONSEJSON: $responseJson');
    print(response.statusCode);
    switch (response.statusCode) {
      case 200:
        return responseJson;
      case 201:
        return responseJson;
      case 302:
        Get.offAll(()=>WelcomeScreen());
      case 400:
        return responseJson;
         throw BadRequestException(
            utf8.decode(response.bodyBytes), response.request!.url.toString());
      case 401:
        // return responseJson ;
        {
          // Get.put(AuthController()).signOut();
          // Get.offAll(()=>SignIn());
          // please uncomment it
          // CustomDialog.showErrorDialog(description: 'Please Contact Support',onTap: ()async{
          //       // await authController.logoutUser("token");
          //       // AuthPreference.instance.setUserLoggedIn(false,"barber");
          //   AuthPreference.instance.setUserLoggedIn(false,"barber");
          //   Get.to(WelcomeScreen());
          // }
          // ,buttonText: "Logout");
          throw UnAuthorizedException(utf8.decode(response.bodyBytes),
              response.request!.url.toString());

        }
      case 403:
        throw UnAuthorizedException(
            utf8.decode(response.bodyBytes), response.request!.url.toString());
      case 422:return responseJson;
        // throw BadRequestException(
        //     utf8.decode(response.bodyBytes), response.request!.url.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occurred with code : ${response.statusCode}',
            response.request!.url.toString());
    }
  }
}
