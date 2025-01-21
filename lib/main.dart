import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:one_love/constants/global_variables.dart';
import 'package:one_love/controllers/auth_controller.dart';
import 'package:one_love/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sizer/sizer.dart';

import 'api_services/notifications_services.dart';
import 'controllers/general_controller.dart';
import 'controllers/room_controller.dart';
import 'package:firebase_core/firebase_core.dart';
void main() async{
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // PushNotificationServices().notificationCall();
  // await AndroidAlarmManager.initialize();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
  // WidgetsFlutterBinding.ensureInitialized();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   PushNotificationServices().firebaseNotificationPermission();
  // }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp
    ]);
    return Sizer(builder: (context, orientation, deviceType) {
      return GetMaterialApp(
        initialBinding: InitialBinding(),
        builder: (context, child) {
          return ScrollConfiguration(
            behavior: MyBehavior(),
            child: child!,
          );
        },
        debugShowCheckedModeBanner: false,
        title: "One Love",
        theme: ThemeData(
          useMaterial3: false,
            highlightColor: Colors.transparent,
            splashColor: Colors.white,
            primarySwatch: Colors.orange,
            scaffoldBackgroundColor: AppColors.scaffoldColor),
        home: SplashScreen(),
      );
    });
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(AuthController());
    Get.put(RoomController());

    Get.put(GeneralController());
    // Get.put(Get.put(dynamic()));

    initializeDateFormatting();
  }
}
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    // Initialize Firebase only if it hasn't been initialized
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp();
    }
  } catch (e) {
    // Handle any initialization errors
    print("Error initializing Firebase in background handler: $e");
  }

  // Handle the background message
  print("Handling a background message: ${message.messageId}");
}

// @pragma('vm:entry-point')
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message)async{
//   Firebase.initializeApp();
// }