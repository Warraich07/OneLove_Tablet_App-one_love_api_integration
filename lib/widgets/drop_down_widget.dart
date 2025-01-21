import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../constants/global_variables.dart';

class CustomDropDown extends StatefulWidget {
  final String dropDownTitle;
  const CustomDropDown({Key? key, required this.dropDownTitle})
      : super(key: key);

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  final List<String> items = [
    '09:00 AM',
    '09:30 AM',
    '10:00 AM',
    '10:30 AM',
    '11:00 AM',
    '11:30 AM',
    '12:00 PM',
    '12:30 PM',
    '01:00 PM',
    '01:30 PM',
    '02:00 PM',
    '02:30 PM',
    '03:00 PM',
    '03:30 PM',
    '04:00 PM',
    '04:30 PM',
    '05:00 PM',
    '05:30 PM',
    '06:00 PM',
    '06:30 PM',
    '07:00 PM',
    '07:30 PM',
    '08:00 PM',
    '08:30 PM',
    '09:00 PM',
    '09:30 PM',
    '10:00 PM',
    '10:30 PM',
    '11:00 PM',
    '11:30 PM',
    '12:00 AM',
    '12:30 AM',
    '01:00 AM',
    '01:30 AM',
    '02:00 AM',
    '02:30 AM',
    '03:00 AM',
    '03:30 AM',
    '04:00 AM',
    '04:30 AM',
    '05:00 AM',
    '05:30 AM',
    '06:00 AM',
    '06:30 AM',
    '07:00 AM',
    '07:30 AM',
    '08:00 AM',
    '08:30 AM',
  ];
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.black26,
          width: 1.4,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          isExpanded: true,
          hint: Row(
            children: [
              Icon(Icons.access_time_outlined),
              SizedBox(
                width: 8,
              ),
              Text(widget.dropDownTitle,
                  style: bodyNormal.copyWith(fontSize: 12)),
            ],
          ),
          items: items
              .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Center(
                      child: Text(
                        item,
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontFamily: 'PoppinsRegular'),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ))
              .toList(),
          value: selectedValue,
          onChanged: (value) {
            setState(() {
              selectedValue = value as String;
            });
          },
          iconStyleData: IconStyleData(
            icon: const Icon(
              Icons.keyboard_arrow_down_sharp,
              color: Colors.black,
            ),
          ),
          buttonStyleData: const ButtonStyleData(
            padding: EdgeInsets.only(left: 5, right: 10),
            elevation: 2,
          ),
          dropdownStyleData: DropdownStyleData(
            padding: null,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12)),
                color: Colors.white,
                border: Border.all(width: 2, color: Colors.white24)),
            maxHeight: 135,
            elevation: 8,
            offset: const Offset(-1, -3),
            scrollbarTheme: ScrollbarThemeData(
              radius: const Radius.circular(40),
              thickness: MaterialStateProperty.all<double>(6),
              thumbVisibility: MaterialStateProperty.all<bool>(true),
            ),
          ),
          style: TextStyle(
              fontSize: 14, color: Colors.black, fontFamily: 'PoppinsRegular'),
          menuItemStyleData: const MenuItemStyleData(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
          ),
        ),
      ),
    );
  }
}

///Custom DropDown Pricing

class CustomDropDownPricing extends StatefulWidget {
  final String dropDownTitle;
  const CustomDropDownPricing({Key? key, required this.dropDownTitle})
      : super(key: key);

  @override
  State<CustomDropDownPricing> createState() => _CustomDropDownPricingState();
}

class _CustomDropDownPricingState extends State<CustomDropDownPricing> {
  final List<String> items = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.black26,
          width: 1.4,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          isExpanded: true,
          hint: Row(
            children: [
              Icon(
                Icons.calendar_month_outlined,
                size: 20,
              ),
              SizedBox(
                width: 7,
              ),
              Text(widget.dropDownTitle,
                  style: bodyNormal.copyWith(
                      fontSize: 12,
                      fontFamily: "PoppinsSemiBold",
                      color: Colors.black54)),
            ],
          ),
          items: items
              .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Center(
                      child: Text(
                        item,
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontFamily: 'PoppinsRegular'),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ))
              .toList(),
          value: selectedValue,
          onChanged: (value) {
            setState(() {
              selectedValue = value as String;
            });
          },
          iconStyleData: IconStyleData(
            icon: const Icon(
              Icons.keyboard_arrow_down_sharp,
              color: Colors.black,
            ),
          ),
          buttonStyleData: const ButtonStyleData(
            padding: EdgeInsets.only(left: 5, right: 10),
            elevation: 2,
          ),
          dropdownStyleData: DropdownStyleData(
            padding: null,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12)),
                color: Colors.white,
                border: Border.all(width: 2, color: Colors.white24)),
            maxHeight: 135,
            elevation: 8,
            offset: const Offset(-1, -3),
            scrollbarTheme: ScrollbarThemeData(
              radius: const Radius.circular(40),
              thickness: MaterialStateProperty.all<double>(6),
              thumbVisibility: MaterialStateProperty.all<bool>(true),
            ),
          ),
          style: TextStyle(
              fontSize: 14, color: Colors.black, fontFamily: 'PoppinsRegular'),
          menuItemStyleData: const MenuItemStyleData(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
          ),
        ),
      ),
    );
  }
}

///Custom DropDown Currency

class CustomDropDownCurrency extends StatefulWidget {
  final String? selectedValue;
  final onChanged;
  const CustomDropDownCurrency({Key? key, this.selectedValue, this.onChanged})
      : super(key: key);

  @override
  State<CustomDropDownCurrency> createState() => _CustomDropDownCurrencyState();
}

class _CustomDropDownCurrencyState extends State<CustomDropDownCurrency> {
  final List<String> items = [
    "USD",
    "PKR",
    "EUR",
  ];
  String? selectedValue;

  @override
  void initState() {
    selectedValue = widget.selectedValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.black26,
          width: 1.4,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          isExpanded: true,
          hint: Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Text(widget.selectedValue!,
                style: bodyNormal.copyWith(
                    fontFamily: "PoppinsSemiBold", color: Colors.black54)),
          ),
          items: items
              .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: TextStyle(
                          fontSize: 16,
                          color: AppColors.primaryColor,
                          fontFamily: 'PoppinsSemiBold'),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ))
              .toList(),
          value: widget.selectedValue!,
          onChanged: widget.onChanged,
          iconStyleData: IconStyleData(
            icon: const Icon(
              Icons.keyboard_arrow_down_sharp,
              color: Colors.black,
            ),
          ),
          buttonStyleData: const ButtonStyleData(
            padding: EdgeInsets.only(left: 5, right: 10),
            elevation: 2,
          ),
          dropdownStyleData: DropdownStyleData(
            padding: null,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12)),
                color: Colors.white,
                border: Border.all(width: 2, color: Colors.white24)),
            maxHeight: 135,
            elevation: 8,
            offset: const Offset(-1, -3),
            scrollbarTheme: ScrollbarThemeData(
              radius: const Radius.circular(40),
              thickness: MaterialStateProperty.all<double>(6),
              thumbVisibility: MaterialStateProperty.all<bool>(true),
            ),
          ),
          style: TextStyle(
              fontSize: 14, color: Colors.black, fontFamily: 'PoppinsRegular'),
          menuItemStyleData: const MenuItemStyleData(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
          ),
        ),
      ),
    );
  }
}
