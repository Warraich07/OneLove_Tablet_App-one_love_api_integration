
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:intl/intl.dart';
import 'package:one_love/controllers/auth_controller.dart';
import 'package:one_love/models/created_room_model.dart';
import 'package:one_love/models/notifications_model.dart';
import 'package:one_love/models/rooms_model.dart';
import 'package:one_love/utils/shared_preference.dart';

import '../api_services/api_exceptions.dart';
import '../api_services/data_api.dart';
import '../models/tasks_model.dart';
import '../utils/custom_dialogbox.dart';
import '../views/home/home_screen.dart';
import '../views/home/room_screen.dart';
import '../widgets/custom_dialog.dart';
import 'base_controller.dart';

class RoomController extends GetxController {

  // RxList<MainBarberBookingModel> barberBookingList=<MainBarberBookingModel>[].obs;
  RxBool isLoading = false.obs;
  RxBool isLoadingForRoomData = false.obs;
  RxBool didCameFromRoom = false.obs;
  RxBool isLoadingForRooms = false.obs;
  BaseController _baseController = BaseController.instance;
  RxList<CreatedRoomModel> createdRoom=<CreatedRoomModel>[].obs;
  // RxList<RoomsModel> roomsList=<RoomsModel>[].obs;
  RxList<RoomsModel> roomsList=RxList<RoomsModel>();
  RxList<RoomsModel> updatedRoomsList=RxList<RoomsModel>();
  RxString taskDurability = 'Daily'.obs;
  RxString taskValue = '1'.obs;
  RxString roomIdentifier = '0'.obs;
  RxList<TasksModel> tasksList=<TasksModel>[].obs;
  RxList<TasksModel> pendingDailyTasksList=<TasksModel>[].obs;
  RxList<TasksModel> pendingWeeklyTasksList=<TasksModel>[].obs;
  RxList<TasksModel> pendingMonthlyTasksList=<TasksModel>[].obs;
  RxList<TasksModel> completedDailyTasksList=<TasksModel>[].obs;
  RxList<TasksModel> completedWeeklyTasksList=<TasksModel>[].obs;
  RxList<TasksModel> completedMonthlyTasksList=<TasksModel>[].obs;
  RxList<TasksModel> completedTasksList=<TasksModel>[].obs;
  RxInt roomsCurrentPage=0.obs;
  RxInt roomsLastPage=0.obs;
  RxInt roomIndex=0.obs;
  RxInt roomIndexForSelectedRoom=0.obs;
  RxInt notificationsCurrentPage=0.obs;
  RxInt notificationsLastPage=0.obs;
  RxList<NotificationsModel> notificationsList=RxList<NotificationsModel>();
  RxList<NotificationsModel> notificationCount=RxList<NotificationsModel>();
  RxString fcmToken=''.obs;
  RxInt notificationCounts=0.obs;
  AuthController _authController=Get.find();
  final GlobalKey<FormState> createTaskKey = GlobalKey<FormState>();
  final GlobalKey<FormState> roomKey = GlobalKey<FormState>();
  final GlobalKey<FormState> reportProblemKey = GlobalKey<FormState>();
  final GlobalKey<FormState> adminKey = GlobalKey<FormState>();
  RxString roomDate=''.obs;
  RxString homeDate=''.obs;


  String updateDateTime(String value){
    String isoTimestamp = value;
    String timeWithoutAmPm = isoTimestamp.replaceAll(RegExp(r'\s*AM|\s*PM'), '');                                                                      // DateTime dateTime = DateTime.parse(isoTimestamp);
    DateTime dateTime = DateTime.parse(timeWithoutAmPm);
    DateFormat formatter = DateFormat('EEE, d MMMM, yyyy h:mm a');
    String formattedTimeStr = formatter.format(dateTime);
    return formattedTimeStr;
  }

  Future swapRooms(int firstRoomId,int secondRoomId)  async{
    Future.microtask(()async{
      // isLoading.value=true;
      Map<String, String> body = {
        'roomOne': firstRoomId.toString(),
        'roomTwo': secondRoomId.toString()
      };
      var response = await DataApiService.instance
          .post('animal-rescue-app/room/swap',body)
          .catchError((error) {
        if (error is BadRequestException) {
          var apiError = json.decode(error.message!);
          // CustomDialog.showErrorDialog(description: apiError["reason"]);
        } else {
          _baseController.handleError(error);
        }
      });

      if (response == null) return;
      print(response+ "responded");
      var result = json.decode(response);
      // isLoading.value=false;
      if (result['success']) {
        print("Rooms Swapped");
      } else {
        CustomDialog.showErrorDialog(description: result['message']);
      }
    });

  }

