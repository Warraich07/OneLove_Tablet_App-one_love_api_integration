import 'package:one_love/constants/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../constants/custom_validators.dart';

class CountryCodePicker extends StatefulWidget {
  TextEditingController? phoneController;

  CountryCodePicker({super.key, this.phoneController});

  @override
  State<CountryCodePicker> createState() => _CountryCodePickerState();
}

class _CountryCodePickerState extends State<CountryCodePicker> {
  String _countryCode = '';
  String initialCountry = 'US';
  PhoneNumber number = PhoneNumber(isoCode: 'US');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        height: 60,
        padding: EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: AppColors.textFieldColor.withOpacity(0.5),
          border: Border.all(color: AppColors.textFieldColor.withOpacity(0.0), width: 0.7),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.transparent,
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.black,
                ),
                borderRadius: BorderRadius.circular(15.0),
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.white,
                ),
                borderRadius: BorderRadius.circular(15.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Colors.white,
                ),
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
          ),
          child: InternationalPhoneNumberInput(
            onInputChanged: (PhoneNumber number) {
              print(number.phoneNumber);
              print(number);
              if(widget.phoneController!=null){
                if (widget.phoneController!.text.isNotEmpty &&
                    widget.phoneController!.text.startsWith('0')) {
                  print('_PHONECONTROLLER: ${widget.phoneController!.text}');
                  widget.phoneController!.clear();
                  setState(() {});
                  return;
                }
              }

              setState(() {
                _countryCode = number.dialCode.toString();
              });
            },
            onInputValidated: (bool value) {},
            selectorConfig: const SelectorConfig(
              selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
              setSelectorButtonAsPrefixIcon: true,
            ),
            ignoreBlank: true,
            autoValidateMode: AutovalidateMode.disabled,
            selectorTextStyle:
                const TextStyle(color: Colors.black),
            hintText: 'Enter Mobile Number',
            initialValue: number,
            inputDecoration: InputDecoration(
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent)),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent)),
                hintText: 'Enter Mobile Number',
                hintStyle: headingSmall.copyWith(color: Color(0xff9f9f9f))),
            textStyle: headingSmall.copyWith(color: Colors.black),
            cursorColor: Colors.black,
            spaceBetweenSelectorAndTextField: 0,
            validator: (String? value) => CustomValidator.number(value),
            textFieldController: widget.phoneController,
            formatInput: true,
            keyboardType: const TextInputType.numberWithOptions(
                signed: false, decimal: false),
            inputBorder: InputBorder.none,
            onSaved: (PhoneNumber number) {
              print('On Saved: $number');
            },
          ),
        ),
      ),
    );
  }
}

