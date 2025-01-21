





import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:one_love/controllers/room_controller.dart';
import 'package:path_provider/path_provider.dart';
import '../controllers/auth_controller.dart';
import '../controllers/general_controller.dart';
import '../views/home/home_screen.dart';

class NotificationsServices {
  // UnCom
  // BookingController bookingController = Get.find();
  AuthController _authController=Get.find();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  void initLocalNotification(BuildContext context, RemoteMessage message) async {
    var androidInitializationSettings = AndroidInitializationSettings("ic_launcher");
    var initializationSetting = InitializationSettings(android: androidInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(initializationSetting,
        onDidReceiveNotificationResponse: (payLoad) {
          // UnCom
          handleMessage(context,message);
        });
  }

  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      initLocalNotification(context, message);
      showNotification(message);
    });
  }

  Future<void> showNotification(RemoteMessage message) async {
    // final ByteData bytes = await rootBundle.load('assets/icons/app_icon.jpg');
    // final Uint8List list = bytes.buffer.asUint8List();
    //
    // // Save the asset to a temporary file
    // final Directory directory = await getTemporaryDirectory();
    // final File file = File('${directory.path}/assets/icons/app_icon.jpg');
    // await file.writeAsBytes(list);

    AndroidNotificationChannel channel = AndroidNotificationChannel(
        Random.secure().nextInt(100000).toString(), "High Importance Channel",
        importance: Importance.max);
    AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
        channel.id.toString(), channel.name.toString(),
        channelDescription: "your channel description",
        importance: Importance.high,
        priority: Priority.high,
      icon: '@drawable/ic_launcher',
      color: const Color(0xFFF0F0F0), // Background color for notification
      colorized: false, // Use the color as the background
      // largeIcon: FilePathAndroidBitmap(file.path),
    );
    NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);
    Future.delayed(Duration.zero, () {
      flutterLocalNotificationsPlugin.show(
          0,
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          notificationDetails);
    });
  }

  void requestNotificationsPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
        badge: true,
        announcement: true,
        alert: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true);
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // DebugUtils.printDebug(StringResources.userGrantedPermission);
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      // DebugUtils.printDebug(StringResources.userGrantedProvisionalPermission);
    } else {
      // DebugUtils.printDebug(StringResources.userDidNotGrantPermission);
    }
  }
  // UnCom
  void handleMessage(BuildContext context ,RemoteMessage message){
    if(_authController.isAdminView==true){
      Get.offAll(() => HomeScreen());
      _authController.updateIsAdminView(false);
      _authController.updateViewToNotificationScreen(true);
    }else{

    }


  }

  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();

    return token!;
  }
}
// // icon: 'app_icon_o_l'