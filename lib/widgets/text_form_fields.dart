import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:one_love/controllers/auth_controller.dart';

import '../constants/global_variables.dart';

/// Text Field Auth Screens Only
class AuthTextField extends StatefulWidget {
  final String hintText;
  final double hintTextSize;
  final double horizontalPadding;
  final double prefixLeftPadding;
  final Widget? suffixIcon;
  final String? prefixIcon;
  final TextAlign textAlign;
  final bool? isObscure;
  final bool? readOnly;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final FocusNode? focusNode;

  const AuthTextField({
    Key? key,
    this.controller,
    required this.hintText,
    this.suffixIcon,
    this.isObscure,
    this.readOnly,
    this.prefixIcon,
    this.validator,
    this.keyboardType,
    this.hintTextSize = 16,
    this.horizontalPadding = 20,
    this.prefixLeftPadding = 26,
    this.textAlign = TextAlign.left,
    this.focusNode
  }) : super(key: key);

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: TextFormField(
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          obscureText: widget.isObscure ?? false,
          readOnly: widget.readOnly ?? false,
          controller: widget.controller,
          cursorColor: Colors.black,
          textAlign: widget.textAlign,
          style: headingSmall.copyWith(fontSize: 17),
          focusNode: widget.focusNode,
          decoration: InputDecoration(
              fillColor: AppColors.textFieldColor.withOpacity(0.5),
              filled: true,
              contentPadding: EdgeInsets.symmetric(
                  horizontal: widget.horizontalPadding, vertical: 18),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                    color: AppColors.textFieldColor.withOpacity(0.0),
                    width: 0.7),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                    color: AppColors.textFieldColor.withOpacity(0.0),
                    width: 0.7),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                    color: AppColors.textFieldColor.withOpacity(0.0),
                    width: 0.7),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                    color: AppColors.textFieldColor, width: 0.7),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                    color: AppColors.textFieldColor.withOpacity(0.0),
                    width: 0.7),
              ),
              hintText: widget.hintText,
              hintStyle: bodyNormal.copyWith(
                  color: Colors.black54, fontSize: widget.hintTextSize),
              suffixIcon: Padding(
                padding: const EdgeInsets.only(right: 15),
                child: widget.suffixIcon,
              ),
              suffixIconColor: Colors.black54,
              prefixIcon: widget.prefixIcon == null
                  ? Padding(
                padding: EdgeInsets.only(left: widget.prefixLeftPadding),
                child: SizedBox(),
              )
                  : Padding(
                padding: EdgeInsets.only(left: 26.0, right: 10),
                child: SizedBox(

                  width: 16,
                  child: Image.asset(
                    widget.prefixIcon!,
                  ),
                ),
              ),
              prefixIconColor: Color(0xffa2a2a2),
              prefixIconConstraints: const BoxConstraints(
                maxHeight: 30,
                minHeight: 30,
              )),
        ),
      ),
    );
  }
}

/// Text Field
class CustomTextField extends StatefulWidget {
  final String hintText;
  final Widget? suffixIcon;
  final String? prefixIcon;
  final bool? isObscure;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final onChanged;
  final String? suffixText;
  final String? prefixText;
  const CustomTextField(
      {Key? key,
      required this.hintText,
      this.suffixIcon,
      this.isObscure,
      this.prefixIcon,
      this.validator,
      this.keyboardType,
      this.suffixText,
      this.prefixText,
      this.onChanged,
      this.controller})
      : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: TextFormField(
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          obscureText: widget.isObscure ?? false,
          controller: widget.controller ?? null,
          cursorColor: Colors.black,
          onChanged: widget.onChanged ?? null,
          style: headingSmall.copyWith(fontSize: 15),
          decoration: InputDecoration(
              fillColor: AppColors.textFieldColor.withOpacity(0.2),
              filled: true,
              contentPadding: EdgeInsets.symmetric(
                  horizontal: 20, vertical: 18),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100),
                borderSide: BorderSide(
                    color: AppColors.textFieldColor.withOpacity(0.0),
                    width: 0.7),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100),
                borderSide: BorderSide(
                    color: AppColors.textFieldColor.withOpacity(0.0),
                    width: 0.7),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100),
                borderSide: BorderSide(
                    color: AppColors.textFieldColor.withOpacity(0.0),
                    width: 0.7),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100),
                borderSide: const BorderSide(
                    color: AppColors.textFieldColor, width: 0.7),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100),
                borderSide: BorderSide(
                    color: AppColors.textFieldColor.withOpacity(0.0),
                    width: 0.7),
              ),
              hintText: widget.hintText,
              hintStyle: bodyNormal.copyWith(
                  color: Colors.black54, fontSize: 15),
              suffixIcon: Padding(
                padding: const EdgeInsets.only(right: 15),
                child: widget.suffixIcon,
              ),
              suffixIconColor: Colors.black54,
              prefixIcon: widget.prefixIcon == null
                  ? Padding(
                padding: EdgeInsets.only(left: 26),
                child: SizedBox(),
              )
                  : Padding(
                padding: EdgeInsets.only(left: 26.0, right: 10),
                child: SizedBox(

                  width: 16,
                  child: Image.asset(
                    widget.prefixIcon!,
                  ),
                ),
              ),
              prefixIconColor: Color(0xffa2a2a2),
              prefixIconConstraints: const BoxConstraints(
                maxHeight: 30,
                minHeight: 30,
              )),
        ),
      ),
    );
  }
}

