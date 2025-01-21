import 'package:flutter/material.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../constants/global_variables.dart';

class CustomButton extends StatefulWidget {
  final String? buttonText;
  final Function onTap;
  final Color buttonClr;
  final Color textClr;
  final double fontSize;
  const CustomButton(
      {Key? key,
      this.buttonText,
      required this.onTap,
      this.buttonClr = AppColors.buttonColor, this.textClr = Colors.white, this.fontSize = 18})
      : super(key: key);

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ZoomTapAnimation(
        onTap: () {
          widget.onTap();
        },
        onLongTap: () {},
        enableLongTapRepeatEvent: false,
        longTapRepeatDuration: const Duration(milliseconds: 100),
        begin: 1.0,
        end: 0.93,
        beginDuration: const Duration(milliseconds: 20),
        endDuration: const Duration(milliseconds: 120),
        beginCurve: Curves.decelerate,
        endCurve: Curves.fastOutSlowIn,
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              color: widget.buttonClr,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(widget.buttonText.toString(),
                  style: headingSmall.copyWith(
                    fontSize: widget.fontSize,
                    color: widget.textClr,
                  )),
            )),
      ),
    );
  }
}

class CustomAppBar extends StatefulWidget {
  final String pageTitle;
  final bool isBackButton;
  final double fontSize;
  final Function onTapLeading;
  final Function? onTapActions;
  final Widget? leadingButton;
  final Widget? actionButton;
  const CustomAppBar(
      {Key? key,
      required this.pageTitle,
      required this.onTapLeading,
      this.onTapActions,
      this.leadingButton,
      this.actionButton,
      this.fontSize = 21,  this.isBackButton = true})
      : super(key: key);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
         widget.isBackButton == true? ZoomTapAnimation(
            onTap: () {
              widget.onTapLeading();
            },
            onLongTap: () {},
            enableLongTapRepeatEvent: false,
            longTapRepeatDuration: const Duration(milliseconds: 100),
            begin: 1.0,
            end: 0.93,
            beginDuration: const Duration(milliseconds: 20),
            endDuration: const Duration(milliseconds: 120),
            beginCurve: Curves.decelerate,
            endCurve: Curves.fastOutSlowIn,
            child:
                Container(
                  alignment: Alignment.centerLeft,
                  height: 30, width: 30,
                    padding: EdgeInsets.only(left: 0),
                    margin: EdgeInsets.only(right: 0),
                    child: Icon(
                      Icons.arrow_back,
                      size: 30,
                      color: Colors.black,
                    ),),
          ) : SizedBox.shrink(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 0.0),
              child: Text(
                widget.pageTitle,
                style: headingLarge.copyWith(fontSize: widget.fontSize),
              ),
            ),
          ),
          widget.actionButton != null
              ? Align(
                  alignment: Alignment.centerRight,
                  child: ZoomTapAnimation(
                    onTap: () {
                      widget.onTapActions!();
                    },
                    onLongTap: () {},
                    enableLongTapRepeatEvent: false,
                    longTapRepeatDuration: const Duration(milliseconds: 100),
                    begin: 1.0,
                    end: 0.93,
                    beginDuration: const Duration(milliseconds: 20),
                    endDuration: const Duration(milliseconds: 120),
                    beginCurve: Curves.decelerate,
                    endCurve: Curves.fastOutSlowIn,
                    child: Container(
                        padding: EdgeInsets.only(left: 10),
                        child: widget.actionButton),
                  ),
                )
              : SizedBox(
                  width: 10,
                ),
        ],
      ),
    );
  }
}
