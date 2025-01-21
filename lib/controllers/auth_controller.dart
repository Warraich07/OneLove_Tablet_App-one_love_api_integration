import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:one_love/controllers/room_controller.dart';
import 'package:one_love/views/home/home_screen.dart';

import '../api_services/api_exceptions.dart';
import '../api_services/data_api.dart';
import '../models/main_user_model.dart';
import '../utils/custom_dialogbox.dart';
import '../utils/shared_preference.dart';
import '../views/auth/login_screen.dart';
import '../views/auth/verify_otp.dart';
import 'base_controller.dart';
class AuthController extends GetxController {
  final AuthPreference _authPreference = AuthPreference.instance;

  RxInt userType = 0.obs;
  String homeOwnerLat = "31.4504";
  String? homeOwnerLong = "73.1350";
  String? uploadImageUrlServiceProvider;
  String? uploadImageUrlHomeOwner;
  File? uploadImageFileServiceProvider;
  File? uploadImageFileCustomer;
  final picker = ImagePicker();
  XFile? pickedImage;
  BaseController _baseController = BaseController.instance;
  RxString otpCode="".obs;
  // RxString token = "".obs;
  // RxString fcmToken = ''.obs;
  Rxn<MainUserModel> userData=Rxn<MainUserModel>();
  RxString accessToken = "".obs;
  RxString verifiedOtp=''.obs;
  RxString verifiedEmail=''.obs;
  RxBool isAdminView=true.obs;
  RxBool isNotificationView=false.obs;
  RxString token=''.obs;
  RxString fcmToken=''.obs;
  RxInt selectedBoard=0.obs;


  updateOtpCode(String otp){
    otpCode.value=otp;
  }
  updateIsAdminView(bool value){
    isAdminView.value=value;
  }

  updateViewToNotificationScreen(bool notificationView){
    isNotificationView.value=notificationView;
  }

  void updateFcmToken(String token){
    fcmToken.value=token;
  }

  // Future resetPassword(String password,String confirmPassword,String email) async {
  //   _baseController.showLoading();
  //   Map<String, String> body = {
  //     'email': 'admin@admin.com',
  //     'password': password,
  //     'password_confirmation': confirmPassword,
  //     'otp': verifiedOtp.value.toString()
  //   };
  //   var response = await DataApiService.instance
  //       .Auth('auth/password/reset', body)
  //       .catchError((error) {
  //     if (error is BadRequestException) {
  //       var apiError = json.decode(error.message!);
  //       CustomDialog.showErrorDialog(description: apiError["reason"]);
  //     } else {
  //       _baseController.handleError(error);
  //     }
  //   });
  //   update();
  //   _baseController.hideLoading();
  //   if (response == null) return;
  //   print(response+ "responded");
  //   // print(result['success'])
  //   var result = json.decode(response);
  //   if (result['success']) {
  //     // please uncomment it
  //     Get.offAll(() => LogInScreen());
  //
  //     //
  //     // userData.value=MainUserModel.fromJson(result['data']);
  //     // accessToken.value=result['token'];
  //     // print(accessToken.value+"token is this");
  //     // _authPreference.saveUserDataToken(token: accessToken.value);
  //     // _authPreference.setUserLoggedIn(true);
  //     // _authPreference.saveUserData(token: jsonEncode(userData.value!.data.toJson()));
  //     // Get.offAll(() => HomeScreen());
  //
  //   } else {
  //     CustomDialog.showErrorDialog(description: result['message']);
  //   }
  // }