  Future swapTasks(int firstTaskId,int secondTaskId)  async{
    Future.microtask(()async{
      // isLoading.value=true;
      Map<String, String> body = {
        'taskOne': firstTaskId.toString(),
        'taskTwo': secondTaskId.toString()
      };
      var response = await DataApiService.instance
          .post('animal-rescue-app/task/swap',body)
          .catchError((error) {
        if (error is BadRequestException) {
          var apiError = json.decode(error.message!);
          // CustomDialog.showErrorDialog(description: apiError["reason"]);
        } else {
          _baseController.handleError(error);
        }
      });

      if (response == null) return;
      print(response+ "responded");
      var result = json.decode(response);
      // isLoading.value=false;
      if (result['success']) {
        print("Rooms Swapped");
      } else {
        CustomDialog.showErrorDialog(description: result['message']);
      }
    });

  }

  Future updateFcmNotificationToken(String fcmToken)  async{
    Future.microtask(()async{
      isLoading.value=true;
      Map<String, String> body = {
        'fcm_token': fcmToken
      };
      var response = await DataApiService.instance
          .post('animal-rescue-app/update-device-token',body)
          .catchError((error) {
        if (error is BadRequestException) {
          var apiError = json.decode(error.message!);
          // CustomDialog.showErrorDialog(description: apiError["reason"]);
        } else {
          _baseController.handleError(error);
        }
      });

      if (response == null) return;
      print(response+ "responded");
      var result = json.decode(response);
      isLoading.value=false;
      if (result['success']) {
        print("notification updated");
      } else {
        CustomDialog.showErrorDialog(description: result['message']);
      }
    });

  }

  void updateFcmToken(String token){
    fcmToken.value=token;
  }

  Future markAsRead(String notificationId) async {
    Future.microtask(() async {
      // _baseController.showLoading();
      print('booking detail');
      // isLoading.value = true;
      Map<String, String> body = {};
      var response = await DataApiService.instance
          .post('animal-rescue-app/notification/$notificationId/mark-as-read', body)
          .catchError((error) {
        if (error is BadRequestException) {
          var apiError = json.decode(error.message!);
          CustomDialog.showErrorDialog(description: apiError["reason"]);
        } else {
          _baseController.handleError(error);
        }
      });

      if (response == null) return;
      print(response + "responded");
      var result = json.decode(response);
      // isLoading.value = false;
      // _baseController.hideLoading();
      if (result['success']) {
        // roomsList.removeAt(index);
        // getNotifications();
      } else {
        CustomDialog.showErrorDialog(description: result['message']);
      }
    });
  }

  Future deleteNotification(String notificationId) async {
    Future.microtask(() async {
      // _baseController.showLoading();
      print('booking detail');
      // isLoading.value = true;
      Map<String, String> body = {};
      var response = await DataApiService.instance
          .post('animal-rescue-app/notification/delete/$notificationId', body)
          .catchError((error) {
        if (error is BadRequestException) {
          var apiError = json.decode(error.message!);
          CustomDialog.showErrorDialog(description: apiError["reason"]);
        } else {
          _baseController.handleError(error);
        }
      });

      if (response == null) return;
      print(response + "responded");
      var result = json.decode(response);
      // isLoading.value = false;
      // _baseController.hideLoading();
      if (result['success']) {
        // roomsList.removeAt(index);
                getNotifications();
                // Future.delayed(Duration(seconds: 2), () {
                //   Get.snackbar(
                //     'Success',
                //     'Notification deleted successfully',
                //     snackPosition: SnackPosition.TOP,
                //     backgroundColor: Color(0xffF7941D), // Background color
                //     colorText: Colors.black, // Text color for better visibility
                //   );
                // });
      } else {
        CustomDialog.showErrorDialog(description: result['message']);
      }
    });
  }

