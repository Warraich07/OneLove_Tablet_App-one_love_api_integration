// import 'package:delayed_display/delayed_display.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:one_love/views/auth/login_screen.dart';
// import 'package:sizer/sizer.dart';
//
// import '../../constants/app_images.dart';
// import '../../constants/custom_validators.dart';
// import '../../constants/global_variables.dart';
// import '../../controllers/auth_controller.dart';
// import '../../widgets/custom_widgets.dart';
// import '../../widgets/text_form_fields.dart';
//
// class ResetPassword extends StatefulWidget {
//   final email;
//   const ResetPassword({
//     required this.email,
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   State<ResetPassword> createState() => _ResetPasswordState();
// }
//
// class _ResetPasswordState extends State<ResetPassword> {
//   bool _obscureText = true;
//   bool _obscureTextConfirm = true;
//   final GlobalKey<FormState> _key = GlobalKey<FormState>();
//   final TextEditingController _passwordEditingController = TextEditingController();
//   final TextEditingController _confirmPasswordEditingController = TextEditingController();
//   final AuthController _authController=Get.find();
//   FocusNode _focusNode=FocusNode();
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _focusNode.requestFocus();
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     // WidgetsBinding.instance.addPostFrameCallback((_) {
//     //   _focusNode.requestFocus();
//     // });
//     var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         automaticallyImplyLeading: false,
//         title: CustomAppBar(
//           pageTitle: "",
//           onTapLeading: () {
//             Get.off(() => LogInScreen());
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
//                   height: 2.h,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 18.0),
//                   child: Text(
//                     "Reset Password",
//                     style: headingLarge,
//                   ),
//                 ),
//                 SizedBox(height: 10,),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 18.0),
//                   child: Text(
//                     "Create new password for your account",
//                     style: authSubHeading,
//                   ),
//                 ),
//                 SizedBox(
//                   height: 60,
//                 ),
//                 DelayedDisplay(
//                   delay: Duration(milliseconds: 400),
//                   slidingBeginOffset: Offset(0, -1),
//                   child: SizedBox(
//                     width: 60.w,
//                     child: AuthTextField(
//                       controller: _passwordEditingController,
//                       focusNode: _focusNode,
//                       validator: (value) => CustomValidator.password(value),
//                       hintText: "New Password",
//                       isObscure: _obscureText,
//                       suffixIcon: InkWell(
//                         onTap: () {
//                           setState(() {
//                             _obscureText = !_obscureText;
//                           });
//                         },
//                         child: Icon(
//                           !_obscureText ? Icons.visibility : Icons.visibility_off,
//                           color: Colors.grey.withOpacity(0.8),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 DelayedDisplay(
//                   delay: Duration(milliseconds: 400),
//                   slidingBeginOffset: Offset(0, -1),
//                   child: SizedBox(
//                     width: 60.w,
//                     child: AuthTextField(
//                       controller: _confirmPasswordEditingController,
//                       validator: (value) => CustomValidator.confirmPassword(
//                           value, _passwordEditingController.text.toString()),
//                       hintText: "Confirm Password",
//                       isObscure: _obscureTextConfirm,
//                       suffixIcon: InkWell(
//                         onTap: () {
//                           setState(() {
//                             _obscureTextConfirm = !_obscureTextConfirm;
//                           });
//                         },
//                         child: Icon(
//                           !_obscureTextConfirm
//                               ? Icons.visibility
//                               : Icons.visibility_off,
//                           color: Colors.grey.withOpacity(0.8),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 50,
//                 ),
//                 SizedBox(
//                   width: 60.w,
//                   child: CustomButton(
//                     buttonText: "CONTINUE",
//                     onTap: () {
//                       _authController.resetPassword(_passwordEditingController.text.toString(), _confirmPasswordEditingController.text.toString(), widget.email);
//                       // Get.offAll(() => LogInScreen());
//                       // Map<String, String> map = {
//                       //   "email": widget.email.toString(),
//                       //   'password': passwordEditingController.text.toString(),
//                       //   'confirm_password':
//                       //       confirmPasswordEditingController.text.toString(),
//                       // };
//                       // if (_key.currentState!.validate()) {
//                       //   print(_passwordEditingController.text.toString());
//                       //   // _authController.changePassword(map, context);
//                       // }
//                     },
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