  // Future sendOtpCode(String email) async {
  //   _baseController.showLoading();
  //   Map<String, String> body = {
  //     'email': email,
  //   };
  //   var response = await DataApiService.instance
  //       .Auth('auth/password/forgot', body)
  //       .catchError((error) {
  //     if (error is BadRequestException) {
  //       var apiError = json.decode(error.message!);
  //       CustomDialog.showErrorDialog(description: apiError["reason"]);
  //     } else {
  //       _baseController.handleError(error);
  //     }
  //   });
  //   update();
  //   _baseController.hideLoading();
  //   if (response == null) return;
  //   print(response+ "responded");
  //   // print(result['success'])
  //   var result = json.decode(response);
  //   if (result['success']) {
  //     // please uncomment it
  //     print(result['data']['otp']);
  //     Get.to(() => VerifyOTP(email: email, fromSignUp: false,));
  //     // CustomDialog.showErrorDialog(description: result['data']['otp']);
  //     verifiedOtp.value=result['data']['otp'];
  //     verifiedEmail.value=email;
  //     Future.delayed(Duration(seconds: 1), () {
  //       Get.snackbar(
  //         'OTP',
  //         result['data']['otp'],
  //         snackPosition: SnackPosition.TOP,
  //         backgroundColor: Color(0xffF7941D), // Background color
  //         colorText: Colors.black, // Text color for better visibility
  //       );
  //     });
  //     //
  //     // userData.value=MainUserModel.fromJson(result['data']);
  //     // accessToken.value=result['token'];
  //     // print(accessToken.value+"token is this");
  //     // _authPreference.saveUserDataToken(token: accessToken.value);
  //     // _authPreference.setUserLoggedIn(true);
  //     // _authPreference.saveUserData(token: jsonEncode(userData.value!.data.toJson()));
  //     // Get.offAll(() => HomeScreen());
  //
  //   } else {
  //     CustomDialog.showErrorDialog(description: result['message']);
  //   }
  // }

  Future loginUser(String email,String password) async {
    _baseController.showLoading();
    Map<String, String> body = {
      'email': email,
      'password':password,
      'fcm_token': fcmToken.value
    };
    var response = await DataApiService.instance
        .Auth('auth/login', body)
        .catchError((error) {
      if (error is BadRequestException) {
        var apiError = json.decode(error.message!);
        CustomDialog.showErrorDialog(description: apiError["reason"]);
      } else {
        _baseController.handleError(error);
      }
    });
    update();
    _baseController.hideLoading();
    if (response == null) return;
    print(response+ "responded");
    // print(result['success'])
    var result = json.decode(response);
    if (result['success']) {
      updateIsAdminView(true);
      // please uncomment it
      userData.value=MainUserModel.fromJson(result['data']);
      accessToken.value=result['token'];
      print(accessToken.value+"token is this");

      _authPreference.setStaffView("0");
        _authPreference.saveUserDataToken(token: accessToken.value);
        _authPreference.setUserLoggedIn(true);
        _authPreference.saveUserData(token: jsonEncode(userData.value!.data.toJson()));
        Get.offAll(() => HomeScreen());

    } else {
      CustomDialog.showErrorDialog(description: result['message']);
    }
  }
  Future loginUserForAdminAccess(String email,String password) async {
    _baseController.showLoading();
    Map<String, String> body = {
      'email': email,
      'password':password,
    };
    var response = await DataApiService.instance
        .Auth('auth/login', body)
        .catchError((error) {
      if (error is BadRequestException) {
        var apiError = json.decode(error.message!);
        CustomDialog.showErrorDialog(description: apiError["reason"]);
      } else {
        _baseController.handleError(error);
      }
    });
    update();
    _baseController.hideLoading();
    if (response == null) return;
    print(response+ "responded");
    // print(result['success'])
    var result = json.decode(response);
    if (result['success']) {
      // please uncomment it
      updateIsAdminView(true);
      isAdminView.value=true;
      userData.value=MainUserModel.fromJson(result['data']);
      _authPreference.setStaffView("0");
      accessToken.value=result['token'];
      print(accessToken.value+"token is this");
      _authPreference.saveUserDataToken(token: accessToken.value);
      // _authPreference.setUserLoggedIn(true);
      _authPreference.saveUserData(token: jsonEncode(userData.value!.data.toJson()));
      Get.back();

    } else {
      CustomDialog.showErrorDialog(description: result['message']);
    }
  }
  Future logoutUser() async {
    _baseController.showLoading();
    Map<String, String> body = {
      'email': "admin@admin.com",
    };
    var response = await DataApiService.instance
        .Auth('auth/logout', body)
        .catchError((error) {
      if (error is BadRequestException) {
        var apiError = json.decode(error.message!);
        CustomDialog.showErrorDialog(description: apiError["reason"]);
      } else {
        _baseController.handleError(error);
      }
    });
    update();
    _baseController.hideLoading();
    if (response == null) return;
    print(response+ "responded");
    var result = json.decode(response);
    if (result['success']) {
      // please uncomment it
      // barberData.value=BarbersModel.fromJson(result['data']);

      _authPreference.setUserLoggedIn(false);
      Get.offAll(()=> LogInScreen());
      // _authPreference.saveUserData(token: jsonEncode(barberData.value!.toJson()));
      //   Get.offAll(() => BarberBottomNavBar());

    } else {
      CustomDialog.showErrorDialog(description: result['message']);
    }
  }