  Future deleteAllNotifications() async {
    await Future.microtask(() async {
      _baseController.showLoading("Please wait...");
      // isLoading.value = true;
      var response = await DataApiService.instance
          .post('animal-rescue-app/notification/delete-all',{}).catchError((error) {
        if (error is BadRequestException) {
          var apiError = json.decode(error.message!);
          CustomDialog.showErrorDialog(description: apiError["reason"]);
        } else {
          _baseController.handleError(error);
        }
      });
      // isLoading.value = false;
      _baseController.hideLoading();

      if (response == null) return;
      print(response + "responded");

      var result = json.decode(response);
      if (result['success']) {
        notificationsList.clear();
        notificationCounts.value=0;
      } else {
        CustomDialog.showErrorDialog(description: result['message']);
      }
    });
  }

  Future getNotifications() async {
   await Future.microtask(() async {
      // isLoading.value = true;
      var response = await DataApiService.instance
          .get('animal-rescue-app/get-notification?per_page=40&page=' + (notificationsCurrentPage.value+1).toString())
          .catchError((error) {
        if (error is BadRequestException) {
          var apiError = json.decode(error.message!);
          CustomDialog.showErrorDialog(description: apiError["reason"]);
        } else {
          _baseController.handleError(error);
        }
      });
      // isLoading.value = false;
      if (response == null) return;
      print(response + "responded");
      var result = json.decode(response);
      if (result['success']) {


        // roomData.value=RoomsModel.fromJson(result['data']['data']);
        // print(roomData.value!.data.length.toString()+"length   shadhdjahdj");
        // roomsList.value = List<RoomsModel>.from(result['data']['data'].map((x) => RoomsModel.fromJson(x)));
        notificationsList.value.addAll(List<NotificationsModel>.from(result['data']['data'].map((x) => NotificationsModel.fromJson(x))));
        notificationCount.value = notificationsList.where((e) => e.markAsRead == '0' ).toList();
        print(notificationCount.length.toString()+"hasdhjas");

        // notificationCount.value.addAll(List<NotificationsModel>.from(result['data']['data'].map((x) => NotificationsModel.fromJson(x))));

        notificationsCurrentPage.value=result['data']['current_page'];
        notificationsLastPage.value=result['data']['last_page'];

        // updateRoomId(roomsList[0].id.toString());
        // getRoomData(roomsList[0].id.toString(),'Haider');

        // completedAppointmentsNotifications.value = userNotificationsList.where((e) => e.booking.status == 'complete' || e.booking.status == 'cancel').toList();
        // completedAppointmentsNotifications.value = userNotificationsList.value;
        // print(notificationsLength);
      } else {
        // CustomDialog.showErrorDialog(description: result['message']);
      }
    });
  }

  Future getNotificationsCount() async {
    Future.microtask(() async {
      // isLoading.value = true;
      var response = await DataApiService.instance
          .get('user/detail')
          .catchError((error) {
        if (error is BadRequestException) {
          var apiError = json.decode(error.message!);
          CustomDialog.showErrorDialog(description: apiError["reason"]);
        } else {
          _baseController.handleError(error);
        }
      });
      // isLoading.value = false;
      if (response == null) return;
      print(response + "responded");
      var result = json.decode(response);
      if (result['success']) {
        notificationCounts.value= result['data']['unread_notification_count'];
      } else {
        // CustomDialog.showErrorDialog(description: result['message']);
      }
    });
  }

  Future reportProblem(String problemTitle,String problemDescription,BuildContext context,String name) async {
    Future.microtask(() async {
      _baseController.showLoading();
      print('booking detail');
      isLoading.value = true;
      Map<String, String> body = {
        'name': name,
        'email': 'ibra@gmail.com',
        'title': problemTitle,
        'message': problemDescription
      };
      var response = await DataApiService.instance
          .post('animal-rescue-app/report/problem', body)
          .catchError((error) {
        if (error is BadRequestException) {
          var apiError = json.decode(error.message!);
          CustomDialog.showErrorDialog(description: apiError["reason"]);
        } else {
          _baseController.handleError(error);
        }
      });

      if (response == null) return;
      print(response + "responded");
      var result = json.decode(response);
      isLoading.value = false;
      _baseController.hideLoading();
      if (result['success']) {
showCustomDialog(context, "assets/images/popup/success.png", "Thank you for your submission", "Thanks for reporting an issue, your report has been submitted successfully.", "Okay", (){Get.back();
        }, null,);
        // Get.back();
        // getRooms();
        // createdRoom.value = List<CreatedRoomModel>.from(
        //     result['data'].map((x) => CreatedRoomModel.fromJson(x)));
        // Get.to(()=> RoomScreen(initialTitle: createdRoom.first.name.toString(),isEditRoom: true,isNewCreated: true,));
        // getBarberSideBookings();

        // currentlyServingList.value =
        //     barberBookingList.where((e) => e.status == 'start').toList();
        // cancelledBookingList.value =
        //     barberBookingList.where((e) => e.status == 'cancel').toList();
        // print(currentlyServingList.length);

      } else {
        CustomDialog.showErrorDialog(description: result['message']);
      }
    });
  }

