// import 'package:delayed_display/delayed_display.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:one_love/views/auth/reset_password.dart';
// import 'package:sizer/sizer.dart';
//
// import '../../constants/custom_validators.dart';
// import '../../constants/global_variables.dart';
// import '../../controllers/auth_controller.dart';
// import '../../utils/custom_dialogbox.dart';
// import '../../widgets/custom_widgets.dart';
// import '../../widgets/text_form_fields.dart';
// import 'forgot_password.dart';
//
// class VerifyOTP extends StatefulWidget {
//   final String email;
//   final bool fromSignUp;
//   const VerifyOTP({Key? key, required this.email, required this.fromSignUp}) : super(key: key);
//
//   @override
//   State<VerifyOTP> createState() => _VerifyOTPState();
// }
//
// class _VerifyOTPState extends State<VerifyOTP> {
//   final GlobalKey<FormState> _key = GlobalKey<FormState>();
//   final AuthController _authController=Get.find();
//   @override
//   Widget build(BuildContext context) {
//
//     var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         automaticallyImplyLeading: false,
//         title: CustomAppBar(
//           pageTitle: "",
//           onTapLeading: () {
//               Get.off(() => ForgotPassword());
//           },
//           leadingButton: Icon(
//             Icons.arrow_back_ios,
//             color: Colors.black,
//             size: 22,
//           ),
//         ),
//       ),
//       body: GestureDetector(
//         onTap: (){
//           FocusScope.of(context).unfocus();
//         },
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               SizedBox(height: isPortrait ?20.h : 2.h,),
//               Padding(
//                 padding:
//                 const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
//                 child: DelayedDisplay(
//                   delay: Duration(milliseconds: 300),
//                   slidingBeginOffset: Offset(0, -1),
//                   child: Image.asset("assets/images/app_logo.png", scale: 5,),
//                 ),
//               ),
//               SizedBox(
//                 height: 2.h,
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 18.0),
//                 child: Text(
//                   "OTP Verification",
//                   style: headingLarge,
//                 ),
//               ),
//               SizedBox(height: 10,),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 18.0),
//                 child: Text(
//                   "Enter the verification code sent to your email address",
//                   style: authSubHeading,
//                 ),
//               ),
//               SizedBox(
//                 height: 3.h,
//               ),
//               Form(
//                 key: _key,
//                 child: SizedBox(
//                   width: 60.w,
//                   child: OtpField(onCodeChanged: (String ) {  },
//                         // (value) => CustomValidator.password(value),
//                       // email: widget.email.toString(),
//                       ),
//                 ),
//               ),
//               SizedBox(
//                 height: 2.h,
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       "Didn't receive any code? ",
//                       style: headingSmall.copyWith(
//                           color: Colors.black54, fontSize: 14),
//                       textAlign: TextAlign.center,
//                     ),
//                     const SizedBox(
//                       width: 5,
//                     ),
//                     InkWell(
//                       onTap: () {
//                         _authController.sendOtpCode(_authController.verifiedEmail.value);
//                         // Get.off(() => SignUpScreen(
//                         //   controller: TextEditingController(),
//                         // ));
//                       },
//                       child: Text(
//                         "Resend",
//                         style: bodyNormal.copyWith(
//                           color: AppColors.buttonColor,
//                           fontWeight: FontWeight.w600,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 width: 60.w,
//                 child: Padding(
//                   padding:
//                       const EdgeInsets.symmetric(vertical: 4),
//                   child: CustomButton(
//                       buttonText: "VERIFY",
//                       onTap: () {
//                         if(_authController.otpCode.value!=_authController.verifiedOtp.value){
//                           CustomDialog.showErrorDialog(description: "Invalid OTP");
//                         }else if(_authController.otpCode.isEmpty){
//                           CustomDialog.showErrorDialog(description: "Please enter otp");
//                         }
//                         else{
//                           Get.to(() => ResetPassword(email: widget.email));
//                           _authController.updateOtpCode("");
//
//                         }
//                         // _authController.verifyForgetPasswordCode();
//
//                         //       if(_key.currentState!.validate()){
//                         //         print("ok");
//                         //       }
//                         // if (key.currentState!.validate()) {
//                         //   _authController.verifyOTP(map, context);
//                         // }
//                         // PageTransition.pageNavigation(page: const ResetPassword());
//                       }),
//                 ),
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
