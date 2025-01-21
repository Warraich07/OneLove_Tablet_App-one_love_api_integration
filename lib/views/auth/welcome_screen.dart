import 'package:one_love/views/auth/login_screen.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../controllers/auth_controller.dart';
import '../../widgets/custom_widgets.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int setLanguage = 0;
  final AuthController _authController=Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(child: DelayedDisplay(
                  delay: Duration(milliseconds: 600),
                  slidingBeginOffset: Offset(0, 1),
                  child: Image.asset("assets/images/app_logo.png", scale: 1,))),
              SizedBox(height: 20,),
              SizedBox(
                width: 60.w,
                child: DelayedDisplay(
                  delay: Duration(milliseconds: 800),
                  slidingBeginOffset: Offset(0, 1),
                  child: CustomButton(
                    buttonText: "Get Started",
                    onTap: () {
                      Get.to(() => LogInScreen(),
                          transition: Transition.rightToLeft);
                    },
                  ),
                ),
              ),
              // SizedBox(height: 15,),
              // SizedBox(
              //   width: 60.w,
              //   child: DelayedDisplay(
              //     delay: Duration(milliseconds: 800),
              //     slidingBeginOffset: Offset(0, 1),
              //     child: CustomButton(
              //       buttonText: "SIGN UP",
              //       onTap: () {
              //
              //       },
              //     ),
              //   ),
              // ),
            ],
          ),
          Spacer(),
        ],
      ),
    );
  }
}