  Future changeTaskStatus(String taskId,String taskStatus,String member) async {
    Future.microtask(() async {
      _baseController.showLoading();
      print('booking detail');
      isLoading.value = true;
      Map<String, String> body = {
        'status': taskStatus,
        'member': member
      };

      var response = await DataApiService.instance
          .post('animal-rescue-app/task/change-status/$taskId',body)
          .catchError((error) {
        if (error is BadRequestException) {
          var apiError = json.decode(error.message!);
          CustomDialog.showErrorDialog(description: apiError["reason"]);
        } else {
          _baseController.handleError(error);
        }
      });

      if (response == null) return;
      print(response + "responded");
      var result = json.decode(response);
      isLoading.value = false;
      _baseController.hideLoading();
      if (result['success']) {
        String roomId=await AuthPreference.instance.getRoomId();
        if(roomIdentifier.value.isEmpty){
          roomIdentifier.value=roomId;
        }
        getRoomData(roomIdentifier.value, 'Haider');
        // if(taskStatus=='1'){
        //   Future.delayed(Duration(seconds: 2), () {
        //     Get.snackbar(
        //       'Success',
        //       'Great job! You have completed the task!',
        //       snackPosition: SnackPosition.TOP,
        //       backgroundColor: Color(0xffF7941D), // Background color
        //       colorText: Colors.black, // Text color for better visibility
        //     );
        //   });
        // }
      } else {
        CustomDialog.showErrorDialog(description: result['message']);
      }
    });
  }

  Future getFilteredRoomData(String roomId,String userName,String date) async {
    Future.microtask(() async {
      _baseController.showLoading();
      print('booking detail');
      isLoading.value = true;
      Map<String, String> body = {
        'checkIn': userName
      };
      var response = await DataApiService.instance
          .post('animal-rescue-app/room/$roomId/task?date=$date',body)
          .catchError((error) {
        if (error is BadRequestException) {
          var apiError = json.decode(error.message!);
          CustomDialog.showErrorDialog(description: apiError["reason"]);
        } else {
          _baseController.handleError(error);
        }
      });

      if (response == null) return;
      print(response + "responded");
      var result = json.decode(response);
      isLoading.value = false;
      _baseController.hideLoading();
      if (result['success']) {
        print("got room data");
        // Get.offAll(() => RoomScreen(initialTitle: "Room 1", isNewCreated: false, isEditRoom: true,));

        tasksList.value = List<TasksModel>.from(result['data']['pending']['data'].map((x) => TasksModel.fromJson(x)));
        completedTasksList.value = List<TasksModel>.from(result['data']['completed']['data'].map((x) => TasksModel.fromJson(x)));
        pendingDailyTasksList.value = tasksList.where((e) => e.durability == '1').toList();
        pendingWeeklyTasksList.value = tasksList.where((e) => e.durability == '2').toList();
        pendingMonthlyTasksList.value = tasksList.where((e) => e.durability == '3').toList();
        completedDailyTasksList.value = completedTasksList.where((e) => e.durability == '1').toList();
        completedWeeklyTasksList.value = completedTasksList.where((e) => e.durability == '2').toList();
        completedMonthlyTasksList.value = completedTasksList.where((e) => e.durability == '3').toList();
        // completedTasksList.value = tasksList.where((e) => e.status == '1').toList();
        // completedTasksList.value = List<TasksModel>.from(
        //     result['data']['pending']['data'].map((x) => TasksModel.fromJson(x)));
        Get.back();
        // Get.to(()=> RoomScreen(initialTitle: createdRoom.first.name.toString(),isEditRoom: true,isNewCreated: true,));

      } else {
        CustomDialog.showErrorDialog(description: result['message']);
      }
    });
  }

