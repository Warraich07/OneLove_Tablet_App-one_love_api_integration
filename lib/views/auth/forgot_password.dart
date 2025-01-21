// import 'package:delayed_display/delayed_display.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:one_love/views/auth/verify_otp.dart';
// import 'package:sizer/sizer.dart';
//
// import '../../constants/app_images.dart';
// import '../../constants/custom_validators.dart';
// import '../../constants/global_variables.dart';
// import '../../controllers/auth_controller.dart';
// import '../../widgets/custom_widgets.dart';
// import '../../widgets/text_form_fields.dart';
//
// class ForgotPassword extends StatefulWidget {
//   const ForgotPassword({Key? key}) : super(key: key);
//
//   @override
//   State<ForgotPassword> createState() => _ForgotPasswordState();
// }
//
// class _ForgotPasswordState extends State<ForgotPassword> {
//   final GlobalKey<FormState> _key = GlobalKey<FormState>();
//   final TextEditingController _emailEditingController = TextEditingController();
//   final AuthController _authController=Get.find();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   FocusNode _focusNode=FocusNode();
//   @override
//   Widget build(BuildContext context) {
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _focusNode.requestFocus();
//     });
//     var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         automaticallyImplyLeading: false,
//         title: CustomAppBar(
//           pageTitle: "",
//           onTapLeading: () {
//             // Get.off(() => LoginScreen());
//             Get.back();
//           },
//           leadingButton: Icon(
//             Icons.arrow_back_ios,
//             color: Colors.black,
//             size: 22,
//           ),
//         ),
//       ),
//       body: Form(
//         key: _key,
//         child: SingleChildScrollView(
//           child: Center(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 SizedBox(height: isPortrait ?20.h : 2.h,),
//                 Padding(
//                   padding:
//                   const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
//                   child: DelayedDisplay(
//                     delay: Duration(milliseconds: 300),
//                     slidingBeginOffset: Offset(0, -1),
//                     child: Image.asset("assets/images/app_logo.png", scale: 2,),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 4.h,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 18.0),
//                   child: Text(
//                     "Forgot Password?",
//                     style: headingLarge,
//                   ),
//                 ),
//                 SizedBox(height: 10,),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 18.0),
//                   child: Text(
//                     "Enter your email address to reset your password",
//                     style: authSubHeading,
//                   ),
//                 ),
//                 SizedBox(
//                   height: 80,
//                 ),
//                 Form(
//                   key: _formKey,
//                   child: DelayedDisplay(
//                     delay: Duration(milliseconds: 400),
//                     slidingBeginOffset: Offset(0, -1),
//                     child: SizedBox(
//                       width: 60.w,
//                       child: AuthTextField(
//                         keyboardType: TextInputType.emailAddress,
//                         controller: _emailEditingController,
//                         validator: (value) => CustomValidator.email(value),
//                         hintText: "Email Address",
//                         focusNode: _focusNode,
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 50,
//                 ),
//                 SizedBox(
//                   width: 60.w,
//                   child: CustomButton(
//                     buttonText: "SEND CODE",
//                     onTap: () async {
//                       if(_formKey.currentState!.validate()){
//                         _authController.sendOtpCode(_emailEditingController.text.toString());
//                       }
//                       // _authController.sendForgetPasswordCode(_emailEditingController.text.toString());
//                       // Get.to(() => VerifyOTP(email: "", fromSignUp: false,));
//
//                       // if (_key.currentState!.validate()) {
//                       //   print(_emailEditingController.text.toString());
//                       //   // _authController.forgotPassword(map, context);
//                       // }
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
