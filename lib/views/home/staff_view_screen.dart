// import 'dart:ui';
//
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:one_love/constants/global_variables.dart';
// import 'package:one_love/controllers/auth_controller.dart';
// import 'package:one_love/controllers/room_controller.dart';
// import 'package:one_love/views/auth/login_screen.dart';
// import 'package:one_love/views/home/room_screen.dart';
// import 'package:one_love/widgets/custom_widgets.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
//
// import 'package:sizer/sizer.dart';
// import 'package:zoom_tap_animation/zoom_tap_animation.dart';
//
// import '../../controllers/general_controller.dart';
// import '../../models/rooms_model.dart';
// import '../../models/rooms_model.dart';
// import '../../utils/custom_dialogbox.dart';
// import '../../widgets/custom_dialog.dart';
// import '../../widgets/room_tile_widget.dart';
// import '../../widgets/show_case.dart';
// import '../../widgets/task_section_widget.dart';
// import '../../widgets/text_form_fields.dart';
// import 'notifications_detail_screen.dart';
// import 'package:showcaseview/showcaseview.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   DateTime? selectedDate;
//
//   // Future<void> _selectDate(BuildContext context) async {
//   //   final DateTime? pickedDate = await showDatePicker(
//   //
//   //     context: context,
//   //     initialDate: selectedDate ?? DateTime.now(),
//   //     firstDate: DateTime(2000),
//   //
//   //     lastDate: DateTime.now(),
//   //   );
//   //
//   //   if (pickedDate != null && pickedDate != selectedDate) {
//   //     setState(() {
//   //       selectedDate = pickedDate;
//   //       String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate!);
//   //       _roomController.getFilteredRoomData(_roomController.roomIdentifier.value, 'Haider', formattedDate);
//   //       // print(sle)
//   //       // print(selectedDate.toString()+"dashdj");
//   //     });
//   //   }
//   // }
//   // DateTime firstDate =DateTime.now();
//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: selectedDate ?? DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime.now(),
//     );
//
//     if (pickedDate != null && pickedDate != selectedDate) {
//       setState(() {
//
//         selectedDate = pickedDate;
//         // Format the date to 'yyyy-MM-dd'
//         String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate!);
//
//         _roomController.getFilteredRoomData(_roomController.roomIdentifier.value, 'Haider', formattedDate);
//         String updatedData = DateFormat('EEE, d MMMM yyyy').format(selectedDate!);
//         String todayDate = DateFormat('EEE, d MMMM yyyy').format(DateTime.now());
//         if(updatedData==todayDate){
//           _generalController.updateDateForHome("");
//         }else{
//           print(updatedData);
//           _generalController.updateDateForHome(updatedData);}
//
//       });
//     }
//   }
//
//   int selectedBoard = 0;
//   // final List<String> rooms = ['Room 1', 'Room 2', 'Room 3', 'Room 4', 'Room 5'];
//   int selectedRoomIndex=0;
//   double _swipeOffset = 0.0;
//   Map<int, double> _swipeOffsets = {};
//
//
//   late ValueNotifier<bool> _controller = ValueNotifier<bool>(false);
//   GeneralController _generalController=Get.find();
//   AuthController _authController=Get.find();
//   RoomController _roomController=Get.find();
//   TextEditingController roomNameController=TextEditingController();
//   TextEditingController taskController=TextEditingController();
//   RefreshController _notificationRefreshController = RefreshController(initialRefresh: false);
//   Color unreadColor=Color(0xfff5ddbf);
//   Color readColor=Colors.white;
//   @override
//   void initState(){
//     // TODO: implement initState
//     super.initState();
//     _roomController.roomsList.clear();
//     _roomController.roomsCurrentPage.value=0;
//     _roomController.roomsLastPage.value=0;
//     _roomController.getRooms();
//     _roomController.notificationsList.clear();
//     _roomController.notificationsCurrentPage.value=0;
//     _roomController.notificationsLastPage.value=0;
//     _roomController.getNotifications();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     DateTime now = DateTime.now();
//     String formattedDateTime = DateFormat('EEE, d MMMM, yyyy h:mm a').format(now);
//     var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
//     return Obx(
//           ()=> Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//           toolbarHeight: 80,
//           elevation: 1,
//           title: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Image.asset("assets/images/app_logo.png", scale: 3,),
//
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(100),
//                     child: Container(
//                       height: 40,
//                       width: 40,
//                       child: CachedNetworkImage(imageUrl: _authController.userData.value!.data.userImage.toString(),
//                         placeholder: (context, url) =>
//                             Center(
//                                 child: CircularProgressIndicator()),
//                         errorWidget: (context, url,
//                             error) =>
//                             Image.asset(
//                                 "assets/img.png"),
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 10),
//
//                   Text(
//                     "Admin",
//                     // _authController.userData.value!.data.name.toString(),
//                     style: headingSmall,
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//         body:
//         Column(
//           children: [
//             Expanded(
//               child: Row(
//                 children: [
//                   _dashBoardPanel(),
//                   selectedBoard == 0?
//
//                   Expanded(
//                     child: Row(
//                       children: [
//                         isPortrait?
//                         SizedBox.shrink():
//                         _roomsPanel(isPortrait, isData: true),
//                         Expanded(
//                           child: Column(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 20),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           "Tasks Progress",
//                                           style: headingMedium,
//                                         ),
//
//                                         SizedBox(height: 8,),
//                                         Row(
//                                           children: [
//                                             SizedBox(
//                                               width: 200,
//                                               child: LinearProgressIndicator(
//                                                 value: _roomController.completedTasksList.isEmpty?0: _roomController.completedTasksList.length/((_roomController.tasksList.isEmpty?0:_roomController.tasksList.length)+(_roomController.completedTasksList.isEmpty?0:_roomController.completedTasksList.length)),
//                                                 backgroundColor: Colors.grey[300],
//                                                 valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
//                                               ),
//                                             ),
//                                             SizedBox(width: 10,),
//                                             Text(
//                                               "${_roomController.completedTasksList.isEmpty?0: _roomController.completedTasksList.length}/${(_roomController.tasksList.isEmpty?0:_roomController.tasksList.length)+(_roomController.completedTasksList.isEmpty?0:_roomController.completedTasksList.length)} Tasks completed",
//                                               style: headingSmall.copyWith(color: Colors.grey, fontSize: 13),),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                     Row(
//                                       children: [
//                                         Obx(
//                                               ()=>Row(
//                                             children: [
//                                               _generalController.homeDate.isEmpty?Container(): TextButton(
//                                                 onPressed:(){
//                                                   _generalController.updateDateForHome("");
//                                                   _roomController.getFilteredRoomData(_roomController.roomIdentifier.value, 'Haider', "");
//
//                                                 }, child: Text("clear"),
//                                               ),
//                                               Text(
//                                                 _generalController.homeDate.isEmpty?  _generalController.formattedDateTime.value:_generalController.homeDate.value,
//                                                 style: headingSmall.copyWith(
//                                                     color: Colors.grey, fontSize: 13),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           width: 10,
//                                         ),
//                                         GestureDetector(
//                                           onTap: () => _selectDate(context),
//                                           child: Image.asset(
//                                             "assets/icons/calender_icon.png",
//                                             scale: 4,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     // Row(
//                                     //   children: [
//                                     //     Obx(()=> Text(_generalController.formattedDateTime.value, style: headingSmall.copyWith(color: Colors.grey, fontSize: 13),)),
//                                     //     SizedBox(width: 10,),
//                                     //     GestureDetector(
//                                     //         onTap: () => _selectDate(context),
//                                     //         child: Image.asset("assets/icons/calender_icon.png", scale: 4,)),
//                                     //   ],
//                                     // ),
//                                   ],
//                                 ),
//                               ),
//                               isPortrait?
//                               Column(
//                                 children: [
//                                   SizedBox(height: 10,),
//                                   Padding(padding: EdgeInsets.symmetric(horizontal: 18), child: _roomsPanel(isPortrait, isData: false))
//                                 ],
//                               ) : SizedBox.shrink(),
//                               Expanded(
//                                 child: Row(
//                                   children: [
//                                     Expanded(
//                                       child: Container(
//                                         padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
//                                         decoration: BoxDecoration(
//                                             color: Color(0xfff5f5f5),
//                                             border: Border(right: BorderSide(color: Colors.black12,), top: BorderSide(color: Colors.black12))
//                                         ),
//                                         child: Column(
//                                           children: [
//                                             Row(
//                                               children: [
//                                                 Icon(Icons.circle, color: Colors.deepOrangeAccent, size: 14,),
//                                                 SizedBox(width: 6,),
//                                                 Text(
//                                                   "Pending Tasks",
//                                                   style: headingSmall,
//                                                 ),
//                                               ],
//                                             ),
//                                             SizedBox(height: 10),
//                                             Expanded(
//                                               child: ListView(
//                                                 children: [
//                                                   Padding(
//                                                     padding: const EdgeInsets.symmetric(vertical: 8.0),
//                                                     child: Column(
//                                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                                       children: [
//                                                         // idr updat kro
//                                                         // Text("Daily Tasks", style: headingMedium),
//                                                         _roomController.pendingDailyTasksList.isEmpty?Column(
//                                                           children: [
//                                                             Align(
//                                                                 alignment:Alignment.centerLeft,
//                                                                 child: Text("Daily Tasks", style: headingMedium)),
//                                                             Align(
//                                                                 alignment:Alignment.center,
//                                                                 child: Text("No daily tasks yet", style: subHeading)),
//                                                           ],
//                                                         ):Text("Daily Tasks", style: headingMedium),
//
//                                                         SizedBox(height: 8),
//                                                         ListView.builder(
//                                                           physics: ScrollPhysics(),
//                                                           shrinkWrap: true,
//                                                           itemCount: _roomController.pendingDailyTasksList.length,
//                                                           itemBuilder:(context,index){
//                                                             String isoTimestamp = _roomController.pendingDailyTasksList[index].createdAt.toString();
//                                                             DateTime dateTime = DateTime.parse(isoTimestamp);
//                                                             String formattedDate = DateFormat('EEE, d MMMM yyyy h:mm a').format(dateTime);
//                                                             return TaskTile(
//                                                               createdAt: "Created At: ",
//                                                               dateTime: formattedDate,
//                                                               task: Task(name: _roomController.pendingDailyTasksList[index].name, lastCompleted: DateTime(2024, 6, 7, 9, 40), status: 'Ongoing'),
//                                                               isCompletedSection: false,
//                                                               isEdit: true,
//                                                               onTapEdit: (){
//
//                                                                 customDialogNewTask(context, "Edit Task", "Save Changes", (){
//                                                                   _roomController.editTask(taskController.text.toString(), _roomController.pendingDailyTasksList[index].roomId.toString(), _roomController.taskValue.toString(),  _roomController.pendingDailyTasksList[index].id.toString());
//
//                                                                   // print("save");
//                                                                   // Get.back();
//                                                                   // Get.off(()=> RoomScreen(initialTitle: ""));
//                                                                 },taskController,FocusNode());
//                                                               },
//                                                               onTapRemove: (){
//                                                                 showCustomDialog(context, "assets/images/popup/ask.png", "Are You Sure?", "Are you sure that you want to remove this task from the list?", "Yes, Remove", (){
//                                                                   Get.back();
//                                                                   _roomController.deleteTask(_roomController.pendingDailyTasksList[index].id.toString());
//
//                                                                   print("Delete taskt");
//                                                                   // Get.back();
//                                                                 }, null);
//                                                               },
//                                                               // onChanged: (value) async {
//                                                               //   // if(value)
//                                                               //   // {
//                                                               //     await showConfirmationDialog(value,_roomController.pendingDailyTasksList[index].id.toString(),_roomController.pendingDailyTasksList[index].status.toString());
//                                                               //
//                                                               //     // await showConfirmationDialog(value,_roomController.completedMonthlyTasksList[index].id.toString(),_roomController.completedMonthlyTasksList[index].status.toString());
//                                                               //   // }
//                                                               // },
//                                                               onTapChangeStatus: (){
//                                                                 showConfirmationDialogForPendingTask(true,_roomController.pendingDailyTasksList[index].id.toString(),_roomController.pendingDailyTasksList[index].status.toString());
//
//                                                               },
//                                                             );
//                                                           } ,
//
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                   Padding(
//                                                     padding: const EdgeInsets.symmetric(vertical: 8.0),
//                                                     child: Column(
//                                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                                       children: [
//                                                         _roomController.pendingWeeklyTasksList.isEmpty?Column(
//                                                           children: [
//                                                             Align(
//                                                                 alignment:Alignment.centerLeft,
//                                                                 child: Text("Weekly Tasks", style: headingMedium)),
//                                                             Align(
//                                                                 alignment:Alignment.center,
//                                                                 child: Text("No weekly tasks yet", style: subHeading)),
//                                                           ],
//                                                         ):Text("Weekly Tasks", style: headingMedium),
//
//                                                         // Text("Weekly Tasks", style: headingMedium),
//                                                         SizedBox(height: 8),
//                                                         ListView.builder(
//                                                           physics: ScrollPhysics(),
//                                                           shrinkWrap: true,
//                                                           itemCount: _roomController.pendingWeeklyTasksList.length,
//                                                           itemBuilder:(context,index){
//                                                             String isoTimestamp = _roomController.pendingWeeklyTasksList[index].createdAt.toString();
//                                                             DateTime dateTime = DateTime.parse(isoTimestamp);
//                                                             String formattedDate = DateFormat('EEE, d MMMM yyyy h:mm a').format(dateTime);
//                                                             return TaskTile(
//                                                               createdAt: "Created At: ",
//                                                               dateTime: formattedDate,
//                                                               task: Task(name: _roomController.pendingWeeklyTasksList[index].name, lastCompleted: DateTime(2024, 6, 7, 9, 40), status: 'Ongoing'),
//                                                               isCompletedSection: false,
//                                                               isEdit: true,
//                                                               onTapEdit: (){
//
//                                                                 customDialogNewTask(context, "Edit Task", "Save Changes", (){
//                                                                   print("Save asdas");
//
//                                                                   _roomController.editTask(taskController.text.toString(), _roomController.pendingWeeklyTasksList[index].roomId.toString(), _roomController.taskValue.toString(),  _roomController.pendingWeeklyTasksList[index].id.toString());
//
//                                                                   // Get.back();
//                                                                   // Get.off(()=> RoomScreen(initialTitle: ""));
//                                                                 },taskController,FocusNode(),);
//                                                               },
//                                                               onTapRemove: (){
//                                                                 showCustomDialog(context, "assets/images/popup/ask.png", "Are You Sure?", "Are you sure that you want to remove this task from the list?", "Yes, Remove", (){
//                                                                   _roomController.deleteTask(_roomController.pendingWeeklyTasksList[index].id.toString());
//
//                                                                   // Get.back();
//                                                                 }, null);
//                                                               },
//                                                               // onChanged: (value) async {
//                                                               // print(value.toString());
//                                                               //   await showConfirmationDialog(value,_roomController.pendingDailyTasksList[index].id.toString(),_roomController.pendingDailyTasksList[index].status.toString());
//                                                               //
//                                                               // },
//                                                               onTapChangeStatus: (){
//                                                                 showConfirmationDialogForPendingTask(true,_roomController.pendingWeeklyTasksList[index].id.toString(),_roomController.pendingWeeklyTasksList[index].status.toString());
//
//                                                               },
//                                                             );
//                                                           } ,
//
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                   Padding(
//                                                     padding: const EdgeInsets.symmetric(vertical: 8.0),
//                                                     child: Column(
//                                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                                       children: [
//                                                         _roomController.pendingMonthlyTasksList.isEmpty?Column(
//                                                           children: [
//                                                             Align(
//                                                                 alignment:Alignment.centerLeft,
//                                                                 child: Text("Monthly Tasks", style: headingMedium)),
//                                                             Align(
//                                                                 alignment:Alignment.center,
//                                                                 child: Text("No monthly tasks yet", style: subHeading)),
//                                                           ],
//                                                         ) :Text("Monthly Tasks", style: headingMedium),
//
//                                                         // Text("Monthly Tasks", style: headingMedium),
//                                                         SizedBox(height: 8),
//                                                         ListView.builder(
//                                                           physics: ScrollPhysics(),
//                                                           shrinkWrap: true,
//                                                           itemCount: _roomController.pendingMonthlyTasksList.length,
//                                                           itemBuilder:(context,index){
//                                                             String isoTimestamp = _roomController.pendingMonthlyTasksList[index].createdAt.toString();
//                                                             DateTime dateTime = DateTime.parse(isoTimestamp);
//                                                             String formattedDate = DateFormat('EEE, d MMMM yyyy h:mm a').format(dateTime);
//                                                             return TaskTile(
//                                                               createdAt: "Created At: ",
//                                                               dateTime: formattedDate,
//                                                               task: Task(name: _roomController.pendingMonthlyTasksList[index].name, lastCompleted: DateTime(2024, 6, 7, 9, 40), status: 'Ongoing'),
//                                                               isCompletedSection: false,
//                                                               isEdit: true,
//                                                               onTapEdit: (){
//                                                                 customDialogNewTask(context, "Edit Task", "Save Changes", (){
//                                                                   _roomController.editTask(taskController.text.toString(), _roomController.pendingMonthlyTasksList[index].roomId.toString(), _roomController.taskValue.toString(),  _roomController.pendingMonthlyTasksList[index].id.toString());
//
//                                                                   // Get.back();
//                                                                   // Get.off(()=> RoomScreen(initialTitle: ""));
//                                                                 },taskController,FocusNode());
//                                                               },
//                                                               onTapRemove: (){
//                                                                 showCustomDialog(context, "assets/images/popup/ask.png", "Are You Sure?", "Are you sure that you want to remove this task from the list?", "Yes, Remove", (){
//                                                                   _roomController.deleteTask(_roomController.pendingMonthlyTasksList[index].id.toString());
//
//                                                                   // Get.back();
//                                                                 }, null);
//                                                               },
//                                                               // onChanged: (value) async {
//                                                               //   await showConfirmationDialog(value,_roomController.pendingMonthlyTasksList[index].id.toString(),_roomController.pendingDailyTasksList[index].status.toString());
//                                                               //
//                                                               // },
//                                                               onTapChangeStatus: (){
//                                                                 showConfirmationDialogForPendingTask(true,_roomController.pendingMonthlyTasksList[index].id.toString(),_roomController.pendingMonthlyTasksList[index].status.toString());
//
//                                                               },
//                                                             );
//                                                           } ,
//
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                   // Padding(
//                                                   //   padding: const EdgeInsets.symmetric(vertical: 8.0),
//                                                   //   child: Column(
//                                                   //     crossAxisAlignment: CrossAxisAlignment.start,
//                                                   //     children: [
//                                                   //       Text("Daily Tasks", style: headingMedium),
//                                                   //       SizedBox(height: 8),
//                                                   //       ListView.builder(
//                                                   //         physics: ScrollPhysics(),
//                                                   //         shrinkWrap: true,
//                                                   //         itemCount: 1,
//                                                   //         itemBuilder:(context,index){
//                                                   //           return TaskTile(task: Task(name: _roomController.pendingDailyTasksList[index].name, lastCompleted: DateTime(2024, 6, 7, 9, 40), status: 'Ongoing'),
//                                                   //             isCompletedSection: false,
//                                                   //             isEdit: true,
//                                                   //             onTapEdit: (){
//                                                   //
//                                                   //               customDialogNewTask(context, "Edit Task", "Save Changes", (){
//                                                   //                 Get.back();
//                                                   //                 Get.off(()=> RoomScreen(initialTitle: ""));
//                                                   //               },taskController);
//                                                   //             },
//                                                   //             onTapRemove: (){
//                                                   //               showCustomDialog(context, "assets/images/popup/ask.png", "Are You Sure?", "Are you sure that you want to remove this task from the list?", "Yes, Remove", (){
//                                                   //                 // Get.back();
//                                                   //               }, null);
//                                                   //             },
//                                                   //             onChanged: (value) async {
//                                                   //               if(value)
//                                                   //                 {
//                                                   //                    await showConfirmationDialog(value);
//                                                   //                 }
//                                                   //             },
//                                                   //           );
//                                                   //         } ,
//                                                   //
//                                                   //       ),
//                                                   //     ],
//                                                   //   ),
//                                                   // ),
//                                                   // Padding(
//                                                   //   padding: const EdgeInsets.symmetric(vertical: 8.0),
//                                                   //   child: Column(
//                                                   //     crossAxisAlignment: CrossAxisAlignment.start,
//                                                   //     children: [
//                                                   //       Text("Weekly Tasks", style: headingMedium),
//                                                   //       SizedBox(height: 8),
//                                                   //       ListView.builder(
//                                                   //         physics: ScrollPhysics(),
//                                                   //         shrinkWrap: true,
//                                                   //         itemCount: 1,
//                                                   //         itemBuilder:(context,index){
//                                                   //           return TaskTile(task: Task(name: 'Feed All Animals', lastCompleted: DateTime(2024, 6, 7, 9, 40), status: 'Ongoing'),
//                                                   //             isCompletedSection: false,
//                                                   //             isEdit: true,
//                                                   //             onTapEdit: (){
//                                                   //
//                                                   //               customDialogNewTask(context, "Edit Task", "Save Changes", (){
//                                                   //                 Get.back();
//                                                   //                 Get.off(()=> RoomScreen(initialTitle: ""));
//                                                   //               },taskController);
//                                                   //             },
//                                                   //             onTapRemove: (){
//                                                   //               showCustomDialog(context, "assets/images/popup/ask.png", "Are You Sure?", "Are you sure that you want to remove this task from the list?", "Yes, Remove", (){
//                                                   //                 // Get.back();
//                                                   //               }, null);
//                                                   //             },
//                                                   //             onChanged: (value) async {
//                                                   //               if(value)
//                                                   //               {
//                                                   //                 await showConfirmationDialog(value);
//                                                   //               }
//                                                   //             },
//                                                   //           );
//                                                   //         } ,
//                                                   //
//                                                   //       ),
//                                                   //     ],
//                                                   //   ),
//                                                   // ),
//                                                   // Padding(
//                                                   //   padding: const EdgeInsets.symmetric(vertical: 8.0),
//                                                   //   child: Column(
//                                                   //     crossAxisAlignment: CrossAxisAlignment.start,
//                                                   //     children: [
//                                                   //       Text("Monthly Tasks", style: headingMedium),
//                                                   //       SizedBox(height: 8),
//                                                   //       ListView.builder(
//                                                   //         physics: ScrollPhysics(),
//                                                   //         shrinkWrap: true,
//                                                   //         itemCount: 1,
//                                                   //         itemBuilder:(context,index){
//                                                   //           return TaskTile(
//                                                   //             task: Task(name: 'Feed All Animals', lastCompleted: DateTime(2024, 6, 7, 9, 40), status: 'Ongoing'),
//                                                   //             isCompletedSection: false,
//                                                   //             isEdit: true,
//                                                   //             onTapEdit: (){
//                                                   //               customDialogNewTask(context, "Edit Task", "Save Changes", (){
//                                                   //                 Get.back();
//                                                   //                 Get.off(()=> RoomScreen(initialTitle: ""));
//                                                   //               },taskController);
//                                                   //             },
//                                                   //             onTapRemove: (){
//                                                   //               showCustomDialog(context, "assets/images/popup/ask.png", "Are You Sure?", "Are you sure that you want to remove this task from the list?", "Yes, Remove", (){
//                                                   //                 // Get.back();
//                                                   //               }, null);
//                                                   //             },
//                                                   //             onChanged: (value) async {
//                                                   //               if(value)
//                                                   //               {
//                                                   //                 await showConfirmationDialog(value);
//                                                   //               }
//                                                   //             },
//                                                   //           );
//                                                   //         } ,
//                                                   //
//                                                   //       ),
//                                                   //     ],
//                                                   //   ),
//                                                   // ),
//                                                   // TaskSection(title: 'Monthly Tasks', tasks: monthlyTasks, isEdit: true,),
//                                                 ],
//                                               ),
//                                             ),
//                                             // Container(
//                                             //   height: 200,
//                                             //   color: Colors.orange[50],
//                                             //   child: Center(child: Text('No Pending Tasks')),
//                                             // ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                     Expanded(
//                                       child: Container(
//                                         padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
//                                         decoration: BoxDecoration(
//                                             color: Color(0xfff5f5f5),
//                                             border: Border(top: BorderSide(color: Colors.black12))
//                                         ),
//                                         child: Column(
//                                           children: [
//                                             Row(
//                                               children: [
//                                                 Icon(Icons.circle, color: Colors.green, size: 14,),
//                                                 SizedBox(width: 6,),
//                                                 Text(
//                                                   "Completed Tasks",
//                                                   style: headingSmall,
//                                                 ),
//                                               ],
//                                             ),
//                                             SizedBox(height: 10),
//                                             Expanded(
//                                               child: ListView(
//                                                 children: [
//                                                   Padding(
//                                                     padding: const EdgeInsets.symmetric(vertical: 8.0),
//                                                     child: Column(
//                                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                                       children: [
//                                                         _roomController.completedDailyTasksList.isEmpty?Column(
//                                                           children: [
//                                                             Align(
//                                                                 alignment:Alignment.centerLeft,
//                                                                 child: Text("Daily Tasks", style: headingMedium)),
//                                                             Align(
//                                                                 alignment:Alignment.center,
//                                                                 child: Text("No daily tasks yet", style: subHeading)),
//                                                           ],
//                                                         ) :Text("Daily Tasks", style: headingMedium),
//
//                                                         // Text("Daily Tasks", style: headingMedium),
//                                                         SizedBox(height: 8),
//                                                         ListView.builder(
//                                                           physics: ScrollPhysics(),
//                                                           shrinkWrap: true,
//                                                           itemCount: _roomController.completedDailyTasksList.length,
//                                                           itemBuilder:(context,index){
//                                                             String isoTimestamp = _roomController.completedDailyTasksList[index].updatedAt.toString();
//                                                             DateTime dateTime = DateTime.parse(isoTimestamp);
//                                                             String formattedDate = DateFormat('EEE, d MMMM yyyy h:mm a').format(dateTime);
//                                                             return TaskTile(
//                                                               completeBy: _roomController.completedDailyTasksList[index].member,
//                                                               dateTime: formattedDate,
//                                                               task: Task(name: _roomController.completedDailyTasksList[index].name, lastCompleted: DateTime(2024, 6, 7, 9, 40), status: 'Ongoing'),
//                                                               isCompletedSection: true,
//                                                               isEdit: true,
//                                                               // onChanged: (value) async {
//                                                               //   // if(value)
//                                                               //   // {
//                                                               //   await showConfirmationDialog(value,_roomController.completedDailyTasksList[index].id.toString(),_roomController.completedDailyTasksList[index].status.toString());
//                                                               //   // }
//                                                               // },
//                                                               onTapRemoveCompletedTasks: (){
//                                                                 showCustomDialog(context, "assets/images/popup/ask.png", "Are You Sure?", "Are you sure that you want to remove this task from the list?", "Yes, Remove", (){
//                                                                   // _roomController.deleteTask("32");
//                                                                   _roomController.deleteTask(_roomController.completedDailyTasksList[index].id.toString());
//                                                                   Get.back();
//                                                                 }, null);
//                                                               },
//                                                               onTapChangeStatus: (){
//                                                                 print(_roomController.completedDailyTasksList[index].member.toString());
//
//                                                                 showConfirmationDialog(true,_roomController.completedDailyTasksList[index].id.toString(),_roomController.completedDailyTasksList[index].status.toString(),_roomController.completedDailyTasksList[index].member.toString());
//
//                                                               },
//                                                             );
//                                                           } ,
//
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                   Padding(
//                                                     padding: const EdgeInsets.symmetric(vertical: 8.0),
//                                                     child: Column(
//                                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                                       children: [
//                                                         // Text("Weekly Tasks", style: headingMedium),
//                                                         _roomController.completedWeeklyTasksList.isEmpty?Column(
//                                                           children: [
//                                                             Align(
//                                                                 alignment:Alignment.centerLeft,
//                                                                 child: Text("Weekly Tasks", style: headingMedium)),
//                                                             Align(
//                                                                 alignment:Alignment.center,
//                                                                 child: Text("No weekly tasks yet", style: subHeading)),
//                                                           ],
//                                                         ) :Text("Weekly Tasks", style: headingMedium),
//
//                                                         SizedBox(height: 8),
//                                                         ListView.builder(
//                                                           physics: ScrollPhysics(),
//                                                           shrinkWrap: true,
//                                                           itemCount: _roomController.completedWeeklyTasksList.length,
//                                                           itemBuilder:(context,index){
//                                                             String isoTimestamp = _roomController.completedWeeklyTasksList[index].updatedAt.toString();
//                                                             DateTime dateTime = DateTime.parse(isoTimestamp);
//                                                             String formattedDate = DateFormat('EEE, d MMMM yyyy h:mm a').format(dateTime);
//                                                             return TaskTile(
//                                                               completeBy: _roomController.completedWeeklyTasksList[index].member,
//
//                                                               dateTime: formattedDate,
//                                                               task: Task(name: _roomController.completedWeeklyTasksList[index].name, lastCompleted: DateTime(2024, 6, 7, 9, 40), status: 'Ongoing'),
//                                                               isCompletedSection: true,
//                                                               isEdit: true,
//                                                               onTapRemoveCompletedTasks: (){
//                                                                 showCustomDialog(context, "assets/images/popup/ask.png", "Are You Sure?", "Are you sure that you want to remove this task from the list?", "Yes, Remove", (){
//                                                                   _roomController.deleteTask(_roomController.completedWeeklyTasksList[index].id.toString());
//                                                                   // Get.back();
//
//                                                                 }, null);
//                                                               },
//                                                               // onChanged: (value) async {
//                                                               //   await showConfirmationDialog(value,_roomController.completedWeeklyTasksList[index].id.toString(),_roomController.completedWeeklyTasksList[index].status.toString());
//                                                               //
//                                                               // },
//                                                               onTapChangeStatus: (){
//                                                                 showConfirmationDialog(true,_roomController.completedWeeklyTasksList[index].id.toString(),_roomController.completedWeeklyTasksList[index].status.toString(),_roomController.completedWeeklyTasksList[index].member.toString());
//
//                                                               },
//                                                             );
//                                                           } ,
//
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                   Padding(
//                                                     padding: const EdgeInsets.symmetric(vertical: 8.0),
//                                                     child: Column(
//                                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                                       children: [
//                                                         // Text("Monthly Tasks", style: headingMedium),
//                                                         _roomController.completedMonthlyTasksList.isEmpty?Column(
//                                                           children: [
//                                                             Align(
//                                                                 alignment:Alignment.centerLeft,
//                                                                 child: Text("Monthly Tasks", style: headingMedium)),
//                                                             Align(
//                                                                 alignment:Alignment.center,
//                                                                 child: Text("No monthly tasks yet", style: subHeading)),
//                                                           ],
//                                                         ) :Text("Monthly Tasks", style: headingMedium),
//
//                                                         SizedBox(height: 8),
//                                                         ListView.builder(
//                                                           physics: ScrollPhysics(),
//                                                           shrinkWrap: true,
//                                                           itemCount: _roomController.completedMonthlyTasksList.length,
//                                                           itemBuilder:(context,index){
//                                                             String isoTimestamp = _roomController.completedMonthlyTasksList[index].updatedAt.toString();
//                                                             DateTime dateTime = DateTime.parse(isoTimestamp);
//                                                             String formattedDate = DateFormat('EEE, d MMMM yyyy h:mm a').format(dateTime);
//                                                             return TaskTile(
//                                                               completeBy: _roomController.completedMonthlyTasksList[index].member,
//
//                                                               dateTime: formattedDate,
//                                                               task: Task(name: _roomController.completedMonthlyTasksList[index].name, lastCompleted: DateTime(2024, 6, 7, 9, 40), status: 'Ongoing'),
//                                                               isCompletedSection: true,
//                                                               isEdit: true,
//                                                               onTapRemoveCompletedTasks: (){
//                                                                 showCustomDialog(context, "assets/images/popup/ask.png", "Are You Sure?", "Are you sure that you want to remove this task from the list?", "Yes, Remove", (){
//                                                                   _roomController.deleteTask(_roomController.completedMonthlyTasksList[index].id.toString());
//                                                                   // Get.back();
//                                                                 }, null);
//                                                               },
//                                                               // onChanged: (value) async {
//                                                               //   await showConfirmationDialog(value,_roomController.completedMonthlyTasksList[index].id.toString(),_roomController.completedMonthlyTasksList[index].status.toString());
//                                                               //
//                                                               // },
//                                                               onTapChangeStatus: (){
//                                                                 showConfirmationDialog(true,_roomController.completedMonthlyTasksList[index].id.toString(),_roomController.completedMonthlyTasksList[index].status.toString(),_roomController.completedMonthlyTasksList[index].member.toString());
//
//                                                               },
//                                                             );
//                                                           } ,
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                   // Padding(
//                                                   //   padding: const EdgeInsets.symmetric(vertical: 8.0),
//                                                   //   child: Column(
//                                                   //     crossAxisAlignment: CrossAxisAlignment.start,
//                                                   //     children: [
//                                                   //       Text("Daily Tasks", style: headingMedium),
//                                                   //       SizedBox(height: 8),
//                                                   //       ListView.builder(
//                                                   //         physics: ScrollPhysics(),
//                                                   //         shrinkWrap: true,
//                                                   //         itemCount: 1,
//                                                   //         itemBuilder:(context,index){
//                                                   //           return TaskTile(
//                                                   //             task: Task(name: 'Feed All Animals', lastCompleted: DateTime(2024, 6, 7, 9, 40), status: 'Ongoing'),
//                                                   //             isCompletedSection: true,
//                                                   //             isEdit: true,
//                                                   //             onChanged: (value) async {
//                                                   //               if(value)
//                                                   //               {
//                                                   //                 await showConfirmationDialog(value);
//                                                   //               }
//                                                   //             },
//                                                   //             onTapRemoveCompletedTasks: (){
//                                                   //               showCustomDialog(context, "assets/images/popup/ask.png", "Are You Sure?", "Are you sure that you want to remove this task from the list?", "Yes, Remove", (){
//                                                   //                 Get.back();
//                                                   //               }, null);
//                                                   //             },
//                                                   //           );
//                                                   //         } ,
//                                                   //
//                                                   //       ),
//                                                   //     ],
//                                                   //   ),
//                                                   // ),
//                                                   // Padding(
//                                                   //   padding: const EdgeInsets.symmetric(vertical: 8.0),
//                                                   //   child: Column(
//                                                   //     crossAxisAlignment: CrossAxisAlignment.start,
//                                                   //     children: [
//                                                   //       Text("Weekly Tasks", style: headingMedium),
//                                                   //       SizedBox(height: 8),
//                                                   //       ListView.builder(
//                                                   //         physics: ScrollPhysics(),
//                                                   //         shrinkWrap: true,
//                                                   //         itemCount: 1,
//                                                   //         itemBuilder:(context,index){
//                                                   //           return TaskTile(
//                                                   //             task: Task(name: 'Feed All Animals', lastCompleted: DateTime(2024, 6, 7, 9, 40), status: 'Ongoing'),
//                                                   //             isCompletedSection: true,
//                                                   //             isEdit: true,
//                                                   //             onTapRemoveCompletedTasks: (){
//                                                   //               showCustomDialog(context, "assets/images/popup/ask.png", "Are You Sure?", "Are you sure that you want to remove this task from the list?", "Yes, Remove", (){
//                                                   //                 Get.back();
//                                                   //               }, null);
//                                                   //             },
//                                                   //             onChanged: (value) async {
//                                                   //               if(value)
//                                                   //               {
//                                                   //                 await showConfirmationDialog(value);
//                                                   //               }
//                                                   //             },
//                                                   //           );
//                                                   //         } ,
//                                                   //
//                                                   //       ),
//                                                   //     ],
//                                                   //   ),
//                                                   // ),
//                                                   // Padding(
//                                                   //   padding: const EdgeInsets.symmetric(vertical: 8.0),
//                                                   //   child: Column(
//                                                   //     crossAxisAlignment: CrossAxisAlignment.start,
//                                                   //     children: [
//                                                   //       Text("Monthly Tasks", style: headingMedium),
//                                                   //       SizedBox(height: 8),
//                                                   //       ListView.builder(
//                                                   //         physics: ScrollPhysics(),
//                                                   //         shrinkWrap: true,
//                                                   //         itemCount: 1,
//                                                   //         itemBuilder:(context,index){
//                                                   //           return TaskTile(
//                                                   //             task: Task(name: 'Feed All Animals', lastCompleted: DateTime(2024, 6, 7, 9, 40), status: 'Ongoing'),
//                                                   //             isCompletedSection: true,
//                                                   //             isEdit: true,
//                                                   //             onTapRemoveCompletedTasks: (){
//                                                   //               showCustomDialog(context, "assets/images/popup/ask.png", "Are You Sure?", "Are you sure that you want to remove this task from the list?", "Yes, Remove", (){
//                                                   //                 Get.back();
//                                                   //               }, null);
//                                                   //             },
//                                                   //             onChanged: (value) async {
//                                                   //               if(value)
//                                                   //               {
//                                                   //                 await showConfirmationDialog(value);
//                                                   //               }
//                                                   //             },
//                                                   //           );
//                                                   //         } ,
//                                                   //       ),
//                                                   //     ],
//                                                   //   ),
//                                                   // ),
//                                                   // TaskSection(title: 'Weekly Tasks', tasks: weeklyTasks, isCompleted: true,isEdit: true,),
//                                                   // TaskSection(title: 'Monthly Tasks', tasks: monthlyTasks, isCompleted: true,isEdit: true,),
//                                                 ],
//                                               ),
//                                             ),
//                                             // Container(
//                                             //   height: 200,
//                                             //   color: Colors.green[50],
//                                             //   child: Center(child: Text('No Completed Tasks')),
//                                             // ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ) :  Expanded(
//                     child: Container(
//                       color:Colors.grey.shade50,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.only(left: 22.0, top: 10),
//                             child: Text(
//                               "Notifications",
//                               style: headingLarge,
//                             ),
//                           ),
//                           SizedBox(height: 20),
//                           _roomController.isLoading==true?Expanded(
//                             child: Center(
//                               child: CircularProgressIndicator(),
//                             ),
//                           ): Expanded(
//                             child: SmartRefresher(
//                               enablePullDown: false,
//                               enablePullUp: true,
//                               controller: _notificationRefreshController,
//                               onLoading: () async {
//                                 if (_roomController.notificationsCurrentPage.value<_roomController.notificationsLastPage.value) {
//                                   await _roomController.getNotifications();
//
//                                   setState(() {});
//                                 }
//                                 _notificationRefreshController.loadComplete();
//                               },
//                               child:
//                               _roomController.notificationsList.isNotEmpty ?
//                               Padding(
//                                 padding: const EdgeInsets.symmetric(horizontal:20),
//                                 child: AlignedGridView.count(
//                                   crossAxisCount: isPortrait ? 1 : 2,
//                                   crossAxisSpacing: 15,
//                                   mainAxisSpacing: 15,
//                                   padding: EdgeInsets.only(bottom: 30),
//                                   itemCount: _roomController.notificationsList.length, // Replace with your actual number of notifications
//                                   itemBuilder: (context, index) {
//                                     _swipeOffsets[index] = _swipeOffsets[index] ?? 0.0;
//                                     return Stack(
//                                       key: ValueKey(index),
//                                       children: [
//                                         // Background container with delete icon
//                                         Positioned.fill(
//                                           child: GestureDetector(
//                                             onTap:(){
//                                               showCustomDialog(context, "assets/images/popup/ask.png", "Are You Sure?", "Are you sure that you want to remove this notification from the list?", "Yes, Remove", ()
//                                               {
//                                                 _roomController.deleteNotification(_roomController.notificationsList[index].id);
//                                                 setState(() {
//                                                   _swipeOffsets.remove(index);
//                                                   _roomController.notificationsList.removeAt(index);
//                                                 });
//                                               }, null);
//
//
//
//                                               print("object");
//                                             },
//                                             child: Container(
//                                               alignment: Alignment.centerRight,
//                                               padding: EdgeInsets.only(right: 20),
//                                               child: Container(
//                                                 width: 100,
//                                                 height: 100,
//                                                 decoration: BoxDecoration(
//                                                   color: Color(0xffF7941D),
//                                                   borderRadius: BorderRadius.circular(10),
//                                                 ),
//                                                 child: Icon(
//                                                   Icons.delete,
//                                                   color: Colors.white,
//                                                   size: 30,
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         // Foreground card that can be swiped
//                                         GestureDetector(
//                                           onHorizontalDragUpdate: (details) {
//                                             setState(() {
//                                               // Swipe right to left (negative delta) to reveal the delete icon, limit to 100 pixels
//                                               _swipeOffsets[index] =
//                                                   (_swipeOffsets[index]! + details.primaryDelta!).clamp(-100.0, 0.0);
//                                             });
//                                           },
//                                           onHorizontalDragEnd: (details) {
//                                             setState(() {
//                                               // If card is less than halfway swiped (i.e., more than -50 pixels), snap it back
//                                               if (_swipeOffsets[index]! > -50) {
//                                                 _swipeOffsets[index] = 0.0;
//                                               } else {
//                                                 _swipeOffsets[index] = -100.0;
//                                               }
//                                             });
//                                           },
//                                           child: Transform.translate(
//                                             offset: Offset(_swipeOffsets[index]!, 0),
//                                             child: GestureDetector(
//                                               onTap:(){
//                                                 if(_roomController.notificationsList[index].markAsRead.toString()=='0'){
//                                                   _roomController.markAsRead(_roomController.notificationsList[index].id.toString());
//
//                                                   setState(() {
//                                                     _roomController.notificationsList[index].markAsRead="1";
//                                                     // unreadColor=readColor;
//                                                   });
//                                                 }
//                                                 if(_roomController.notificationsList[index].data.status.toString() == ''){
//                                                   Get.to(()=> NotificationDetailScreen(notificationMessage: _roomController.notificationsList[index].data.message.toString(),notificationTitle: _roomController.notificationsList[index].data.title.toString(),userName: _roomController.notificationsList[index].data.name.toString(),));
//                                                 }else{
//                                                   _roomController.updateRoomId(_roomController.roomsList[index].id.toString());
//                                                   print(_roomController.roomsList[index].id.toString());
//                                                   Get.offAll(() => ShowCaseRoom(initialTitle: _roomController.roomsList[index].name.toString(),
//                                                     isNewCreated: false, isEditRoom: true,roomId: _roomController.roomsList[index].id.toString(),));
//                                                   // Get.to(()=> RoomScreen(notificationMessage: _roomController.notificationsList[index].data.message.toString(),notificationTitle: _roomController.notificationsList[index].data.title.toString(),userName: _roomController.notificationsList[index].data.name.toString(),));
//
//                                                   print("no ");
//                                                 }
//                                               },
//                                               child: Card(
//                                                 color:_roomController.notificationsList[index].markAsRead.toString()=='0'? unreadColor:readColor,
//                                                 elevation: 2,
//                                                 shadowColor: Colors.black26,
//                                                 shape: RoundedRectangleBorder(
//                                                   borderRadius: BorderRadius.circular(10),
//                                                 ),
//                                                 child: Padding(
//                                                   padding: const EdgeInsets.all(16.0),
//                                                   child: Column(
//                                                     children: [
//                                                       Row(
//                                                         crossAxisAlignment: CrossAxisAlignment.center,
//                                                         children: [
//                                                           ClipRRect(
//                                                             borderRadius: BorderRadius.circular(100),
//                                                             child: Container(
//                                                               width: 35,
//                                                               decoration: BoxDecoration(
//                                                                 shape: BoxShape.circle,
//                                                                 color: Colors.black12,
//                                                               ),
//                                                               child: Image.asset(
//                                                                 "assets/icons/user_icon.png",
//                                                                 scale: 4,
//                                                               ),
//                                                             ),
//                                                           ),
//                                                           SizedBox(width: 16),
//                                                           Text(
//                                                             _roomController.notificationsList[index].data.status.toString() == ''
//                                                                 ? _roomController.notificationsList[index].data.name.toString()
//                                                                 : _roomController.notificationsList[index].data.member.toString(),
//                                                             style: headingMedium,
//                                                           ),
//                                                         ],
//                                                       ),
//                                                       SizedBox(height: 8),
//                                                       Column(
//                                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                                         children: [
//                                                           Text(
//                                                             _roomController.notificationsList[index].data.status.toString() == ''
//                                                                 ? _roomController.notificationsList[index].data.title.toString()
//                                                                 : "Task Status",
//                                                             style: headingMedium,
//                                                           ),
//                                                           // Text(_roomController.notificationsList[index].data.status.toString() == ""?_roomController.notificationsList[index].data.title.toString():''),
//                                                           SizedBox(height: 10),
//                                                           Align(
//                                                             alignment: Alignment.centerLeft,
//                                                             child: Text(
//                                                               _roomController.notificationsList[index].data.message.toString()=='null'?'':_roomController.notificationsList[index].data.message.toString(),
//                                                               style: notificationBody.copyWith(color: Colors.grey),
//                                                               maxLines: 2,
//                                                               overflow: TextOverflow.ellipsis,
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     );
//
//
//
//                                   },
//                                 ),
//                               ):Center(
//                                   child: Text("No Rooms Created")
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//
//       ),
//     );
//   }
//   _dashBoardPanel(){
//     return Container(
//       width: 80,
//       // height: double.infinity,
//       decoration: BoxDecoration(
//           border: Border(right: BorderSide(color: Colors.black12))
//       ),
//       child: Column(
//         children: [
//           GestureDetector(
//             onTap: (){
//               setState(() {
//                 selectedBoard = 0;
//               });
//             },
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Container(
//                   height: 50,
//                   width: 8,
//                   decoration: BoxDecoration(
//                       color: selectedBoard == 0? AppColors.primaryColor : Colors.transparent
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(right: 18.0),
//                   child: Image.asset("assets/icons/tasks.png", scale: 3, color: selectedBoard == 0? AppColors.primaryColor : Colors.grey,),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(
//             height: 20,
//           ),
//           GestureDetector(
//             onTap: (){
//               setState(() {
//                 selectedBoard = 1;
//               });
//             },
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Container(
//                   height: 50,
//                   width: 8,
//                   decoration: BoxDecoration(
//                       color: selectedBoard == 1? AppColors.primaryColor : Colors.transparent
//                   ),
//                 ),
//                 Stack(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(right: 18.0),
//                       child: Image.asset("assets/icons/notification.png", scale: 3, color: selectedBoard == 1? AppColors.primaryColor : Colors.grey,),
//                     ),
//                     Positioned(
//                         right: 5,
//                         top: 0,
//                         child: Text(_roomController.notificationCount.length.toString(),style: TextStyle(color: AppColors.primaryColor),))
//                   ],
//                 )
//
//               ],
//             ),
//           ),
//           Spacer(),
//           Padding(
//             padding: const EdgeInsets.only(bottom: 50.0),
//             child: GestureDetector(
//               onTap: (){
//                 _authController.logoutUser();
//                 // Get.offAll(()=> LogInScreen());
//                 print("logout");
//               },
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Image.asset("assets/icons/logout.png", scale: 3,),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//   _roomsPanel(bool isPortrait, {bool isData = false}) {
//     RefreshController _refreshController = RefreshController(initialRefresh: false);
//     return Container(
//       width: isPortrait ? null : 220,
//       height: isPortrait ? 120 : null,
//       decoration: BoxDecoration(
//         border: isPortrait
//             ? Border(bottom: BorderSide(color: Colors.black12))
//             : Border(right: BorderSide(color: Colors.black12)),
//       ),
//       child:  Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: EdgeInsets.only(left: isPortrait ? 8.0 : 8.0, top: isPortrait ? 12 : 12),
//             child: Text(
//               "Rooms",
//               style: isPortrait ? headingMedium.copyWith(fontSize: 19) : headingMedium.copyWith(fontSize: 19),
//             ),
//           ),
//           SizedBox(
//             height: 10,
//           ),
//           isData == false
//               ? Padding(
//             padding: EdgeInsets.symmetric(horizontal: isPortrait ? 8.0 : 10),
//             child: SizedBox(
//               height: 65,
//               child: CustomButton(
//                 onTap: () {
//                   customDialogTextField(context,"Create New Room", "Create", "Enter Room Name", (){
//                     _roomController.createRoom(roomNameController.text.toString());
//                     // Get.to(()=> RoomScreen(initialTitle: "Room Title", isNewCreated: true,));
//                   }, roomNameController,FocusNode());
//                 },
//                 buttonText: "Create New Room",
//               ),
//             ),
//           )
//               :
//           // _roomController.isLoading==true?Expanded(
//           //       child: Center(
//           //         child: CircularProgressIndicator(
//           //       color: AppColors.primaryColor,),),):
//           Expanded(
//             child: SmartRefresher(
//               enablePullDown: false,
//               enablePullUp: true,
//               controller: _refreshController,
//               onLoading: () async {
//                 if (_roomController.roomsCurrentPage.value<_roomController.roomsLastPage.value) {
//                   await _roomController.getPaginationRooms();
//
//                   setState(() {});
//                 }
//                 _refreshController.loadComplete();
//               },
//               child:
//               _roomController.roomsList.isNotEmpty ?
//               ListView.builder(
//                 physics: BouncingScrollPhysics(),
//                 scrollDirection:Axis.vertical,
//                 // isPortrait ? Axis.horizontal : Axis.vertical,
//                 itemCount: _roomController.roomsList.length,
//                 itemBuilder: (context, index) {
//                   return GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         // specific room
//                         selectedRoomIndex = index;
//                         _roomController.updateRoomId(_roomController.roomsList[index].id.toString());
//                         _roomController.getRoomData(_roomController.roomsList[index].id.toString(),'Haider');
//
//                         // customDialogTextField(context, isPortrait? 30.w : 60.w,"Create New Room", "Create", (){},);
//                       });
//                     },
//                     child: RoomTile(
//                       onTapEnterRoom: (){
//                         print("Enter room");
//                         _roomController.updateRoomId(_roomController.roomsList[index].id.toString());
//                         print(_roomController.roomsList[index].id.toString());
//                         Get.offAll(() => ShowCaseRoom(initialTitle: _roomController.roomsList[index].name.toString(),
//                           isNewCreated: false, isEditRoom: true,roomId: _roomController.roomsList[index].id.toString(),));
//                         // Get.offAll(()=> RoomScreen(initialTitle: "Room 1", isEditRoom: false,), transition: Transition.rightToLeft);
//                       },
//                       onTapEditRoom: (){
//                         print("Edit room");
//                         customDialogTextField(context,"Edit Room Name", "Save", "Enter Room Name", (){
//                           if(roomNameController.text.toString().isEmpty){
//                             CustomDialog.showErrorDialog(description: "Please Enter Room name");
//
//                           }else{
//                             _roomController.editRoom(roomNameController.text.toString(), _roomController.roomsList[index].id.toString()).whenComplete((){
//                               setState(() {
//                                 _roomController.roomsList[index].name=roomNameController.text;
//                               });
//                               // Future.delayed(Duration(seconds: 3), () {
//                               //   Get.snackbar(
//                               //     'Success',
//                               //     'Task successfully deleted',
//                               //     snackPosition: SnackPosition.TOP,
//                               //     backgroundColor: Color(0xffF7941D), // Background color
//                               //     colorText: Colors.black, // Text color for better visibility
//                               //   );
//                               // });
//                             });
//
//
//                           }
//
//
//                         }, roomNameController,FocusNode());
//
//                         // Get.to(()=> RoomScreen(initialTitle: "Room 1", isEditRoom: true,), transition: Transition.rightToLeft);
//                       },
//                       onTapDeleteRoom: (){
//                         showCustomDialog(context, "assets/images/popup/ask.png", "Are You Sure?", "Are you sure that you want to remove this room from the list?", "Yes, Remove", (){
//                           // _roomController.deleteRoom("10");
//
//                           _roomController.deleteRoom(_roomController.roomsList[index].id.toString()).whenComplete((){
//                             _roomController.roomsList.removeAt(index);
//                             setState(() {
//
//                             });
//                           });
//
//
//                           // Get.back();
//                         }, null);
//                       },
//
//
//                       roomName: _roomController.roomsList[index].name.toString(),
//                       isSelected: selectedRoomIndex == index,
//                     ),
//                   );
//                 },
//               ):Center(
//                   child: Text("No Rooms Created")
//               ),
//             ),
//
//           ),
//           isPortrait? SizedBox.shrink() : Padding(
//             padding: EdgeInsets.fromLTRB(10, 10, 10, 30),
//             child: SizedBox(
//               height: 65,
//               child: CustomButton(
//                 onTap: () {
//                   customDialogTextField(context,"Create New Room", "Create", "Enter Room Name", (){
//
//                     _roomController.createRoom(roomNameController.text.toString()).whenComplete((){
//                       // Future.delayed(Duration(seconds: 5), () {
//                       //   Get.snackbar(
//                       //     'Success',
//                       //     'New room created successfully',
//                       //     snackPosition: SnackPosition.TOP,
//                       //     backgroundColor: Color(0xffF7941D), // Background color
//                       //     colorText: Colors.black, // Text color for better visibility
//                       //   );
//                       // });
//                     });
//                     // Get.to(()=> RoomScreen(initialTitle: "Room Title", isNewCreated: true,));
//                   }, roomNameController,FocusNode());
//                 },
//                 buttonText: "Create New Room",
//               ),
//             ),
//           )
//         ],
//       ),
//
//
//     );
//
//   }
//   Future<void> showConfirmationDialogForPendingTask(bool newValue,String taskId,String taskStatus) async {
//     TextEditingController memberController=TextEditingController();
//     final result = await showDialog<bool>(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) {
//         return BackdropFilter(
//           filter: ImageFilter.blur(
//             sigmaX: 6,
//             sigmaY: 6,
//           ),
//           child: SizedBox(
//             width: MediaQuery.of(context).size.width,
//             child: Dialog(
//               insetPadding: EdgeInsets.symmetric(horizontal:  MediaQuery.of(context).orientation == Orientation.portrait? 20.w : 50.w),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10.0),
//               ),
//               backgroundColor: Colors.white,
//               child: SingleChildScrollView(
//                 physics: BouncingScrollPhysics(),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     SizedBox(
//                       height: 10,
//                     ),
//                     Align(
//                       alignment: Alignment.topRight,
//                       child: InkWell(
//                         onTap: () {
//                           _controller.value = false;
//                           Get.back();
//                         },
//                         child: Container(
//                           height: 45,
//                           width: 45,
//                           margin: EdgeInsets.only(right: 10),
//                           child: Center(
//                             child: Image.asset(
//                               "assets/images/popup/cancel_icon.png",
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 30,
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 40.0),
//                       child: Text(
//                         "Enter your Name to complete Task",
//                         style: headingLarge.copyWith(
//                             color: Colors.black, fontSize: 22),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 45,
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 15.0, right: 15.0),
//                       child: AuthTextField(
//                         controller: memberController,
//                         keyboardType: TextInputType.name,
//                         hintText: "Enter Name",
//                       ),
//                     ),
//                     SizedBox(
//                       height: 50,
//                     ),
//                     Padding(
//                       padding:
//                       const EdgeInsets.symmetric(horizontal: 22.0, vertical: 8),
//                       child: ZoomTapAnimation(
//                           onTap: () {
//                             _roomController.changeTaskStatus(taskId, taskStatus=='0'?'1':'0', memberController.text.toString());
//                             Get.back();
//                           },
//                           onLongTap: () {},
//                           enableLongTapRepeatEvent: false,
//                           longTapRepeatDuration: const Duration(milliseconds: 100),
//                           begin: 1.0,
//                           end: 0.93,
//                           beginDuration: const Duration(milliseconds: 20),
//                           endDuration: const Duration(milliseconds: 120),
//                           beginCurve: Curves.decelerate,
//                           endCurve: Curves.fastOutSlowIn,
//                           child: Container(
//                             height: 56,
//                             width: double.infinity,
//                             decoration: BoxDecoration(
//                               color: AppColors.buttonColor,
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: Center(
//                               child: Text("Continue",
//                                   style: headingSmall.copyWith(
//                                     fontSize: 17,
//                                     color: Colors.white,
//                                   )),
//                             ),
//                           )),
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//   Future<void> showConfirmationDialog(bool newValue,String taskId,String taskStatus,String member) async {
//     TextEditingController memberController=TextEditingController();
//     final result = await showDialog<bool>(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) {
//         return BackdropFilter(
//           filter: ImageFilter.blur(
//             sigmaX: 6,
//             sigmaY: 6,
//           ),
//           child: SizedBox(
//             width: MediaQuery.of(context).size.width,
//             child: Dialog(
//               insetPadding: EdgeInsets.symmetric(horizontal:  MediaQuery.of(context).orientation == Orientation.portrait? 20.w : 50.w),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10.0),
//               ),
//               backgroundColor: Colors.white,
//               child: SingleChildScrollView(
//                 physics: BouncingScrollPhysics(),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     SizedBox(
//                       height: 10,
//                     ),
//                     Align(
//                       alignment: Alignment.topRight,
//                       child: InkWell(
//                         onTap: () {
//                           _controller.value = false;
//                           Get.back();
//                         },
//                         child: Container(
//                           height: 45,
//                           width: 45,
//                           margin: EdgeInsets.only(right: 10),
//                           child: Center(
//                             child: Image.asset(
//                               "assets/images/popup/cancel_icon.png",
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 30,
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 40.0),
//                       child: Text(
//                         "Enter your Name to complete Task",
//                         style: headingLarge.copyWith(
//                             color: Colors.black, fontSize: 22),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 45,
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 15.0, right: 15.0),
//                       child: AuthTextField(
//                         controller: memberController,
//                         keyboardType: TextInputType.name,
//                         hintText: "Enter Name",
//                       ),
//                     ),
//                     SizedBox(
//                       height: 50,
//                     ),
//                     Padding(
//                       padding:
//                       const EdgeInsets.symmetric(horizontal: 22.0, vertical: 8),
//                       child: ZoomTapAnimation(
//                           onTap: () {
//                             if(memberController.text.toString().isEmpty){
//                               // _roomController.changeTaskStatus(taskId, taskStatus=='0'?'1':'0', memberController.text.toString());
//                               Get.back();
//                             }
//                             if(memberController.text.toString()!=member && memberController.text.toString().isNotEmpty){
//                               Get.back();
//                               // Future.delayed(Duration(seconds: 1), () {
//                               //   Get.snackbar(
//                               //     'Completed Task',
//                               //     'Task status can not be changed by you.',
//                               //     snackPosition: SnackPosition.TOP,
//                               //     backgroundColor: Color(0xffF7941D), // Background color
//                               //     colorText: Colors.black, // Text color for better visibility
//                               //   );
//                               // });
//                             }
//                             else{
//                               _roomController.changeTaskStatus(taskId, taskStatus=='0'?'1':'0', memberController.text.toString());
//                               Get.back();
//                             }
//
//                           },
//                           onLongTap: () {},
//                           enableLongTapRepeatEvent: false,
//                           longTapRepeatDuration: const Duration(milliseconds: 100),
//                           begin: 1.0,
//                           end: 0.93,
//                           beginDuration: const Duration(milliseconds: 20),
//                           endDuration: const Duration(milliseconds: 120),
//                           beginCurve: Curves.decelerate,
//                           endCurve: Curves.fastOutSlowIn,
//                           child: Container(
//                             height: 56,
//                             width: double.infinity,
//                             decoration: BoxDecoration(
//                               color: AppColors.buttonColor,
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: Center(
//                               child: Text("Continue",
//                                   style: headingSmall.copyWith(
//                                     fontSize: 17,
//                                     color: Colors.white,
//                                   )),
//                             ),
//                           )),
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//   Future<void> showConfirmationDialogDeleteNotification(String notificationId) async {
//     TextEditingController memberController=TextEditingController();
//     final result = await showDialog<bool>(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) {
//         return BackdropFilter(
//           filter: ImageFilter.blur(
//             sigmaX: 6,
//             sigmaY: 6,
//           ),
//           child: SizedBox(
//             width: MediaQuery.of(context).size.width,
//             child: Dialog(
//               insetPadding: EdgeInsets.symmetric(horizontal:  MediaQuery.of(context).orientation == Orientation.portrait? 20.w : 50.w),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10.0),
//               ),
//               backgroundColor: Colors.white,
//               child: SingleChildScrollView(
//                 physics: BouncingScrollPhysics(),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     SizedBox(
//                       height: 10,
//                     ),
//                     Align(
//                       alignment: Alignment.topRight,
//                       child: InkWell(
//                         onTap: () {
//                           _controller.value = false;
//                           Get.back();
//                         },
//                         child: Container(
//                           height: 45,
//                           width: 45,
//                           margin: EdgeInsets.only(right: 10),
//                           child: Center(
//                             child: Image.asset(
//                               "assets/images/popup/cancel_icon.png",
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 30,
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 40.0),
//                       child: Text(
//                         "Enter your Name to complete Task",
//                         style: headingLarge.copyWith(
//                             color: Colors.black, fontSize: 22),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 45,
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 15.0, right: 15.0),
//                       child: AuthTextField(
//                         controller: memberController,
//                         keyboardType: TextInputType.name,
//                         hintText: "Enter Name",
//                       ),
//                     ),
//                     SizedBox(
//                       height: 50,
//                     ),
//                     Padding(
//                       padding:
//                       const EdgeInsets.symmetric(horizontal: 22.0, vertical: 8),
//                       child: ZoomTapAnimation(
//                           onTap: () {
//
//                           },
//                           onLongTap: () {},
//                           enableLongTapRepeatEvent: false,
//                           longTapRepeatDuration: const Duration(milliseconds: 100),
//                           begin: 1.0,
//                           end: 0.93,
//                           beginDuration: const Duration(milliseconds: 20),
//                           endDuration: const Duration(milliseconds: 120),
//                           beginCurve: Curves.decelerate,
//                           endCurve: Curves.fastOutSlowIn,
//                           child: Container(
//                             height: 56,
//                             width: double.infinity,
//                             decoration: BoxDecoration(
//                               color: AppColors.buttonColor,
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: Center(
//                               child: Text("Continue",
//                                   style: headingSmall.copyWith(
//                                     fontSize: 17,
//                                     color: Colors.white,
//                                   )),
//                             ),
//                           )),
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//
// }
//