  Future getRoomData(String roomId,String userName) async {
    // _baseController.showLoading();
    isLoadingForRoomData.value=true;
    Future.microtask(() async {
      if(roomsList[roomIndex.value].pendingWeeklyTasksList!.isEmpty
          &&roomsList[roomIndex.value].pendingDailyTasksList!.isEmpty
          &&roomsList[roomIndex.value].pendingMonthlyTasksList!.isEmpty
          &&roomsList[roomIndex.value].completedDailyTasksList!.isEmpty
          &&roomsList[roomIndex.value].completedWeeklyTasksList!.isEmpty
          &&roomsList[roomIndex.value].completedMonthlyTasksList!.isEmpty){
      }else{
        // _baseController.showLoading();
      }
      print('booking detail');
      // isLoading.value = true;
      Map<String, String> body = {
        'checkIn': userName
      };
      var response = await DataApiService.instance
          .post('animal-rescue-app/room/$roomId/task?date=$roomDate',body)
          .catchError((error) {
        if (error is BadRequestException) {
          var apiError = json.decode(error.message!);
          CustomDialog.showErrorDialog(description: apiError["reason"]);
        } else {
          _baseController.handleError(error);

        }
      });

      if (response == null) return;
      print(response + "responded");
      var result = json.decode(response);
      isLoadingForRoomData.value = false;
      _baseController.hideLoading();
      update();
      if (result['success']) {
        print("got room data");
        // Get.offAll(() => RoomScreen(initialTitle: "Room 1", isNewCreated: false, isEditRoom: true,));

        tasksList.value = List<TasksModel>.from(result['data']['pending']['data'].map((x) => TasksModel.fromJson(x)));
        completedTasksList.value = List<TasksModel>.from(result['data']['completed']['data'].map((x) => TasksModel.fromJson(x)));
        pendingDailyTasksList.value = tasksList.where((e) => e.durability == '1').toList();
        pendingWeeklyTasksList.value = tasksList.where((e) => e.durability == '2').toList();
        pendingMonthlyTasksList.value = tasksList.where((e) => e.durability == '3').toList();
        completedDailyTasksList.value = completedTasksList.where((e) => e.durability == '1').toList();
        completedWeeklyTasksList.value = completedTasksList.where((e) => e.durability == '2').toList();
        completedMonthlyTasksList.value = completedTasksList.where((e) => e.durability == '3').toList();
        roomsList[roomIndex.value].pendingDailyTasksList=tasksList.where((e) => e.durability == '1').toList();
        roomsList[roomIndex.value].pendingWeeklyTasksList=tasksList.where((e) => e.durability == '2').toList();
        roomsList[roomIndex.value].pendingMonthlyTasksList=tasksList.where((e) => e.durability == '3').toList();
        roomsList[roomIndex.value].completedDailyTasksList=tasksList.where((e) => e.durability == '1').toList();
        roomsList[roomIndex.value].completedWeeklyTasksList=tasksList.where((e) => e.durability == '2').toList();
        roomsList[roomIndex.value].completedMonthlyTasksList=tasksList.where((e) => e.durability == '3').toList();
        // completedTasksList.value = tasksList.where((e) => e.status == '1').toList();
        // completedTasksList.value = List<TasksModel>.from(
        //     result['data']['pending']['data'].map((x) => TasksModel.fromJson(x)));
        // fridays last change
        // Get.back();
        // Get.to(()=> RoomScreen(initialTitle: createdRoom.first.name.toString(),isEditRoom: true,isNewCreated: true,));

      } else {
        CustomDialog.showErrorDialog(description: result['message']);
      }
    });
  }

  Future deleteTask(String taskId) async {
    Future.microtask(() async {
      _baseController.showLoading();
      print('booking detail');
      isLoading.value = true;
      Map<String, String> body = {};
      var response = await DataApiService.instance
          .post('animal-rescue-app/task/delete/$taskId', body)
          .catchError((error) {
        if (error is BadRequestException) {
          var apiError = json.decode(error.message!);
          CustomDialog.showErrorDialog(description: apiError["reason"]);
        } else {
          _baseController.handleError(error);
        }
      });

      if (response == null) return;
      print(response + "responded");
      var result = json.decode(response);
      isLoading.value = false;
      _baseController.hideLoading();
      if (result['success']) {
        // Get.offAll(() => RoomScreen(initialTitle: "Room 1", isNewCreated: false, isEditRoom: true,));
        // Get.back();
       getRoomData(roomIdentifier.value,'Haider');
       // Future.delayed(Duration(seconds: 3), () {
       //   Get.snackbar(
       //     'Success',
       //     'Task successfully deleted',
       //     snackPosition: SnackPosition.TOP,
       //     backgroundColor: Color(0xffF7941D), // Background color
       //     colorText: Colors.black, // Text color for better visibility
       //   );
       // });
        // createdRoom.value = List<CreatedRoomModel>.from(
        //     result['data'].map((x) => CreatedRoomModel.fromJson(x)));
        // Get.to(()=> RoomScreen(initialTitle: createdRoom.first.name.toString(),isEditRoom: true,isNewCreated: true,));

      } else {
        CustomDialog.showErrorDialog(description: result['message']);
      }
    });
  }

