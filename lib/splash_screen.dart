import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:one_love/controllers/room_controller.dart';
import 'package:one_love/utils/shared_preference.dart';
import 'package:one_love/views/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:one_love/views/auth/welcome_screen.dart';
import 'package:one_love/views/home/home_screen.dart';
import 'package:one_love/views/home/room_screen.dart';
import 'api_services/notifications_services.dart';
import 'api_services/push_notifications.dart';
import 'constants/global_variables.dart';
import 'controllers/auth_controller.dart';
import 'models/main_user_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  final AuthController _authController = Get.find<AuthController>();

  getData() async {

    // AuthPreference.instance.setUserLoggedIn(false);
    // bool isLoggedIn = await AuthPreference.instance.getUserLoggedIn();


    bool isLoggedIn = await AuthPreference.instance.getUserLoggedIn();

    // String userType = userStatus["userType"];
    String staffView=await AuthPreference.instance.getStaffView();
    String roomName=await AuthPreference.instance.getRoomName();
    String roomId=await AuthPreference.instance.getRoomId();


    // Get.rawSnackbar(
    //   message: isLoggedIn.toString(),
    //   backgroundColor: AppColors.secondaryColor,
    //   snackPosition: SnackPosition.TOP,
    //   duration: Duration(seconds: 3),
    // );
    if (isLoggedIn==true) {
      if(staffView=='1'){

        _authController.updateIsAdminView(false);
        print(isLoggedIn.toString()+"  >>>>>>>>>>is loggod in value<<< staff mode on");
        _authController.accessToken.value =
        await AuthPreference.instance.getUserDataToken();
        print(await AuthPreference.instance.getUserData());
        String result = await AuthPreference.instance.getUserData();
        Map<String,dynamic> userMap = jsonDecode(result) as Map<String, dynamic>;
        _authController.userData.value = MainUserModel.fromJson( userMap);
        roomController.getRooms();

        Timer(
            const Duration(seconds: 4),
                () => Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => RoomScreen(initialTitle: roomName,
                  isNewCreated: false, isEditRoom: true,roomId: roomId,))));
      }else{
        print(isLoggedIn.toString()+"  >>>>>>>>>>is loggod<<< staff mode off");
        _authController.accessToken.value =
        await AuthPreference.instance.getUserDataToken();
        print(await AuthPreference.instance.getUserData());
        String result = await AuthPreference.instance.getUserData();
        Map<String,dynamic> userMap = jsonDecode(result) as Map<String, dynamic>;
        _authController.userData.value = MainUserModel.fromJson( userMap);

        Timer(
            const Duration(seconds: 4),
                () => Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomeScreen())));
      }

    }else if(isLoggedIn==false) {
      bool isLoggedIn = await AuthPreference.instance.getUserLoggedIn();
      // bool isLoggedIn = userStatus["isLoggedIn"];
      print(isLoggedIn.toString()+"  >>>>>>>>>>is loggod in value");
      print("  >>>>>>>>>>is loggod in value");
      Timer(
          const Duration(seconds: 4),
              () => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => WelcomeScreen())));
    }
  }

  RoomController roomController=Get.find();

  @override
  void initState() {
    super.initState();
    NotificationsServices notificationsServices = NotificationsServices();
    notificationsServices.requestNotificationsPermission();
    notificationsServices.getDeviceToken().then((value) async{
      log(value.toString());
      roomController.updateFcmToken(value);
      _authController.updateFcmToken(value);
      bool isLoggedIn = await AuthPreference.instance.getUserLoggedIn();

      // bool isLoggedIn = userStatus["isLoggedIn"];
      if(isLoggedIn==true){
        // uncom
        roomController.updateFcmNotificationToken(value.toString());
      }
    });
    notificationsServices.firebaseInit(context);

    PushNotifications.sendNotificationToSelectedDriver(_authController.token.toString());
    getData();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Image.asset(
                  "assets/images/app_logo.png",
                  scale: 1,
                ),
              ),
            ),
            Spacer(),
            SizedBox(
              height: 50,
              width: 50,
              child: Stack(
                fit: StackFit.expand,
                alignment: Alignment.center,
                children: [
              SpinKitCircle(
              color: Colors.black,
                size: 55.0,
              ),
                ],
              ),
            ),
            SizedBox(height: 40,),
          ],
        ),
      ),
    );
  }
}
