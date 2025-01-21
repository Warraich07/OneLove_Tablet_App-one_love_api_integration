import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/general_controller.dart';

class TimePickerWidget extends StatefulWidget {
  final int index;
  const TimePickerWidget({super.key, required this.index});
  @override
  _TimePickerWidgetState createState() => _TimePickerWidgetState();
}

class _TimePickerWidgetState extends State<TimePickerWidget> {
  final generalController = Get.find<GeneralController>();
  TimeOfDay? selectedTime;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: Colors.black12),
      ),
      child: ListTile(
        horizontalTitleGap: 0,
        contentPadding:
            EdgeInsets.only(left: 26.0, right: 16), // Adjust padding
        title: Text(selectedTime == null
            ? 'Select Time'
            : DateFormat.jm().format(DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day,
                selectedTime!.hour,
                selectedTime!.minute))),
        trailing:  Icon(Icons.access_time),
        onTap: () {
          _showTimePicker(context);
        },
      ),
    );
  }

  Future<void> _showTimePicker(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      useRootNavigator: false,
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );

    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }
}