  Future editTask(String taskName,String roomId,String durability,String taskId) async {
    Future.microtask(() async {
      _baseController.showLoading();
      print('booking detail');
      isLoading.value = true;
      Map<String, String> body = {
        'name': taskName,
        'room_id': roomId,
        'durability': durability
      };
      var response = await DataApiService.instance
          .post('animal-rescue-app/task/edit/$taskId', body)
          .catchError((error) {
        if (error is BadRequestException) {
          var apiError = json.decode(error.message!);
          CustomDialog.showErrorDialog(description: apiError["reason"]);
        } else {
          _baseController.handleError(error);
        }
      });

      if (response == null) return;
      print(response + "responded");
      var result = json.decode(response);
      isLoading.value = false;
      _baseController.hideLoading();
      if (result['success']) {
        // Get.offAll(() => RoomScreen(initialTitle: "Room 1", isNewCreated: false, isEditRoom: true,));
        // fridays last change
        Get.back();
        getRoomData(roomId??'','Haider');
        // Future.delayed(Duration(seconds: 3), () {
        //   Get.snackbar(
        //     'Success',
        //     'Task edited successfully',
        //     snackPosition: SnackPosition.TOP,
        //     backgroundColor: Color(0xffF7941D), // Background color
        //     colorText: Colors.black, // Text color for better visibility
        //   );
        // });
        // createdRoom.value = List<CreatedRoomModel>.from(
        //     result['data'].map((x) => CreatedRoomModel.fromJson(x)));
        // Get.to(()=> RoomScreen(initialTitle: createdRoom.first.name.toString(),isEditRoom: true,isNewCreated: true,));

      } else {
        CustomDialog.showErrorDialog(description: result['message']);
      }
    });
  }

  Future createTask(String taskName,String roomId,String durability) async {
    Future.microtask(() async {
      _baseController.showLoading();
      print('booking detail');
      isLoading.value = true;
      Map<String, String> body = {
        'name': taskName,
        'room_id': roomId,
        'durability': durability
      };
      var response = await DataApiService.instance
          .post('animal-rescue-app/task/create', body)
          .catchError((error) {
        if (error is BadRequestException) {
          var apiError = json.decode(error.message!);
          CustomDialog.showErrorDialog(description: apiError["reason"]);
        } else {
          _baseController.handleError(error);
        }
      });

      if (response == null) return;
      print(response + "responded");
      var result = json.decode(response);
      isLoading.value = false;
      _baseController.hideLoading();
      if (result['success']) {
        Get.back();
        getRoomData(roomId??'','Haider');
        // Future.delayed(Duration(seconds: 3), () {
        //   Get.snackbar(
        //     'Success',
        //     'Task created successfully',
        //     snackPosition: SnackPosition.TOP,
        //     backgroundColor: Color(0xffF7941D), // Background color
        //     colorText: Colors.black, // Text color for better visibility
        //   );
        // });
        // Get.back();
        // Get.offAll(() => RoomScreen(initialTitle: "Room 1", isNewCreated: false, isEditRoom: true,));
        // Get.back();
        // createdRoom.value = List<CreatedRoomModel>.from(
        //     result['data'].map((x) => CreatedRoomModel.fromJson(x)));
        // Get.to(()=> RoomScreen(initialTitle: createdRoom.first.name.toString(),isEditRoom: true,isNewCreated: true,));

      } else {
        CustomDialog.showErrorDialog(description: result['message']);
      }
    });
  }

