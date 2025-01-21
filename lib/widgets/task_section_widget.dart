import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:get/get.dart';
import 'package:one_love/constants/global_variables.dart';
import 'package:one_love/controllers/room_controller.dart';
import 'package:one_love/views/home/room_screen.dart';
import 'package:one_love/widgets/custom_dialog.dart';
import 'package:one_love/widgets/text_form_fields.dart';
import 'package:sizer/sizer.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../controllers/auth_controller.dart';

class Task {
  final String name;
  final DateTime lastCompleted;
  final String status;
  bool isCompleted;

  Task({
    required this.name,
    required this.lastCompleted,
    required this.status,
    this.isCompleted = false,

  });
}

class TaskSection extends StatelessWidget {
  final String title;
  final List<Task> tasks;
  final bool isCompleted;
  final bool isEdit;

  TaskSection({
    required this.title,
    required this.tasks,
    this.isCompleted = false,
    this.isEdit = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: headingMedium),
          SizedBox(height: 8),
          Container(
            color: Colors.grey,
            child: Column(
              children: tasks.map((task) => TaskTile(task: task, isCompletedSection: isCompleted, isEdit: isEdit,)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class TaskTile extends StatefulWidget {
  final Task task;
  final bool isCompletedSection;
  final bool isEdit;
  void Function()? onTapEdit;
  void Function()? onTapRemove;
  void Function()? onTapRemoveCompletedTasks;
  // void Function(dynamic)? onChanged;
  final String? completeBy;
  void Function()? onTapChangeStatus;
  final String? createdAt;
  final String? dateTime;

  TaskTile({required this.task, required this.isCompletedSection,this.isEdit = false, this.onTapEdit,this.onTapRemove,this.completeBy,this.onTapRemoveCompletedTasks,this.onTapChangeStatus,this.createdAt,this.dateTime});

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  late ValueNotifier<bool> _controller = ValueNotifier<bool>(false);
  AuthController _authController=Get.find();

  @override
  void initState() {
    super.initState();

    _controller.value = widget.task.isCompleted;
    _controller = ValueNotifier(widget.isCompletedSection);

    _controller.addListener(() {
      setState(() {
        widget.task.isCompleted = _controller.value;
      });
    });
  }

  // Future<void> showConfirmationDialog(bool newValue) async {
  //   final result = await showDialog<bool>(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (context) {
  //       return BackdropFilter(
  //         filter: ImageFilter.blur(
  //           sigmaX: 6,
  //           sigmaY: 6,
  //         ),
  //         child: SizedBox(
  //           width: MediaQuery.of(context).size.width,
  //           child: Dialog(
  //             insetPadding: EdgeInsets.symmetric(horizontal:  MediaQuery.of(context).orientation == Orientation.portrait? 20.w : 50.w),
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(10.0),
  //             ),
  //             backgroundColor: Colors.white,
  //             child: SingleChildScrollView(
  //               physics: BouncingScrollPhysics(),
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   SizedBox(
  //                     height: 10,
  //                   ),
  //                   Align(
  //                     alignment: Alignment.topRight,
  //                     child: InkWell(
  //                       onTap: () {
  //                         _controller.value = false;
  //                         Get.back();
  //                       },
  //                       child: Container(
  //                         height: 45,
  //                         width: 45,
  //                         margin: EdgeInsets.only(right: 10),
  //                         child: Center(
  //                           child: Image.asset(
  //                             "assets/images/popup/cancel_icon.png",
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                   SizedBox(
  //                     height: 30,
  //                   ),
  //                   Padding(
  //                     padding: const EdgeInsets.symmetric(horizontal: 40.0),
  //                     child: Text(
  //                       "Enter your Name to complete Task",
  //                       style: headingLarge.copyWith(
  //                           color: Colors.black, fontSize: 22),
  //                       textAlign: TextAlign.center,
  //                     ),
  //                   ),
  //                   const SizedBox(
  //                     height: 45,
  //                   ),
  //                   Padding(
  //                     padding: const EdgeInsets.only(left: 15.0, right: 15.0),
  //                     child: AuthTextField(
  //                       keyboardType: TextInputType.name,
  //                       hintText: "Enter Name",
  //                     ),
  //                   ),
  //                   SizedBox(
  //                     height: 50,
  //                   ),
  //                   Padding(
  //                     padding:
  //                     const EdgeInsets.symmetric(horizontal: 22.0, vertical: 8),
  //                     child: ZoomTapAnimation(
  //                         onTap: () {
  //                           Get.back();
  //                         },
  //                         onLongTap: () {},
  //                         enableLongTapRepeatEvent: false,
  //                         longTapRepeatDuration: const Duration(milliseconds: 100),
  //                         begin: 1.0,
  //                         end: 0.93,
  //                         beginDuration: const Duration(milliseconds: 20),
  //                         endDuration: const Duration(milliseconds: 120),
  //                         beginCurve: Curves.decelerate,
  //                         endCurve: Curves.fastOutSlowIn,
  //                         child: Container(
  //                           height: 56,
  //                           width: double.infinity,
  //                           decoration: BoxDecoration(
  //                             color: AppColors.buttonColor,
  //                             borderRadius: BorderRadius.circular(10),
  //                           ),
  //                           child: Center(
  //                             child: Text("Continue",
  //                                 style: headingSmall.copyWith(
  //                                   fontSize: 17,
  //                                   color: Colors.white,
  //                                 )),
  //                           ),
  //                         )),
  //                   ),
  //                   const SizedBox(
  //                     height: 20,
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return Container(

      child: Column(
        children: [
          Card(

            // semanticContainer: true,
            margin: EdgeInsets.symmetric(vertical: 4,horizontal: 2),
            child: Padding(
              padding: const EdgeInsets.only(left: 15,right: 8,top: 8,bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.isEdit?
                  Container(
                      // width: 390,

                    // height: 40,
                    // height: 100,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            // color: Colors.green,
                            child: Tooltip(
                                margin: EdgeInsets.only(right: isPortrait?150:300),
                                showDuration: Duration(seconds: 4),
                                waitDuration: Duration(seconds: 1),
                                message: widget.task.name,
                                child: Text(widget.task.name, style: headingMedium, maxLines: 2, overflow: TextOverflow.ellipsis,)),
                          ),
                        ),
                        if (widget.isCompletedSection)
        _authController.isAdminView==true?
                          PopupMenuButton<String>(

                            shape: ContinuousRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
offset: Offset(widget.isCompletedSection?0:-200, widget.isCompletedSection?0:0),
                           position:PopupMenuPosition.under,

                            color: Colors.red,
                          onSelected: (value) {
                          },
                          itemBuilder: (BuildContext context) {
                            return [
                              PopupMenuItem(


                                onTap: widget.onTapRemoveCompletedTasks,
                                //     (){
                                //   showCustomDialog(context, "assets/images/popup/ask.png", "Are You Sure?", "Are you sure that you want to remove this task from the list?", "Yes, Remove", (){
                                //     Get.back();
                                //   }, null);
                                // },
                                value: 'remove',
                                child: Center(child: Text("Remove from list", style: bodyMedium.copyWith(color: Colors.white),)),
                              ),
                            ];
                          },
                        ):Container(height: 42,) else
                          _authController.isAdminView==true?
                          PopupMenuButton<String>(
                            offset: Offset(widget.isCompletedSection?0:-120, widget.isCompletedSection?0:10),

                            shape: ContinuousRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            position: PopupMenuPosition.under,
                            onSelected: (value) {
                            },
                            itemBuilder: (BuildContext context) {
                              return [
                                PopupMenuItem(
                                  value: 'edit',
                                  child: Text("Edit Task", style: bodyMedium,),
                                  onTap: widget.onTapEdit,
                                ),
                                PopupMenuItem(
                                  onTap: widget.onTapRemove,
                                  value: 'remove',
                                  child: Text("Remove from list", style: bodyMedium,),
                                ),
                              ];
                            },
                          ):Container(height: 42,),
                      ],
                    ),
                  )
                      : Row(
                    children: [
                      Expanded(
                          child: Tooltip(
                              margin: EdgeInsets.only(right: isPortrait?150:300),

                              showDuration: Duration(seconds: 4),
                              waitDuration: Duration(seconds: 1),

                              message: widget.task.name,
                              child: Text(widget.task.name, style: headingSmall, maxLines: 2, overflow: TextOverflow.ellipsis,)),
                          ),
                      SizedBox(height: 45,),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text("${widget.createdAt??"Last Completed:"} ${widget.dateTime??"Fri,7 June, 2024 9:40 am"}", style: bodyMedium.copyWith(color: Colors.black54)),
                  Divider(
                    height: 20,
                    color: Colors.black12,
                    thickness: 1.5,
                  ),
                  if (widget.isCompletedSection)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Container(
                                      width: 30,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.black12
                                      ),
                                      child: Image.asset("assets/icons/user_icon.png", scale: 4,))),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Completed by ",
                                          style: headingSmall.copyWith(color: Colors.black, fontSize: 13),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                       isPortrait?SizedBox.shrink(): Expanded(
                                          child: Text(
                                            "${widget.completeBy??'James'}",
                                            style: headingMedium.copyWith(color: Colors.green,fontWeight: FontWeight.w500),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                   isPortrait? Container(
                                      width: 200,
                                      child: Text(
                                        "${widget.completeBy??'James'}",
                                        style: bodyMedium.copyWith(color: Colors.green,fontWeight: FontWeight.w500),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ):SizedBox.shrink(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap:widget.onTapChangeStatus,
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 5,horizontal: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.green,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                Text("Completed", style: headingMedium.copyWith(fontSize: 11, color: Colors.white),),
                                SizedBox(width: 5,),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(100)
                                  ),
                                  width: 20,
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                        // GestureDetector(
                        //   onTap: (){
                        //     print("object");
                        //   },
                        //   child: AdvancedSwitch(
                        //     onChanged:widget.onChanged ,
                        //     controller: _controller,
                        //     activeColor: Colors.green,
                        //     enabled: false,
                        //     thumb: Container(decoration: BoxDecoration(
                        //         shape: BoxShape.circle,
                        //         color: Colors.black
                        //     ),),
                        //     inactiveColor: Colors.black12,
                        //     activeChild: Text("Complete", style: headingSmall.copyWith(fontSize: 11, color: Colors.white)),
                        //     inactiveChild: Text("Pending", style: headingSmall.copyWith(fontSize: 11, color: Colors.black),),
                        //     borderRadius: BorderRadius.all(const Radius.circular(15)),
                        //     width: 110.0,
                        //     height: 30.0,
                        //     disabledOpacity: 0.5,
                        //     initialValue: widget.isCompletedSection,
                        //   ),
                        // ),
                      ],
                    )
                  else
                    Container(
                      // width: 380,

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(widget.task.status, style: headingMedium.copyWith(color: Colors.orange)),
                          InkWell(
                            onTap:widget.onTapChangeStatus,
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 5,horizontal: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.black12,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(100)
                                    ),
                                    width: 20,
                                    height: 20,
                                  ),
                                  SizedBox(width: 5,),
                                  Text("Pending", style: headingMedium.copyWith(fontSize: 11, color: Colors.black),)
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${_formatWeekday(date.weekday)}, ${date.day} ${_formatMonth(date.month)}, ${date.year}  ${_formatTime(date)}';
  }

  String _formatWeekday(int weekday) {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return weekdays[weekday - 1];
  }

  String _formatMonth(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  String _formatTime(DateTime date) {
    final hour = date.hour;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'pm' : 'am';
    final formattedHour = hour > 12 ? hour - 12 : hour;
    return '$formattedHour:$minute $period';
  }
}

class TaskManagementPage extends StatefulWidget {
  @override
  _TaskManagementPageState createState() => _TaskManagementPageState();
}

class _TaskManagementPageState extends State<TaskManagementPage> {
  List<Task> pendingTasks = [
    Task(name: 'Feed All Animals', lastCompleted: DateTime(2024, 7, 5, 9, 40), status: 'Ongoing'),
    // Add more tasks as needed
  ];

  List<Task> completedTasks = [
    Task(name: 'Clean Food Bowl', lastCompleted: DateTime(2024, 7, 6, 9, 40), status: 'Completed', isCompleted: true),
    // Add more tasks as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Management'),
      ),
      body: Row(
        children: [
          Expanded(
            child: TaskSection(title: 'Pending Tasks', tasks: pendingTasks),
          ),
          VerticalDivider(),
          Expanded(
            child: TaskSection(title: 'Completed Tasks', tasks: completedTasks, isCompleted: true),
          ),
        ],
      ),
    );
  }

  void _updateTaskStatus(Task task) {
    setState(() {
      if (task.isCompleted) {
        pendingTasks.remove(task);
        completedTasks.add(task);
      } else {
        completedTasks.remove(task);
        pendingTasks.add(task);
      }
    });
  }
}


// AdvancedSwitch(
// controller: _controller,
// thumb: Container(decoration: BoxDecoration(
// shape: BoxShape.circle,
// color: Colors.black
// ),),
// activeColor: Colors.green,
// inactiveColor: Colors.black12,
// activeChild: Text("Completed", style: headingSmall.copyWith(fontSize: 11, color: Colors.white)),
// inactiveChild: Text("Pending", style: headingSmall.copyWith(fontSize: 11, color: Colors.black),),
// borderRadius: BorderRadius.all(const Radius.circular(15)),
// width: 110.0,
// height: 30.0,
// enabled: false,
// disabledOpacity: 0.5,
// onChanged: widget.onChanged
// //     (value) async {
// //   if(value)
// //     {
// //        await _showConfirmationDialog(value);
// //     }
// // },
// ),