///Search Text Field
class SearchTextField extends StatefulWidget {
  final String hintText;
  final Widget? suffixIcon;
  final String? prefixIcon;
  final bool? isObscure;
  final FormFieldValidator<String>? validator;
  const SearchTextField(
      {Key? key,
      required this.hintText,
      this.suffixIcon,
      this.isObscure,
      this.prefixIcon,
      this.validator})
      : super(key: key);

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 100.w,
      // height: 54,
      child: Center(
        child: TextFormField(
          maxLines: 1,
          expands: false,
          validator: widget.validator,
          obscureText: widget.isObscure ?? false,
          controller: _textEditingController,
          cursorColor: Colors.black,
          style: headingSmall.copyWith(fontSize: 13),
          decoration: InputDecoration(
              filled: true,
              fillColor: Colors.transparent,
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                    color: AppColors.textFieldColor.withOpacity(0.5),
                    width: 0.7),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                    color: AppColors.textFieldColor.withOpacity(0.5),
                    width: 0.7),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                    color: AppColors.textFieldColor.withOpacity(0.5),
                    width: 0.7),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                    color: AppColors.textFieldColor.withOpacity(0.5),
                    width: 0.7),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                    color: AppColors.textFieldColor.withOpacity(0.5),
                    width: 0.7),
              ),
              hintText: widget.hintText,
              hintStyle: headingSmall.copyWith(color: Colors.black38),
              suffixIcon: widget.suffixIcon,
              suffixIconColor: Colors.black,
              prefixIcon: widget.prefixIcon == null
                  ? Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: SizedBox(),
              )
                  : Padding(
                padding: EdgeInsets.only(left: 20.0, right: 10),
                child: SizedBox(
                  width: 16,
                  child: Image.asset(
                    widget.prefixIcon!,
                  ),
                ),
              ),
              prefixIconColor: Colors.white,
              prefixIconConstraints: const BoxConstraints(
                maxHeight: 30,
                minHeight: 30,
              )),
        ),
      ),
    );
  }
}


///Otp Fields
class OtpField extends StatefulWidget {
   OtpField({
    Key? key,required this.onCodeChanged
  }) : super(key: key);
  void Function(String)? onCodeChanged;
  @override
  State<OtpField> createState() => _OtpFieldState();
}

class _OtpFieldState extends State<OtpField> {
  AuthController _authController=Get.find();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: OtpTextField(
        // enabled: false,
        // autoFocus: false,
        numberOfFields: 4,
        fieldWidth: 90,
        borderWidth: 1.2,
        margin: const EdgeInsets.fromLTRB(8, 0, 0, 0),
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        keyboardType: TextInputType.number,
        borderRadius: BorderRadius.circular(15),
        fillColor: AppColors.textFieldColor.withOpacity(0.6),
        filled: true,
        borderColor: AppColors.primaryColor.withOpacity(0.4),
        focusedBorderColor: AppColors.primaryColor.withOpacity(0.9),
        enabledBorderColor: AppColors.textFieldColor.withOpacity(0.3),
        disabledBorderColor: AppColors.textFieldColor.withOpacity(0.3),
        cursorColor: AppColors.primaryColor,
        showFieldAsBox: true,
        textStyle: headingSmall.copyWith(fontSize: 25),
        //runs when a code is typed in
        onCodeChanged: widget.onCodeChanged,
        //     (String code) {
        //   //handle validation or checks here
        //   print(code);
        // },
        //runs when every textField is filled
        onSubmit: (String verificationCode) {
          if(verificationCode.length==4){
            _authController.updateOtpCode(verificationCode.toString());
            print( _authController.otpCode.value);
          }else{
            print("less than 4");
          }

          // showCustomDialog(context, 'OTP Verified!', 'Continue', '');
          // Get.to(() => ResetPassword(controller: TextEditingController()));
        }, // end onSubmit
      ),
    );
  }
}