  Future createRoom(String roomName) async {
    Future.microtask(() async {
      _baseController.showLoading();
      print('booking detail');
      isLoading.value = true;
      Map<String, String> body = {
        'name': roomName
      };
      var response = await DataApiService.instance
          .post('animal-rescue-app/room/create', body)
          .catchError((error) {
        if (error is BadRequestException) {
          var apiError = json.decode(error.message!);
          CustomDialog.showErrorDialog(description: apiError["reason"]);
        } else {
          _baseController.handleError(error);
        }
      });

      if (response == null) return;
      print(response + "responded");
      var result = json.decode(response);
      isLoading.value = false;
      _baseController.hideLoading();
      if (result['success']) {

        Get.back();
        createdRoom.value = List<CreatedRoomModel>.from(
            result['data'].map((x) => CreatedRoomModel.fromJson(x)));
        Get.offAll(() => RoomScreen(initialTitle: createdRoom.first.name.toString(), isNewCreated: false, isEditRoom: true,roomId: createdRoom.first.id.toString(),));
       updateRoomId(createdRoom.first.id.toString());
        _authController.updateIsAdminView(true);

        //   if staff view implemented then this code will work for staff mode
        // _generalController.updateDateForHome("");
        updateDateAfterFiltering('');
        roomIndexForSelectedRoom.value = roomsList.length;
        // set room index to select the highlight the color of room tile if staff view implemented and restarted the app
         AuthPreference.instance.setRoomIndex(roomsList.length.toString());
         AuthPreference.instance.setRoomName(createdRoom.last.name);
         AuthPreference.instance.setRoomId(createdRoom.last.id.toString());
      } else {
        CustomDialog.showErrorDialog(description: result['message']);
      }
    });
  }

  Future editRoom(String roomName,String roomId) async {
    Future.microtask(() async {
      _baseController.showLoading();
      print('booking detail');
      isLoading.value = true;
      Map<String, String> body = {
        'name': roomName
      };
      var response = await DataApiService.instance
          .post('animal-rescue-app/room/edit/$roomId', body)
          .catchError((error) {
        if (error is BadRequestException) {
          var apiError = json.decode(error.message!);
          CustomDialog.showErrorDialog(description: apiError["reason"]);
        } else {
          _baseController.handleError(error);
        }
      });

      if (response == null) return;
      print(response + "responded");
      var result = json.decode(response);
      isLoading.value = false;
      _baseController.hideLoading();
      if (result['success']) {

        Get.back();
        getRooms();
        // Future.delayed(Duration(seconds: 3), () {
        //   Get.snackbar(
        //     'Success',
        //     'Room name edited successfully',
        //     snackPosition: SnackPosition.TOP,
        //     backgroundColor: Color(0xffF7941D), // Background color
        //     colorText: Colors.black, // Text color for better visibility
        //   );
        // });

        // createdRoom.value = List<CreatedRoomModel>.from(
        //     result['data'].map((x) => CreatedRoomModel.fromJson(x)));
        // Get.to(()=> RoomScreen(initialTitle: createdRoom.first.name.toString(),isEditRoom: true,isNewCreated: true,));
        // getBarberSideBookings();

        // currentlyServingList.value =
        //     barberBookingList.where((e) => e.status == 'start').toList();
        // cancelledBookingList.value =
        //     barberBookingList.where((e) => e.status == 'cancel').toList();
        // print(currentlyServingList.length);

      } else {
        CustomDialog.showErrorDialog(description: result['message']);
      }
    });
  }

  Future deleteRoom(String roomId) async {
    Future.microtask(() async {
      _baseController.showLoading();
      print('booking detail');
      isLoading.value = true;
      var response = await DataApiService.instance
          .post('animal-rescue-app/room/delete/$roomId', {})
          .catchError((error) {
        if (error is BadRequestException) {
          var apiError = json.decode(error.message!);
          CustomDialog.showErrorDialog(description: apiError["reason"]);
        } else {
          _baseController.handleError(error);
        }
      });

      if (response == null) return;
      print(response + "responded");
      var result = json.decode(response);
      isLoading.value = false;
      _baseController.hideLoading();
      if (result['success']) {

        getRooms();
        Get.back();
        // Future.delayed(Duration(seconds: 2), () {
        //   Get.snackbar(
        //     'Success',
        //     'Room deleted successfully',
        //     snackPosition: SnackPosition.TOP,
        //     backgroundColor: Color(0xffF7941D), // Background color
        //     colorText: Colors.black, // Text color for better visibility
        //   );
        // });
        // Get.back();
        // createdRoom.value = List<CreatedRoomModel>.from(
        //     result['data'].map((x) => CreatedRoomModel.fromJson(x)));
        // Get.to(()=> RoomScreen(initialTitle: createdRoom.first.name.toString(),isEditRoom: true,isNewCreated: true,));
        // getBarberSideBookings();

        // currentlyServingList.value =
        //     barberBookingList.where((e) => e.status == 'start').toList();
        // cancelledBookingList.value =
        //     barberBookingList.where((e) => e.status == 'cancel').toList();
        // print(currentlyServingList.length);

      } else {
        CustomDialog.showErrorDialog(description: result['message']);
      }
    });
  }

