import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:one_love/views/auth/welcome_screen.dart';
import 'package:one_love/views/home/home_screen.dart';
import 'package:sizer/sizer.dart';

import '../../constants/custom_validators.dart';
import '../../constants/global_variables.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/custom_widgets.dart';
import '../../widgets/text_form_fields.dart';
import 'forgot_password.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  bool _obscureText = true;
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passwordEditingController = TextEditingController();
  final AuthController _authController=Get.find();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  bool _keepSignIn = false;
  FocusNode _focusNode=FocusNode();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }
  @override
  Widget build(BuildContext context) {

    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: CustomAppBar(
          pageTitle: "",
          onTapLeading: () {
          },
          isBackButton: false,
        ),
      ),
      body: Form(
        key: _key,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: isPortrait ?20.h : 2.h,),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
                  child: DelayedDisplay(
                    delay: Duration(milliseconds: 300),
                    slidingBeginOffset: Offset(0, -1),
                    child: Image.asset("assets/images/app_logo.png", scale: 2,),
                  ),
                ),
                SizedBox(
                  height: 4.h,
                ),
                DelayedDisplay(
                  delay: Duration(milliseconds: 400),
                  slidingBeginOffset: Offset(-1, 0),
                  child: SizedBox(
                    width: 60.w,
                    child: AuthTextField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailEditingController,
                      validator: (value) => CustomValidator.email(value),
                      hintText: "Email Address",
                      focusNode: _focusNode,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                DelayedDisplay(
                  delay: Duration(milliseconds: 400),
                  slidingBeginOffset: Offset(0, -1),
                  child: SizedBox(
                    width: 60.w,
                    child: AuthTextField(
                      keyboardType: TextInputType.visiblePassword,
                      controller: _passwordEditingController,
                      validator: (value) => CustomValidator.password(value),
                      hintText: "Password",
                      isObscure: _obscureText,
                      suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        child: Icon(
                          !_obscureText ? Icons.visibility : Icons.visibility_off,
                          color: Colors.grey.withOpacity(0.8),
                        ),
                      ),
                    ),
                  ),
                ),
                // SizedBox(
                //   width: 60.w,
                //   child: Padding(
                //     padding: const EdgeInsets.fromLTRB(18, 14, 5, 14),
                //     child: Align(
                //       alignment: Alignment.centerRight,
                //       child: InkWell(
                //         onTap: () {
                //           Get.to(() => ForgotPassword(),
                //               transition: Transition.rightToLeft);
                //         },
                //         child: Text(
                //           "Forgot Password?",
                //           style: headingSmall.copyWith(
                //             fontSize: 13,
                //             color: Colors.black,
                //           ),
                //           textAlign: TextAlign.center,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                SizedBox(
                  height: 3.h,
                ),
                SizedBox(
                  width: 60.w,
                  child: CustomButton(
                    buttonText: "LOG IN",
                    onTap: () {
                      if(_key.currentState!.validate()){
                        print(_emailEditingController.text.toString()+_passwordEditingController.text.toString());
                        _authController.loginUser(_emailEditingController.text.toString(), _passwordEditingController.text.toString());
                      }

                      // Get.offAll(()=> HomeScreen());
                    },
                  ),
                ),
                ///Uncomment this if SignUp screen added
                // SizedBox(
                //   height: isPortrait ? 20.h : 4.h,
                // ),
                // Padding(
                //   padding: const EdgeInsets.all(10.0),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Text(
                //         "Don’t have an account?  ",
                //         style: headingSmall.copyWith(
                //             color: Colors.black54, fontSize: 13),
                //         textAlign: TextAlign.center,
                //       ),
                //       InkWell(
                //         onTap: () {
                //
                //         },
                //         child: Text(
                //           "Sign Up",
                //           style: headingSmall.copyWith(
                //               color: AppColors.buttonColor, fontSize: 13),
                //           textAlign: TextAlign.center,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                SizedBox(
                  height: 1.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
