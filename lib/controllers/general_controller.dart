import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:one_love/controllers/auth_controller.dart';
import 'package:sizer/sizer.dart';

import '../constants/custom_dialog.dart';
import '../constants/global_variables.dart';
import '../widgets/custom_widgets.dart';

class GeneralController extends GetxController {
  RxInt _currentIndex = 0.obs;
  RxInt quoteType = 0.obs;
  List<String> selectedTimes = List.filled(12, '');
  List<String> selectedDate = List.filled(12, '');
  int get currentIndex => _currentIndex.value;
  var formattedDateTime = ''.obs; // Observable variable to hold the formatted date and time
  RxString roomDate=''.obs;
  RxString homeDate=''.obs;
  RxInt roomIndex=0.obs;
  @override
  void onInit() {
    super.onInit();
    _updateDateTime(); // Start updating date and time when the controller is initialized
  }
  void _updateDateTime() {
    // Initial call to set the current time
    _setDateTime();

    // Schedule updates every second
    Timer.periodic(Duration(seconds: 1), (Timer timer) {
      _setDateTime();
    });
  }

  void updateDateForRoom(String updatedDate){
    roomDate.value=updatedDate;
  }
  void updateDateForHome(String updatedDate){
    homeDate.value=updatedDate;
  }

  void updateRoomIndexForResetATTwelveAM(int index){
    roomIndex.value=index;
  }

  void _setDateTime() {
    formattedDateTime.value = DateFormat('EEE, d MMMM, yyyy h:mm a').format(DateTime.now());
  }
  void onBottomBarTapped(int index) {
    _currentIndex.value = index;
  }

  showLoading([String? message]) {
    CustomDialogBox.showLoading(message);
  }

  hideLoading() {
    CustomDialogBox.hideLoading();
  }

  successDialog(BuildContext context, String titleHead, String description) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              // title: Text("Notice"),
              // content: Text("Launching this missile will destroy the entire universe. Is this what you intended to do?"),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 2.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: const Icon(
                                Icons.close,
                                color: Colors.black,
                              )),
                        ],
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      const Icon(
                        Icons.done,
                        color: Colors.black,
                        size: 40,
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Text(
                        titleHead,
                        style:
                            title.copyWith(fontSize: 22, color: Colors.black),
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Text(
                        description,
                        style: bodySmall.copyWith(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      SizedBox(
                        child: CustomButton(
                          buttonText: "OK",
                          onTap: () {
                            Get.back();
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            );
          });
        });
  }

  errorDialog(BuildContext context, String titleHead, String description) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              // title: Text("Notice"),
              // content: Text("Launching this missile will destroy the entire universe. Is this what you intended to do?"),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 2.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: const Icon(
                                Icons.close,
                                color: Colors.black,
                              )),
                        ],
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      const Icon(
                        Icons.error,
                        color: Colors.black,
                        size: 40,
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Text(
                        titleHead,
                        style:
                            title.copyWith(fontSize: 22, color: Colors.black),
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Text(
                        description,
                        style: bodySmall.copyWith(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      SizedBox(
                        child: CustomButton(
                          buttonText: "OK",
                          onTap: () {
                            Get.back();
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            );
          });
        });
  }

  String convertToCompactRepresentation(int value) {
    if (value < 1000) {
      return value.toString();
    } else if (value < 1000000) {
      double result = value / 1000.0;
      return result
              .toStringAsFixed(result.truncateToDouble() == result ? 0 : 1) +
          'k';
    } else {
      double result = value / 1000000.0;
      return result
              .toStringAsFixed(result.truncateToDouble() == result ? 0 : 1) +
          'M';
    }
  }
}