  Future getRooms() async {
    // _baseController.showLoading();
    Future.microtask(() async {
      if(roomsList.isEmpty){
        isLoading.value = true;
        print("room list is empty");
      }else{
        isLoading.value = false;
        print("room list");
      }

      var response = await DataApiService.instance
          .get('animal-rescue-app/get-room?per_page=500&page=' + (roomsCurrentPage.value+1).toString())
          .catchError((error) {
        if (error is BadRequestException) {
          var apiError = json.decode(error.message!);
          CustomDialog.showErrorDialog(description: apiError["reason"]);
        } else {
          _baseController.handleError(error);
        }
      });
      // _baseController.hideLoading();

      isLoading.value = false;
      if (response == null) return;
      print(response + "responded");
      var result = json.decode(response);
      if (result['success']) {


        // roomData.value=RoomsModel.fromJson(result['data']['data']);
        // print(roomData.value!.data.length.toString()+"length   shadhdjahdj");
        // roomsList.value = List<RoomsModel>.from(result['data']['data'].map((x) => RoomsModel.fromJson(x)));
        if(roomsList.isEmpty){
          roomsList.value.addAll(List<RoomsModel>.from(result['data']['data'].map((x) => RoomsModel.fromJson(x))));
        }else{
          roomsList.value = List<RoomsModel>.from(result['data']['data'].map((x) => RoomsModel.fromJson(x)));

        }

        roomsCurrentPage.value=result['data']['current_page'];
        roomsLastPage.value=result['data']['last_page'];
        updateRoomId(roomsList[int.parse(roomIdentifier.value)].id.toString());
        getRoomData(roomsList[roomIndexForSelectedRoom.value].id.toString(),'Haider');

        // completedAppointmentsNotifications.value = userNotificationsList.where((e) => e.booking.status == 'complete' || e.booking.status == 'cancel').toList();
        // completedAppointmentsNotifications.value = userNotificationsList.value;
        // print(notificationsLength);
      } else {
        // CustomDialog.showErrorDialog(description: result['message']);
      }
    });
  }
  Future getPaginationRooms() async {
    Future.microtask(() async {
      isLoadingForRooms.value = true;
      var response = await DataApiService.instance
          .get('animal-rescue-app/get-room?per_page=10&page=' + (roomsCurrentPage.value+1).toString())
          .catchError((error) {
        if (error is BadRequestException) {
          var apiError = json.decode(error.message!);
          CustomDialog.showErrorDialog(description: apiError["reason"]);
        } else {
          _baseController.handleError(error);
        }
      });
      isLoadingForRooms.value = false;
      if (response == null) return;
      print(response + "responded");
      var result = json.decode(response);
      if (result['success']) {


        // roomData.value=RoomsModel.fromJson(result['data']['data']);
        // print(roomData.value!.data.length.toString()+"length   shadhdjahdj");
        // roomsList.value = List<RoomsModel>.from(result['data']['data'].map((x) => RoomsModel.fromJson(x)));
        roomsList.value.addAll(List<RoomsModel>.from(result['data']['data'].map((x) => RoomsModel.fromJson(x))));

        roomsCurrentPage.value=result['data']['current_page'];
        roomsLastPage.value=result['data']['last_page'];
        updateRoomId(roomsList[0].id.toString());
        getRoomData(roomsList[0].id.toString(),'Haider');

        // completedAppointmentsNotifications.value = userNotificationsList.where((e) => e.booking.status == 'complete' || e.booking.status == 'cancel').toList();
        // completedAppointmentsNotifications.value = userNotificationsList.value;
        // print(notificationsLength);
      } else {
        // CustomDialog.showErrorDialog(description: result['message']);
      }
    });
  }

  void updateTaskDurability(String durability,String value){
    taskDurability.value=durability;
    taskValue.value=value;
  }
  void updateRoomId(String roomId){
    roomIdentifier.value=roomId;

  }
  void updateRoomIndex(int index){
    roomIndex.value=index;

  }
  void updateRoomIndexForSelectedRoom(int index){
    roomIndexForSelectedRoom.value=index;

  }

  void updateDateAfterFiltering(String updatedDate){
    roomDate.value=updatedDate;
  }


}