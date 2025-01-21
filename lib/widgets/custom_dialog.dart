import 'dart:ui';

import 'package:delayed_display/delayed_display.dart';
import 'package:one_love/widgets/text_form_fields.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../constants/global_variables.dart';
import '../constants/custom_validators.dart';
import '../controllers/room_controller.dart';

///Custom Dialog Single Button
RoomController _roomController=Get.find();
Future<void> showCustomDialog(
  BuildContext context,
  String image,
  String title,
  String desc,
  String buttonText,
  final Function onTap,
  Function? onTapClose,
) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 6,
          sigmaY: 6,
        ),
        child: Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).orientation == Orientation.portrait? 20.w : 50.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          backgroundColor: Colors.white,
          child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () {
                      onTapClose != null ? onTapClose() : Get.back();
                    },
                    child: Container(
                      height: 45,
                      width: 45,
                      margin: EdgeInsets.only(right: 10),
                      padding: EdgeInsets.all(0),
                      child: Center(
                        child: Image.asset(
                          "assets/images/popup/cancel_icon.png",
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  height: 120,
                  child: image == ""
                      ? SizedBox.shrink()
                      : Image.asset(image, fit: BoxFit.fill),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Text(
                    title,
                    style: headingLarge.copyWith(
                        color: Colors.black, fontSize: 26),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 26.0, vertical: 5),
                  child: Text(
                    desc,
                    style: authSubHeading.copyWith(fontSize: 18, height: 1.5),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 22.0, vertical: 8),
                  child: ZoomTapAnimation(
                      onTap: () {
                        Get.back();
                        onTap();
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
                        height: 56,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.buttonColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(buttonText,
                              style: headingSmall.copyWith(
                                fontSize: 17,
                                color: Colors.white,
                              )),
                        ),
                      )),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            );
          }),
        ),
      );
    },
  );
}