  // Future sendForgetPasswordCode(String email) async {
  //   _baseController.showLoading();
  //   Map<String, String> body = {
  //     'email': email,
  //   };
  //   var response = await DataApiService.instance
  //       .post('forgot-password', body)
  //       .catchError((error) {
  //     if (error is BadRequestException) {
  //       var apiError = json.decode(error.message!);
  //       CustomDialog.showErrorDialog(description: apiError["reason"]);
  //     } else {
  //       _baseController.handleError(error);
  //     }
  //   });
  //   update();
  //   _baseController.hideLoading();
  //   if (response == null) return;
  //   print(response+ "responded");
  //   var result = json.decode(response);
  //   if (result['success']) {
  //     // please uncomment this code
  //     // userEmail.value=email;
  //     // print("password reset code send to your email");
  //     // HapticFeedback.heavyImpact();
  //     // Get.to(() => VerifyOTP(email: '',fromSignUp: false,isUser: true,),
  //     //   transition: Transition.rightToLeft,
  //     // );
  //   } else {
  //     String errorMessages = result['message'];
  //     CustomDialog.showErrorDialog(description: errorMessages);
  //   }
  // }

  // Future verifyForgetPasswordCode() async {
  //   _baseController.showLoading();
  //   Map<String, String> body = {
  //     // please uncomment this code
  //     // 'otp': verifyOtp.value,
  //     // 'email': userEmail.value,
  //   };
  //   var response = await DataApiService.instance
  //       .post('verify-forgot-password', body)
  //       .catchError((error) {
  //     if (error is BadRequestException) {
  //       var apiError = json.decode(error.message!);
  //       CustomDialog.showErrorDialog(description: apiError["reason"]);
  //     } else {
  //       _baseController.handleError(error);
  //     }
  //   });
  //   update();
  //   _baseController.hideLoading();
  //   if (response == null) return;
  //   print(response+ "responded");
  //   var result = json.decode(response);
  //   if (result['success']) {
  //     // please uncomment this code
  //     // print("OTP Verified");
  //     // HapticFeedback.heavyImpact();
  //     // Get.to(()=>ResetPassword(email: userEmail.value,isUser: true,));
  //   } else {
  //     String errorMessages = result['message'];
  //     CustomDialog.showErrorDialog(description: errorMessages);
  //   }
  // }

  // Future resetPassword(String newPassword,String confirmPassword) async {
  //   _baseController.showLoading();
  //   Map<String, String> body = {
  //     // please uncomment this code
  //     // 'password': newPassword,
  //     // 'confirm_password': confirmPassword,
  //     // 'email': userEmail.value,
  //   };
  //   var response = await DataApiService.instance
  //       .post('reset-password', body)
  //       .catchError((error) {
  //     if (error is BadRequestException) {
  //       var apiError = json.decode(error.message!);
  //       CustomDialog.showErrorDialog(description: apiError["reason"]);
  //     } else {}
  //   });
  //   update();
  //   _baseController.hideLoading();
  //   if (response == null) return;
  //
  //   print(response+ "responded");
  //   var result = json.decode(response);
  //   if (result['success']) {
  //     // print("Password Changed");
  //     HapticFeedback.heavyImpact();
  //     // please uncomment this code
  //     // Get.to(()=>SignInScreen(isUser: true));
  //
  //   } else {
  //     List<dynamic> errorMessages = result['message'];
  //     String errorMessage = errorMessages.join();
  //     CustomDialog.showErrorDialog(description: errorMessage);
  //   }
  // }

  Future uploadProfileImage(String inputSource, from) async {
    try {
      pickedImage = await picker.pickImage(
          source: inputSource == 'camera'
              ? ImageSource.camera
              : ImageSource.gallery,
          maxWidth: 1920);
      print("pickedImage");
      print(pickedImage);
      if (from == "user") {
        uploadImageFileCustomer = File(pickedImage!.path);
        uploadImageUrlHomeOwner = pickedImage!.path;
      } else {
        uploadImageFileServiceProvider = File(pickedImage!.path);
        uploadImageUrlServiceProvider = pickedImage!.path;
      }
    } catch (err) {
      Get.back();
      if (kDebugMode) {
        print(err);
      }
    }
  }
}
