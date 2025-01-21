import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthPreference {
  AuthPreference._();

  static final AuthPreference _instance = AuthPreference._();

  static AuthPreference get instance => _instance;
  //
  // Future setNotificationsValue(String notificationLength) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setString("notificationLength", notificationLength??'0');
  // }
  // Future<String> getNotificationsValue() async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   String result = pref.getString("notificationLength") ?? '';
  //   return result;
  // }

  void setUserLoggedIn(bool key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isLoggedIn", key);
    // prefs.setString("userType", userType);
  }

  Future getUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var log = prefs.getBool("isLoggedIn") ?? false;
    return log;
  }

  // Future<Map<String, dynamic>> getUserLoggedIn() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var log = prefs.getBool("isLoggedIn") ?? false;
  //   String userType=prefs.getString("userType") ?? "user";
  //   return {
  //     "isLoggedIn": log,
  //     "userType": userType,
  //   };
  // }

  Future getUserType() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String result = pref.getString("userType") ?? '';
    return result;
  }

  Future getSocialType() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String result = pref.getString("socialType") ?? '';
    return result;
  }
  void setShowPopup(String type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("popupShown", type);
  }

  Future<String> shouldShowPopup() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    return pref.getBool('popupShown').toString();
  }

  void setUserType(String type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("userType", type);
  }

  void setSocialType(String type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("socialType", type);
  }



  void saveUserDataToken({@required token}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("token", token);
  }


  void saveUserId({@required id}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("userId", id);
  }

  Future getUserId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String result = pref.getString("userId") ?? '';
    return result;
  }

  void saveCurrency({@required id}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("currency", id);
  }

  Future getCurrency() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String result = pref.getString("currency") ?? '';
    return result;
  }

  Future getUserDataToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String result = pref.getString("token") ?? '';
    return result;
  }

  void saveUserRefreshToken({@required token}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("refresh_token", token);
  }

  Future getUserRefreshToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String result = pref.getString("refresh_token") ?? '';
    return result;
  }

  void saveUserData({@required token}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("userData", token.toString());
  }

  Future getUserData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String result = pref.getString("userData") ?? '';
    return result;
  }
  Future getRoomId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String result = pref.getString("roomId") ?? '';
    return result;
  }

  void setRoomId(String roomId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("roomId", roomId);
  }

  Future getStaffView() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String result = pref.getString("staffView") ?? '';
    return result;
  }

  void setStaffView(String staffView) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("staffView", staffView);
  }

  Future getRoomName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String result = pref.getString("roomName") ?? '';
    return result;
  }

  void setRoomName(String roomName) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("roomName", roomName);
  }
  Future<String> getRoomIndex() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String result = pref.getString("roomIndex") ?? '0';
    return result;
  }

  void setRoomIndex(String index) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("roomIndex", index);
  }

}