Future<void> customDialogTextField(
  BuildContext context,
  String title,
  String buttonText,
  String hintText,
  final Function onTap,
    TextEditingController? controller,
    FocusNode focusNode,

) async {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    focusNode.requestFocus();
  });
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 6,
          sigmaY: 6,
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Dialog(
            insetPadding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).orientation == Orientation.portrait? 20.w : 50.w),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            backgroundColor: Colors.white,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        height: 45,
                        width: 45,
                        margin: EdgeInsets.only(right: 10),
                        child: Center(
                          child: Image.asset(
                            "assets/images/popup/cancel_icon.png",
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Text(
                      title,
                      style: headingLarge.copyWith(
                          color: Colors.black, fontSize: 22),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 45,
                  ),
                  Form(
                    key: _roomController.roomKey,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                      child: AuthTextField(
                        controller: controller,
                        keyboardType: TextInputType.name,
                        hintText: hintText,
                        validator: (value) => CustomValidator.isEmpty(value),
                          focusNode:focusNode
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 22.0, vertical: 8),
                    child: ZoomTapAnimation(
                        onTap: () {
                          onTap();
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
                          height: 56,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.buttonColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(buttonText,
                                style: headingSmall.copyWith(
                                  fontSize: 17,
                                  color: Colors.white,
                                )),
                          ),
                        )),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

Future<void> customDialogNewTask(
  BuildContext context,
  String title,
  String buttonText,
  final Function onTap,
    TextEditingController? controller,
    FocusNode focusNode,
) async {
  // String? taskDurability = 'Daily';

  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        focusNode.requestFocus();
      });
      RoomController _roomController=Get.find();
      return BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 6,
          sigmaY: 6,
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Dialog(
            insetPadding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).orientation == Orientation.portrait? 20.w : 50.w),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            backgroundColor: Colors.white,
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Form(
                  key: _roomController.createTaskKey,
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 10),
                        Align(
                          alignment: Alignment.topRight,
                          child: InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Container(
                              height: 45,
                              width: 45,
                              margin: EdgeInsets.only(right: 10),
                              child: Center(
                                child: Image.asset(
                                  "assets/images/popup/cancel_icon.png",
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
                          child: Text(
                            title,
                            style: headingLarge.copyWith(
                              color: Colors.black,
                              fontSize: 26,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 35),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                          child: AuthTextField(
                            controller: controller,
                            keyboardType: TextInputType.name,
                            hintText: "Task title",
                            validator: (value) => CustomValidator.isEmpty(value),
                            focusNode: focusNode,

                          ),
                        ),
                        SizedBox(height: 40),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 22.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Task Frequency", style: headingMedium),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 25,
                                        child: Radio<String>(
                                          value: 'Daily',
                                          groupValue: _roomController.taskDurability.value,
                                          onChanged: (String? value) {
                                            setState(() {

                                              _roomController.updateTaskDurability(value.toString(),'1');
                                              // taskDurability = value;
                                              print(_roomController.taskDurability.toString());
                                            });
                                          },
                                        ),
                                      ),
                                      Text(
                                        "Daily",
                                        style: headingSmall.copyWith(fontSize: 17),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 25,
                                        child: Radio<String>(
                                          value: 'Weekly',
                                          groupValue: _roomController.taskDurability.value,
                                          onChanged: (String? value) {
                                            setState(() {
                                              _roomController.updateTaskDurability(value.toString(),'2');
                                              // taskDurability = value;
                                              print(_roomController.taskDurability.toString());
                                            });
                                          },
                                        ),
                                      ),
                                      Text(
                                        "Weekly",
                                        style: headingSmall.copyWith(fontSize: 17),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 25,
                                        child: Radio<String>(
                                          value: 'Monthly',
                                          groupValue: _roomController.taskDurability.value,
                                          onChanged: (String? value) {
                                            setState(() {
                                              _roomController.updateTaskDurability(value.toString(),'3');
                                              // taskDurability = value;
                                              print(_roomController.taskDurability.toString());
                                            });
                                          },
                                        ),
                                      ),
                                      Text(
                                        "Monthly",
                                        style: headingSmall.copyWith(fontSize: 17),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 22.0, vertical: 8),
                          child: ZoomTapAnimation(
                            onTap: () {
                              onTap();
                            },
                            onLongTap: () {},
                            enableLongTapRepeatEvent: false,
                            longTapRepeatDuration:
                                const Duration(milliseconds: 100),
                            begin: 1.0,
                            end: 0.93,
                            beginDuration: const Duration(milliseconds: 20),
                            endDuration: const Duration(milliseconds: 120),
                            beginCurve: Curves.decelerate,
                            endCurve: Curves.fastOutSlowIn,
                            child: Container(
                              height: 56,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.buttonColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(buttonText,
                                    style: headingSmall.copyWith(
                                      fontSize: 17,
                                      color: Colors.white,
                                    )),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );
    },
  );
}

///Enter credentials to access dashboard
Future<void> customDialogEnterCredentials(
  BuildContext context,
  String title,
  String buttonText,
  bool isObscure,
  final Function onTap,

    TextEditingController adminEmailController,
    TextEditingController adminPasswordController,
    dynamic Function()? onLoginTap,
    FocusNode focusNode

) async {
  bool _obscureText = isObscure;
  WidgetsBinding.instance.addPostFrameCallback((_) {
    focusNode.requestFocus();
  });
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {

      return BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 6,
          sigmaY: 6,
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Dialog(
            insetPadding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).orientation == Orientation.portrait? 20.w : 50.w),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            backgroundColor: Colors.white,
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Form(
                    key: _roomController.adminKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Container(
                              height: 45,
                              width: 45,
                              margin: EdgeInsets.only(right: 10),
                              child: Center(
                                child: Image.asset(
                                  "assets/images/popup/cancel_icon.png",
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
                          child: Text(
                            title,
                            style: headingLarge.copyWith(
                              color: Colors.black,
                              fontSize: 22,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(
                          height: 45,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                          child: AuthTextField(
                            controller: adminEmailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) => CustomValidator.email(value),
                            hintText: "Email Address",
                            focusNode: focusNode,

                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                          child: AuthTextField(
                            controller: adminPasswordController,
                            keyboardType: TextInputType.visiblePassword,
                            validator: (value) => CustomValidator.password(value),
                            hintText: "Password",
                            isObscure: _obscureText,
                            suffixIcon: InkWell(
                              onTap: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              child: Icon(
                                !_obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey.withOpacity(0.8),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 22.0, vertical: 8),
                          child: ZoomTapAnimation(
                            onTap: onLoginTap,
                            onLongTap: () {},
                            enableLongTapRepeatEvent: false,
                            longTapRepeatDuration:
                                const Duration(milliseconds: 100),
                            begin: 1.0,
                            end: 0.93,
                            beginDuration: const Duration(milliseconds: 20),
                            endDuration: const Duration(milliseconds: 120),
                            beginCurve: Curves.decelerate,
                            endCurve: Curves.fastOutSlowIn,
                            child: Container(
                              height: 56,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.buttonColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  buttonText,
                                  style: headingSmall.copyWith(
                                    fontSize: 17,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );
    },
  );
}

///Report a problem
Future<void> customDialogReportProblem(
  BuildContext context,
  String title,
  String buttonText,
  final Function onTap,
    TextEditingController _problemTitleController,
    TextEditingController _problemController,
    TextEditingController _nameController,
) async {
  FocusNode _focusNode=FocusNode();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    _focusNode.requestFocus();
  });
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 6,
          sigmaY: 6,
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Dialog(
            insetPadding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).orientation == Orientation.portrait? 20.w : 50.w),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            backgroundColor: Colors.white,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Form(
                key: _roomController.reportProblemKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          height: 45,
                          width: 45,
                          margin: EdgeInsets.only(right: 10),
                          child: Center(
                            child: Image.asset(
                              "assets/images/popup/cancel_icon.png",
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Text(
                        title,
                        style: headingLarge.copyWith(
                            color: Colors.black, fontSize: 22),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 45,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                      child: AuthTextField(
                        controller: _nameController,
                        keyboardType: TextInputType.name,
                        hintText: "Enter Your Name",
                        validator: (value) => CustomValidator.isEmptyUserName(value),
                        focusNode: _focusNode,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                      child: AuthTextField(
                        controller: _problemTitleController,
                        keyboardType: TextInputType.name,
                        hintText: "Enter Room/Animal Name",
                        validator: (value) => CustomValidator.isEmptyRoomNameOrAnimalName(value),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                      child: TextFormField(
                        validator: (value) => CustomValidator.isEmptyProblem(value),
                        controller: _problemController,
                        maxLines: 6,
                        cursorColor: Colors.black,
                        style: headingSmall.copyWith(fontSize: 17),
                        decoration: InputDecoration(
                          hintText: "Enter Concern",
                          filled: true,
                           fillColor:  AppColors.textFieldColor.withOpacity(0.5),
                          hintStyle: bodyNormal.copyWith(
                              color: Colors.black54, fontSize: 16),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 18),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 22.0, vertical: 8),
                      child: ZoomTapAnimation(
                          onTap: () {
                            onTap();
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
                            height: 56,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.buttonColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(buttonText,
                                  style: headingSmall.copyWith(
                                    fontSize: 17,
                                    color: Colors.white,
                                  )),
                            ),
                          )),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

Future<void> accessAdminView(
    BuildContext context,
    String title,
    String buttonText,
    final Function onTap,
    TextEditingController _problemTitleController,
    TextEditingController _problemController,
    TextEditingController _nameController,
    ) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 6,
          sigmaY: 6,
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Dialog(
            insetPadding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).orientation == Orientation.portrait? 20.w : 50.w),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            backgroundColor: Colors.white,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        height: 45,
                        width: 45,
                        margin: EdgeInsets.only(right: 10),
                        child: Center(
                          child: Image.asset(
                            "assets/images/popup/cancel_icon.png",
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Text(
                      title,
                      style: headingLarge.copyWith(
                          color: Colors.black, fontSize: 22),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 45,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                    child: AuthTextField(
                      controller: _nameController,
                      keyboardType: TextInputType.name,
                      hintText: "Enter Your Name",
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                    child: AuthTextField(
                      controller: _problemTitleController,
                      keyboardType: TextInputType.name,
                      hintText: "Enter Title",
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                    child: TextField(
                      controller: _problemController,
                      maxLines: 6,
                      cursorColor: Colors.black,
                      style: headingSmall.copyWith(fontSize: 17),
                      decoration: InputDecoration(
                        hintText: "Enter your problem",
                        filled: true,
                        fillColor:  AppColors.textFieldColor.withOpacity(0.5),
                        hintStyle: bodyNormal.copyWith(
                            color: Colors.black54, fontSize: 16),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 20, vertical: 18),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 22.0, vertical: 8),
                    child: ZoomTapAnimation(
                        onTap: () {
                          onTap();
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
                          height: 56,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.buttonColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(buttonText,
                                style: headingSmall.copyWith(
                                  fontSize: 17,
                                  color: Colors.white,
                                )),
                          ),
                        )),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
