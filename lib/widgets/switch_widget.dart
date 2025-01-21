import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

import '../constants/global_variables.dart';

class SwitchWidget extends StatefulWidget {
  late bool isActive;
  final bool fromBoost;
  final Function(bool) onToggle;

  SwitchWidget(
      {super.key,
      required this.isActive,
      this.fromBoost = false,
      required this.onToggle});

  @override
  State<SwitchWidget> createState() => _SwitchWidgetState();
}

class _SwitchWidgetState extends State<SwitchWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45.0, // Adjust the width as needed
      child: FlutterSwitch(
        inactiveColor: Colors.black12,
        toggleColor: Colors.white,
        inactiveToggleColor: AppColors.primaryColor,
        activeColor: AppColors.primaryColor,
        width: 45.0,
        height: 25.0,
        valueFontSize: 12.0,
        toggleSize: 18.0,
        value: widget.isActive,
        onToggle: widget.onToggle,
      ),
    );
  }
}
