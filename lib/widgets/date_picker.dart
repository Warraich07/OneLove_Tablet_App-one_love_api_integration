import 'package:one_love/constants/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/general_controller.dart';

class DatePickerWidget extends StatefulWidget {
  final int index;
  final bool isSwitch;
  final String title;

  const DatePickerWidget(
      {super.key,
      required this.index,
      this.isSwitch = true,
      required this.title});

  @override
  _DatePickerWidgetState createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  final generalController = Get.find<GeneralController>();
  DateTime? selectedDate;
  bool switchValue = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50.0),
        side: BorderSide.none,
      ),
      elevation: 0,
      color: AppColors.textFieldColor.withOpacity(0.3),
      child: ListTile(
        horizontalTitleGap: 0,
        contentPadding: EdgeInsets.symmetric(horizontal: 24.0),
        title: Text(
          selectedDate == null
              ? widget.title
              : '${DateFormat.yMMMd().format(selectedDate!)}',
          style: headingSmall.copyWith(
              color: selectedDate == null ? Colors.black54 : Colors.black),
        ),
        // Format the date
        trailing: Icon(
          Icons.calendar_month_outlined,
          color: Colors.black,
        ),
        onTap: () {
          _showDatePicker(context);
        },
      ),
    );
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppColors.primaryColor, // Change primary color
            hintColor: AppColors.secondaryColor, // Change accent color
            colorScheme: ColorScheme.light(
                primary: AppColors.buttonColor,
                background: Colors.black // Change background color
                ),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        generalController.selectedDate[widget.index] = pickedDate.toString();
      });
    }
  }
}
