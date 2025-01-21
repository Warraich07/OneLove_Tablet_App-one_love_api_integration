import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:keep_screen_on/keep_screen_on.dart';
import 'package:one_love/constants/global_variables.dart';
import 'package:one_love/controllers/room_controller.dart';
import 'package:one_love/utils/shared_preference.dart';
import 'package:one_love/views/home/home_screen.dart';
import 'package:one_love/widgets/custom_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:sizer/sizer.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import '../../constants/custom_validators.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/general_controller.dart';
import '../../models/tasks_model.dart';
import '../../widgets/custom_dialog.dart';
import '../../widgets/task_section_widget.dart';
import '../../widgets/text_form_fields.dart';
import 'package:cron/cron.dart' as cr;
import 'package:reorderable_grid/reorderable_grid.dart';

class RoomScreen extends StatefulWidget {
  final bool isNewCreated;
  final bool isEditRoom;
  final String initialTitle;
  final String? roomId;
  final String? userName;

  const RoomScreen(
      {super.key,
      this.isNewCreated = false,
      this.isEditRoom = false,
      required this.initialTitle,this.roomId, this.userName});

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  late TextEditingController _titleController;

  late ValueNotifier<bool> _controller = ValueNotifier<bool>(false);
  final FocusNode _focusNode = FocusNode();
  // bool onboardingShown=false;

  final GlobalKey _showcaseKey = GlobalKey();
  getData() async {
    Future.delayed(Duration(milliseconds: 10), () async {
      final AuthPreference _authPreference = AuthPreference.instance;
      String roomId=await _authPreference.getRoomId();
      print(roomId+">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
     await _roomController.getRoomData(widget.roomId??roomId,widget.userName??'Haider');
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // onboardingShown = prefs.getBool('onboardingShown') ?? false;
      // prefs.setBool('onboardingShown', true);
      //
      // if(!onboardingShown){
      //   WidgetsBinding.instance?.addPostFrameCallback((_) {
      //     ShowCaseWidget.of(context).startShowCase([_showcaseKey]);
      //   });
      // }
    });
  }
  cr.Cron? cron;
  void startCronJob() {
    cron = cr.Cron();

    // Schedule the cron job to run every minute
    cron?.schedule(cr.Schedule.parse('*/1 * * * *'), () async {
      // Get the current time from _generalController.formattedDateTime.value
      String currentTime = _generalController.formattedDateTime.value;

      // Check if the time is exactly 8:10 PM
      if (currentTime.contains('12:00 AM')) {
        await getData();
      } else {
        print("It's not 8:10 PM yet. Waiting...");
      }
    });
  }
  getRoomIndexForTileColor()async{
    String roomIndex=await AuthPreference.instance.getRoomIndex();
    _roomController.roomIndexForSelectedRoom.value=int.parse(roomIndex);
    print(">>>>>>>>>>>>>>>>>>>>>>>>index value<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
    // setState(() {
    //
    // });
  }
  @override
  void initState() {
    startCronJob();
    if(_authController.isAdminView==false){
      KeepScreenOn.turnOn();
      getRoomIndexForTileColor();
    }
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);

    getData();
    if(_authController.isNotificationView==true){
      _authController.updateViewToNotificationScreen(false);
      setState(() {

      });
    }

  }

  @override
  void dispose() {
    _titleController.dispose();
    KeepScreenOn.turnOff();
    super.dispose();
  }

  void _handleSubmitted(String value) {
    print("Submitted: $value");
    FocusScope.of(context).unfocus();
  }


  TextEditingController taskController=TextEditingController();
  TextEditingController _problemTitleController=TextEditingController();
  TextEditingController _problemController=TextEditingController();
  TextEditingController _nameController=TextEditingController();
  RoomController _roomController=Get.find();
  AuthController _authController=Get.find();
  TextEditingController _adminEmailController=TextEditingController();
  TextEditingController _adminPasswordController=TextEditingController();
  DateTime? selectedDate;
  GeneralController _generalController=Get.find();
  final ScrollController _scrollControllerForPendingTasks = ScrollController();
  final ScrollController _scrollControllerForCompletedTasks = ScrollController();
  final AuthPreference _authPreference = AuthPreference.instance;


  Future<void> _selectDate(BuildContext context) async {
    final ThemeData theme = ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: AppColors.primaryColor ,// Example color for primary theme
        onPrimary: Colors.white, // Example color for text on primary
        onSurface: Colors.black, // Example color for text on surface
        surface: Colors.white, // Example background color for surface
        onBackground: Colors.black, // Example color for text on background
        onSecondary: Colors.black, // Example color for secondary text
      ),
    );

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: theme,
          child: child!,
        );
      },
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;

        // Format the date to 'yyyy-MM-dd'
        String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate!);

        // Call the API with the formatted date
        _roomController.getFilteredRoomData(
          widget.roomId ?? '',
          widget.userName ?? 'Haider',
          formattedDate,
        );
      print("this is");
        // Format for display
        String updatedData = DateFormat('EEE, d MMMM yyyy').format(selectedDate!);
        String todayDate = DateFormat('EEE, d MMMM yyyy').format(DateTime.now());

        if (updatedData == todayDate) {
          print(">>>>>>>");

          _generalController.updateDateForRoom("");
        } else {
          print("kaka");
          print(updatedData);
          _roomController.updateDateAfterFiltering(updatedData);
          _generalController.updateDateForRoom(updatedData);
        }
      });
    }
  }

  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime? pickedDate = await showDatePicker(
  //     context: context,
  //     initialDate: selectedDate ?? DateTime.now(),
  //     firstDate: DateTime(2000),
  //     lastDate: DateTime.now(),
  //   );
  //
  //   if (pickedDate != null && pickedDate != selectedDate) {
  //     setState(() {
  //       selectedDate = pickedDate;
  //       // Format the date to 'yyyy-MM-dd'
  //       String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate!);
  //
  //       _roomController.getFilteredRoomData(widget.roomId??'', widget.userName??'Haider', formattedDate);
  //       String updatedData = DateFormat('EEE, d MMMM yyyy').format(selectedDate!);
  //       // print(updatedData);
  //       // _generalController.updateDate(updatedData);
  //       String todayDate = DateFormat('EEE, d MMMM yyyy').format(DateTime.now());
  //       if(updatedData==todayDate){
  //         _generalController.updateDateForRoom("");
  //       }else{
  //         print(updatedData);
  //         _generalController.updateDateForRoom(updatedData);}
  //
  //     });
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDateTime = DateFormat('EEE, d MMMM, yyyy h:mm a').format(now);
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        toolbarHeight: 80,
        elevation: 1,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                // print(_authController.isAdminView.value);
                if(_authController.isAdminView.value){
                  _generalController.updateDateForRoom("");
                  _roomController.updateDateAfterFiltering('');
                  _authPreference.setStaffView('0');
                  _authController.updateIsAdminView(true);
                  Get.offAll(()=> HomeScreen());
                }else{
                  _adminEmailController.clear();
                  _adminPasswordController.clear();
                  customDialogEnterCredentials(
                      context,
                      "Enter your Credential to access Dashboard",
                      "Log In",
                      true, () {},_adminEmailController,_adminPasswordController,()async{
                    if(_roomController.adminKey.currentState!.validate()){
                      await _authController.loginUserForAdminAccess(_adminEmailController.text.toString(), _adminPasswordController.text.toString());
                      _adminEmailController.clear();
                      _adminPasswordController.clear();
                    }

                  },
                    _focusNode
                  );
                }


              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 15, 20, 15),
                child: Image.asset(
                  "assets/images/app_logo.png",
                  scale: 3,
                ),
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                         _titleController.text.toString(),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  SizedBox(
                    height: 60,
                    width: 190,
                    child: CustomButton(
                      onTap: () {
                        _problemTitleController.clear();
                        _problemController.clear();
                        _nameController.clear();
                        customDialogReportProblem(
                            context, "Report a problem", "Submit", () {
                              if(_roomController.reportProblemKey.currentState!.validate()){
                                Get.back();
                                _roomController.reportProblem(_problemTitleController.text.toString(), _problemController.text.toString(),context,_nameController.text.toString());
                                // showCustomDialog(context, "assets/images/popup/success.png", "Thank you for your submission", "Thanks for reporting an issue, your report has been submitted successfully.", "Okay", (){Get.back();
                                // }, null,);
                              }

                        },_problemTitleController,_problemController,_nameController);
                      },
                      buttonText: "Report a problem",
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Obx(
          ()=> Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18.0, vertical: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Column(
                                    //   crossAxisAlignment:
                                    //       CrossAxisAlignment.start,
                                    //   children: [
                                    //    
                                    //     SizedBox(
                                    //       height: 8,
                                    //     ),
                                    //
                                    //   ],
                                    // ),
                                    Column(
                                      crossAxisAlignment:CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "Tasks Progress",
                                              style: headingMedium,
                                            ),
                                          isPortrait?Container():  Row(
                                              crossAxisAlignment:CrossAxisAlignment.center,
                                                 children:[
                                                   SizedBox(width:10),
                                                   // isPortrait?Container():
                                                   SizedBox(
                                                     width: 150,
                                                     child: LinearProgressIndicator(
                                                       value: _roomController.completedTasksList.isEmpty?0: _roomController.completedTasksList.length/((_roomController.tasksList.isEmpty?0:_roomController.tasksList.length)+(_roomController.completedTasksList.isEmpty?0:_roomController.completedTasksList.length)),
                                                       // Update this value based on progress
                                                       backgroundColor: Colors.grey[300],
                                                       valueColor:
                                                       AlwaysStoppedAnimation<Color>(
                                                           Colors.green),
                                                     ),
                                                   ),
                                                   SizedBox(
                                                     width: 10,
                                                   ),
                                                   Text(
                                                     "${_roomController.completedTasksList.isEmpty?0: _roomController.completedTasksList.length}/${(_roomController.tasksList.isEmpty?0:_roomController.tasksList.length)+(_roomController.completedTasksList.isEmpty?0:_roomController.completedTasksList.length)} Tasks completed",
                                                     style: headingSmall.copyWith(
                                                         color: Colors.grey,
                                                         fontSize: 13),
                                                   ),
                                                 ]
                                            ),

                                          ],
                                        ),
                                        isPortrait?Container(): SizedBox(height:10),
                                        isPortrait? Row(
                                            children:[
                                              // SizedBox(width:10),
                                              // isPortrait?Container():
                                              SizedBox(
                                                width: 130,
                                                child: LinearProgressIndicator(
                                                  value: _roomController.completedTasksList.isEmpty?0: _roomController.completedTasksList.length/((_roomController.tasksList.isEmpty?0:_roomController.tasksList.length)+(_roomController.completedTasksList.isEmpty?0:_roomController.completedTasksList.length)),
                                                  // Update this value based on progress
                                                  backgroundColor: Colors.grey[300],
                                                  valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Colors.green),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                "${_roomController.completedTasksList.isEmpty?0: _roomController.completedTasksList.length}/${(_roomController.tasksList.isEmpty?0:_roomController.tasksList.length)+(_roomController.completedTasksList.isEmpty?0:_roomController.completedTasksList.length)} Tasks completed",
                                                style: headingSmall.copyWith(
                                                    color: Colors.grey,
                                                    fontSize: 13),
                                              ),
                                            ]
                                        ):Container(),
                                      ],
                                    ),

                                    Row(
                                      children: [
                                        Obx(
                                        ()=>GestureDetector(
                                          onTap: () {
                                            // selectedDate=null;
                                            _selectDate(context);
                                          },
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Row(
                                                children: [

                                                  Text(
                                                    _generalController.roomDate.isEmpty?  _generalController.formattedDateTime.value:_generalController.roomDate.value,
                                                      style: headingSmall.copyWith(
                                                          color: Colors.grey, fontSize: 13),
                                                    ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  GestureDetector(

                                                    child: Image.asset(
                                                      "assets/icons/calender_icon.png",
                                                      scale: 4,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              _generalController.roomDate.isEmpty?Container(): GestureDetector(
                                                  onTap:(){
                                                    selectedDate=null;
                                                  _generalController.updateDateForRoom("");
                                                  _roomController.getFilteredRoomData(widget.roomId??'', widget.userName??'Haider',  "");
                                                },
                                                child: Container(
                                                  padding:EdgeInsets.only(top:5),
                                                  child: Text("Clear filter?",style:TextStyle(color:AppColors.primaryColor)),),
                                              ),
                                            ],
                                          ),
                                        ),
                                        ),


                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              Expanded(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.only(top:10,bottom:10,left:18,right:0),
                                        decoration: BoxDecoration(
                                            color: Color(0xfff5f5f5),
                                            border: Border(
                                                right: BorderSide(
                                                  color: Colors.black12,
                                                ),
                                                top: BorderSide(
                                                    color: Colors.black12))),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.circle,
                                                  color: Colors.deepOrangeAccent,
                                                  size: 14,
                                                ),
                                                SizedBox(
                                                  width: 6,
                                                ),
                                                Text(
                                                  "Pending Tasks",
                                                  style: headingSmall,
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            widget.isNewCreated == false && MediaQuery.of(context).orientation == Orientation.landscape
                                                ? Expanded(
                                                    child: Scrollbar(
                                                      controller: _scrollControllerForPendingTasks,
                                                      thumbVisibility: true,
                                                      thickness: 6,
                                                      interactive: true,
                                                      trackVisibility: true,
                                                      scrollbarOrientation:
                                                      ScrollbarOrientation.right,
                                                      // hoverThickness: 15,
                                                      radius: const Radius.circular(0),
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(right:10),
                                                        child: ListView(
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              SizedBox(height: 10),
                                                              _roomController.pendingDailyTasksList.isEmpty?Column(
                                                                children: [
                                                                  Align(
                                                                      alignment:Alignment.centerLeft,
                                                                      child: Text("Daily Tasks", style: headingMedium)),
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(top:50,bottom:30),

                                                                    child: Align(
                                                                        alignment:Alignment.center,
                                                                        child: Text("No daily tasks yet", style: subHeading)),
                                                                  ),
                                                                ],
                                                              ) :Text("Daily Tasks", style: headingMedium),
                                                              SizedBox(height: 10),
                                                              Container(
                                                                // height: _roomController.pendingDailyTasksList.length%2 == 0? (_roomController.pendingDailyTasksList.length/2) * 180 : (_roomController.pendingDailyTasksList.length/2).ceil()*180,
                                                                child:_authController.isAdminView==false?GridView.builder(
                                                                    shrinkWrap: true,
                                                                    physics: NeverScrollableScrollPhysics(),
                                                                    itemCount: _roomController.pendingDailyTasksList.length,
                                                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                                      crossAxisCount: 2,
                                                                      childAspectRatio: 2.8,
                                                                      crossAxisSpacing: 4.0,),

                                                                    itemBuilder: (BuildContext context, int index) {
                                                                      return  GestureDetector(
                                                                        // key: ValueKey( _roomController.pendingDailyTasksList[index]),

                                                                        child: TaskTile(
                                                                          createdAt:_roomController.pendingDailyTasksList[index].lastCompletedDateTime!=null?'Last Completed: ': "Created At: ",
                                                                          dateTime: _roomController.updateDateTime(_roomController.pendingDailyTasksList[index].createdAt.toString()),
                                                                          task: Task(name: _roomController.pendingDailyTasksList[index].name, lastCompleted: DateTime(2024, 6, 7, 9, 40), status: 'Ongoing'),
                                                                          isCompletedSection:_roomController.pendingDailyTasksList[index].status.toString()=='0'? false:true,
                                                                          isEdit: true,
                                                                          onTapEdit: (){
                                                                            _roomController.updateTaskDurability("Daily",'1');
                                                                            taskController.text=_roomController.pendingDailyTasksList[index].name;
                                                                            customDialogNewTask(context, "Edit Task", "Save Changes", (){
                                                                              if( _roomController.createTaskKey.currentState!.validate()){
                                                                                _roomController.editTask(taskController.text.toString(), _roomController.pendingDailyTasksList[index].roomId.toString(), _roomController.taskValue.toString(),  _roomController.pendingDailyTasksList[index].id.toString());
                                                                              }
                                                                              // print("save");
                                                                              // Get.back();
                                                                              // Get.off(()=> RoomScreen(initialTitle: ""));
                                                                            },taskController,FocusNode());
                                                                          },
                                                                          onTapRemove: (){
                                                                            showCustomDialog(context, "assets/images/popup/ask.png", "Are You Sure?", "Are you sure that you want to remove this task from the list?", "Yes, Remove", (){

                                                                              _roomController.deleteTask(_roomController.pendingDailyTasksList[index].id.toString());

                                                                              print("Delete taskt");
                                                                              // Get.back();
                                                                            }, null);
                                                                          },
                                                                          // onChanged: (value) async {
                                                                          // print("object");
                                                                          //   if(value)
                                                                          //   {
                                                                          //     await showConfirmationDialog(value,_roomController.pendingDailyTasksList[index].id.toString(),_roomController.pendingDailyTasksList[index].status.toString());
                                                                          //   }
                                                                          // },
                                                                          onTapChangeStatus: (){
                                                                            showConfirmationDialogForPendingStatus(true,_roomController.pendingDailyTasksList[index].id.toString(),_roomController.pendingDailyTasksList[index].status.toString());

                                                                          },
                                                                        ),
                                                                      );
                                                                    }) :ReorderableGridView.builder(

                                                                        // buildDefaultDragHandles:_authController.isAdminView==false? false:true,

                                                                    shrinkWrap: true,
                                                                    physics: NeverScrollableScrollPhysics(),
                                                                    itemCount: _roomController.pendingDailyTasksList.length,
                                                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                                        crossAxisCount: 2,
                                                                        childAspectRatio: 2.8,
                                                                        crossAxisSpacing: 4.0,),
                                                                    onReorder:(int oldIndex, int newIndex) {
                                                                      setState(() {
                                                                        if (newIndex > oldIndex) {
                                                                          newIndex -= 1;
                                                                        }
                                                                        final TasksModel item = _roomController.pendingDailyTasksList.removeAt(oldIndex);
                                                                        _roomController.pendingDailyTasksList.insert(newIndex, item);
                                                                        if(oldIndex>newIndex){
                                                                          _roomController.swapTasks(_roomController.pendingDailyTasksList[newIndex].id, _roomController.pendingDailyTasksList[newIndex+1].id);
                                                                        }else{
                                                                          _roomController.swapTasks(_roomController.pendingDailyTasksList[newIndex].id, _roomController.pendingDailyTasksList[newIndex-1].id);
                                                                        }
                                                                      });
                                                                    },
                                                                    itemBuilder: (BuildContext context, int index) {
                                                                      return  GestureDetector(
                                                                        key: ValueKey( _roomController.pendingDailyTasksList[index]),

                                                                        child: TaskTile(
                                                                          createdAt:_roomController.pendingDailyTasksList[index].lastCompletedDateTime!=null?'Last Completed: ': "Created At: ",
                                                                          dateTime: _roomController.updateDateTime(_roomController.pendingDailyTasksList[index].createdAt.toString()),
                                                                          task: Task(name: _roomController.pendingDailyTasksList[index].name, lastCompleted: DateTime(2024, 6, 7, 9, 40), status: 'Ongoing'),
                                                                          isCompletedSection:_roomController.pendingDailyTasksList[index].status.toString()=='0'? false:true,
                                                                          isEdit: true,
                                                                          onTapEdit: (){
                                                                            _roomController.updateTaskDurability("Daily",'1');
                                                                            taskController.text=_roomController.pendingDailyTasksList[index].name;
                                                                            customDialogNewTask(context, "Edit Task", "Save Changes", (){
                                                                             if( _roomController.createTaskKey.currentState!.validate()){
                                                                               _roomController.editTask(taskController.text.toString(), _roomController.pendingDailyTasksList[index].roomId.toString(), _roomController.taskValue.toString(),  _roomController.pendingDailyTasksList[index].id.toString());
                                                                             }
                                                                              // print("save");
                                                                              // Get.back();
                                                                              // Get.off(()=> RoomScreen(initialTitle: ""));
                                                                            },taskController,FocusNode());
                                                                          },
                                                                          onTapRemove: (){
                                                                            showCustomDialog(context, "assets/images/popup/ask.png", "Are You Sure?", "Are you sure that you want to remove this task from the list?", "Yes, Remove", (){

                                                                              _roomController.deleteTask(_roomController.pendingDailyTasksList[index].id.toString());

                                                                              print("Delete taskt");
                                                                              // Get.back();
                                                                            }, null);
                                                                          },
                                                                          // onChanged: (value) async {
                                                                          // print("object");
                                                                          //   if(value)
                                                                          //   {
                                                                          //     await showConfirmationDialog(value,_roomController.pendingDailyTasksList[index].id.toString(),_roomController.pendingDailyTasksList[index].status.toString());
                                                                          //   }
                                                                          // },
                                                                          onTapChangeStatus: (){
                                                                            showConfirmationDialogForPendingStatus(true,_roomController.pendingDailyTasksList[index].id.toString(),_roomController.pendingDailyTasksList[index].status.toString());

                                                                          },
                                                                        ),
                                                                      );
                                                                    }),
                                                              ),
                                                              SizedBox(height: 10),
                                                            ],
                                                          ),
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              _roomController.pendingWeeklyTasksList.isEmpty?Column(
                                                                children: [
                                                                  Align(
                                                                      alignment:Alignment.centerLeft,
                                                                      child: Text("Weekly Tasks", style: headingMedium)),
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(top:55,bottom:35),
                                                                    child: Align(
                                                                        alignment:Alignment.center,
                                                                        child: Text("No weekly tasks yet", style: subHeading)),
                                                                  ),
                                                                ],
                                                              ) :Text("Weekly Tasks", style: headingMedium),
                                                        
                                                              // Text("Weekly Tasks", style: headingMedium),
                                                              SizedBox(height: 10),
                                                              SizedBox(
                                                                // height:500,
                                                                // height: weeklyTasks.length%2 == 0? (weeklyTasks.length/2) * 180 : (weeklyTasks.length/2).ceil()*180,
                                                                child:_authController.isAdminView==false?GridView.builder(
                                                                    shrinkWrap: true,
                                                                    physics: NeverScrollableScrollPhysics(),
                                                                    itemCount: _roomController.pendingWeeklyTasksList.length,
                                                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                                        crossAxisCount: 2,
                                                                        childAspectRatio: 2.8,
                                                                        crossAxisSpacing: 4.0,
                                                                        mainAxisSpacing: 0.0),
                                                                    itemBuilder: (BuildContext context, int index) {
                                                                      // String isoTimestamp = _roomController.pendingWeeklyTasksList[index].createdAt.toString();
                                                                      // DateTime dateTime = DateTime.parse(isoTimestamp);
                                                                      // String formattedDate = DateFormat('EEE, d MMMM yyyy h:mm a').format(dateTime);
                                                                      return GestureDetector(
                                                                        child: TaskTile(
                                                                          createdAt:_roomController.pendingWeeklyTasksList[index].lastCompletedDateTime!=null?'Last Completed: ': "Created At: ",
                                                                          dateTime: _roomController.updateDateTime(_roomController.pendingWeeklyTasksList[index].createdAt.toString()),
                                                                          task: Task(name: _roomController.pendingWeeklyTasksList[index].name, lastCompleted: DateTime(2024, 6, 7, 9, 40), status: 'Ongoing'),
                                                                          isCompletedSection: false,
                                                                          isEdit: true,
                                                                          onTapEdit: (){
                                                                            _roomController.updateTaskDurability("Daily",'1');
                                                                            taskController.text=_roomController.pendingWeeklyTasksList[index].name;
                                                                            customDialogNewTask(context, "Edit Task", "Save Changes", (){
                                                                              if( _roomController.createTaskKey.currentState!.validate()){
                                                                                _roomController.editTask(taskController.text.toString(), _roomController.pendingWeeklyTasksList[index].roomId.toString(), _roomController.taskValue.toString(),  _roomController.pendingWeeklyTasksList[index].id.toString());
                                                                              }
                                                                              // print("save");
                                                                              //
                                                                              // Get.off(()=> RoomScreen(initialTitle: ""));
                                                                            },taskController,FocusNode());
                                                                          },
                                                                          onTapRemove: (){
                                                                            showCustomDialog(context, "assets/images/popup/ask.png", "Are You Sure?", "Are you sure that you want to remove this task from the list?", "Yes, Remove", (){
                                                                              _roomController.deleteTask(_roomController.pendingWeeklyTasksList[index].id.toString());
                                                                              print("Delete taskt");
                                                                              // Get.back();
                                                                            }, null);
                                                                          },
                                                                          // onChanged: (value) async {
                                                                          //   if(value)
                                                                          //   {
                                                                          //     await showConfirmationDialog(value,_roomController.pendingWeeklyTasksList[index].id.toString(),_roomController.pendingWeeklyTasksList[index].status.toString());
                                                                          //   }
                                                                          // },
                                                                          onTapChangeStatus: (){
                                                                            showConfirmationDialogForPendingStatus(true,_roomController.pendingWeeklyTasksList[index].id.toString(),_roomController.pendingWeeklyTasksList[index].status.toString());

                                                                          },
                                                                        ),
                                                                      );
                                                                    }): ReorderableGridView.builder(
                                                                  shrinkWrap: true,
                                                                    physics: NeverScrollableScrollPhysics(),
                                                                    itemCount: _roomController.pendingWeeklyTasksList.length,
                                                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                                        crossAxisCount: 2,
                                                                        childAspectRatio: 2.8,
                                                                        crossAxisSpacing: 4.0,
                                                                        mainAxisSpacing: 0.0),
                                                                    onReorder:(int oldIndex, int newIndex) {
                                                                      setState(() {
                                                                        if (newIndex > oldIndex) {
                                                                          newIndex -= 1;
                                                                        }
                                                                        final TasksModel item = _roomController.pendingWeeklyTasksList.removeAt(oldIndex);
                                                                        _roomController.pendingWeeklyTasksList.insert(newIndex, item);
                                                                        if(oldIndex>newIndex){
                                                                          _roomController.swapTasks(_roomController.pendingWeeklyTasksList[newIndex].id, _roomController.pendingWeeklyTasksList[newIndex+1].id);
                                                                        }else{
                                                                          _roomController.swapTasks(_roomController.pendingWeeklyTasksList[newIndex].id, _roomController.pendingWeeklyTasksList[newIndex-1].id);
                                                                        }
                                                                      });
                                                                    },
                                                                    itemBuilder: (BuildContext context, int index) {
                                                                      // String isoTimestamp = _roomController.pendingWeeklyTasksList[index].createdAt.toString();
                                                                      // DateTime dateTime = DateTime.parse(isoTimestamp);
                                                                      // String formattedDate = DateFormat('EEE, d MMMM yyyy h:mm a').format(dateTime);
                                                                      return GestureDetector(
                                                                        key: ValueKey( _roomController.pendingWeeklyTasksList[index]),
                                                                        child: TaskTile(
                                                                          createdAt:_roomController.pendingWeeklyTasksList[index].lastCompletedDateTime!=null?'Last Completed: ': "Created At: ",
                                                                          dateTime: _roomController.updateDateTime(_roomController.pendingWeeklyTasksList[index].createdAt.toString()),
                                                                          task: Task(name: _roomController.pendingWeeklyTasksList[index].name, lastCompleted: DateTime(2024, 6, 7, 9, 40), status: 'Ongoing'),
                                                                          isCompletedSection: false,
                                                                          isEdit: true,
                                                                          onTapEdit: (){
                                                                            _roomController.updateTaskDurability("Daily",'1');
                                                                            taskController.text=_roomController.pendingWeeklyTasksList[index].name;
                                                                            customDialogNewTask(context, "Edit Task", "Save Changes", (){
                                                                              if( _roomController.createTaskKey.currentState!.validate()){
                                                                                _roomController.editTask(taskController.text.toString(), _roomController.pendingWeeklyTasksList[index].roomId.toString(), _roomController.taskValue.toString(),  _roomController.pendingWeeklyTasksList[index].id.toString());
                                                                              }
                                                                              // print("save");
                                                                              //
                                                                              // Get.off(()=> RoomScreen(initialTitle: ""));
                                                                            },taskController,FocusNode());
                                                                          },
                                                                          onTapRemove: (){
                                                                            showCustomDialog(context, "assets/images/popup/ask.png", "Are You Sure?", "Are you sure that you want to remove this task from the list?", "Yes, Remove", (){
                                                                              _roomController.deleteTask(_roomController.pendingWeeklyTasksList[index].id.toString());
                                                                              print("Delete taskt");
                                                                              // Get.back();
                                                                            }, null);
                                                                          },
                                                                          // onChanged: (value) async {
                                                                          //   if(value)
                                                                          //   {
                                                                          //     await showConfirmationDialog(value,_roomController.pendingWeeklyTasksList[index].id.toString(),_roomController.pendingWeeklyTasksList[index].status.toString());
                                                                          //   }
                                                                          // },
                                                                          onTapChangeStatus: (){
                                                                            showConfirmationDialogForPendingStatus(true,_roomController.pendingWeeklyTasksList[index].id.toString(),_roomController.pendingWeeklyTasksList[index].status.toString());

                                                                          },
                                                                        ),
                                                                      );
                                                                    }),
                                                              ),
                                                              Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  _roomController.pendingMonthlyTasksList.isEmpty?Column(
                                                                    children: [
                                                                      Align(
                                                                          alignment:Alignment.centerLeft,
                                                                          child: Text("Monthly Tasks", style: headingMedium)),
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(top:50,bottom:30),

                                                                        child: Align(
                                                                            alignment:Alignment.center,
                                                                            child: Text("No monthly tasks yet", style: subHeading)),
                                                                      ),
                                                                    ],
                                                                  )  :Text("Monthly Tasks", style: headingMedium),
                                                                  // Text("Monthly Tasks", style: headingMedium),
                                                                  SizedBox(height: 10),
                                                                  SizedBox(
                                                                    // height: weeklyTasks.length%2 == 0? (weeklyTasks.length/2) * 180 : (weeklyTasks.length/2).ceil()*180,
                                                                    child:_authController.isAdminView==false?GridView.builder(
                                                                        shrinkWrap: true,
                                                                        physics: NeverScrollableScrollPhysics(),
                                                                        itemCount: _roomController.pendingMonthlyTasksList.length,
                                                                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                                            crossAxisCount: 2,
                                                                            childAspectRatio: 2.8,
                                                                            crossAxisSpacing: 4.0,
                                                                            mainAxisSpacing: 0.0),

                                                                        itemBuilder: (BuildContext context, int index) {
                                                                          return GestureDetector(
                                                                            child: TaskTile(
                                                                              createdAt:_roomController.pendingMonthlyTasksList[index].lastCompletedDateTime!=null?'Last Completed: ': "Created At: ",
                                                                              dateTime: _roomController.updateDateTime(_roomController.pendingMonthlyTasksList[index].createdAt.toString()),
                                                                              task: Task(name: _roomController.pendingMonthlyTasksList[index].name, lastCompleted: DateTime(2024, 6, 7, 9, 40), status: 'Ongoing'),
                                                                              isCompletedSection: false,
                                                                              isEdit: true,
                                                                              onTapEdit: (){
                                                                                _roomController.updateTaskDurability("Daily",'1');
                                                                                taskController.text=_roomController.pendingMonthlyTasksList[index].name;
                                                                                customDialogNewTask(context, "Edit Task", "Save Changes", (){
                                                                                  if( _roomController.createTaskKey.currentState!.validate()){
                                                                                    _roomController.editTask(taskController.text.toString(), _roomController.pendingMonthlyTasksList[index].roomId.toString(), _roomController.taskValue.toString(),  _roomController.pendingMonthlyTasksList[index].id.toString());
                                                                                  }
                                                                                  // print("save");
                                                                                  // Get.back();
                                                                                  // Get.off(()=> RoomScreen(initialTitle: ""));
                                                                                },taskController,FocusNode());
                                                                              },
                                                                              onTapRemove: (){
                                                                                showCustomDialog(context, "assets/images/popup/ask.png", "Are You Sure?", "Are you sure that you want to remove this task from the list?", "Yes, Remove", (){
                                                                                  _roomController.deleteTask(_roomController.pendingMonthlyTasksList[index].id.toString());
                                                                                  print("Delete taskt");
                                                                                  // Get.back();
                                                                                }, null);
                                                                              },
                                                                              // onChanged: (value) async {
                                                                              //   if(value)
                                                                              //   {
                                                                              //     await showConfirmationDialog(value,_roomController.pendingMonthlyTasksList[index].id.toString(),_roomController.pendingMonthlyTasksList[index].status.toString());
                                                                              //   }
                                                                              // },
                                                                              onTapChangeStatus: (){
                                                                                showConfirmationDialogForPendingStatus(true,_roomController.pendingMonthlyTasksList[index].id.toString(),_roomController.pendingMonthlyTasksList[index].status.toString());

                                                                              },
                                                                            ),
                                                                          );
                                                                        }): ReorderableGridView.builder(
                                                                      shrinkWrap: true,
                                                                        physics: NeverScrollableScrollPhysics(),
                                                                        itemCount: _roomController.pendingMonthlyTasksList.length,
                                                                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                                            crossAxisCount: 2,
                                                                            childAspectRatio: 2.8,
                                                                            crossAxisSpacing: 4.0,
                                                                            mainAxisSpacing: 0.0),
                                                                        onReorder:(int oldIndex, int newIndex) {
                                                                          setState(() {
                                                                            if (newIndex > oldIndex) {
                                                                              newIndex -= 1;
                                                                            }
                                                                            final TasksModel item = _roomController.pendingMonthlyTasksList.removeAt(oldIndex);
                                                                            _roomController.pendingMonthlyTasksList.insert(newIndex, item);
                                                                            if(oldIndex>newIndex){
                                                                              _roomController.swapTasks(_roomController.pendingMonthlyTasksList[newIndex].id, _roomController.pendingMonthlyTasksList[newIndex+1].id);
                                                                            }else{
                                                                              _roomController.swapTasks(_roomController.pendingMonthlyTasksList[newIndex].id, _roomController.pendingMonthlyTasksList[newIndex-1].id);
                                                                            }
                                                                          });
                                                                        },
                                                                        itemBuilder: (BuildContext context, int index) {
                                                                          return GestureDetector(
                                                                            key: ValueKey( _roomController.pendingMonthlyTasksList[index]),
                                                                            child: TaskTile(
                                                                              createdAt:_roomController.pendingMonthlyTasksList[index].lastCompletedDateTime!=null?'Last Completed: ': "Created At: ",
                                                                              dateTime: _roomController.updateDateTime(_roomController.pendingMonthlyTasksList[index].createdAt.toString()),
                                                                              task: Task(name: _roomController.pendingMonthlyTasksList[index].name, lastCompleted: DateTime(2024, 6, 7, 9, 40), status: 'Ongoing'),
                                                                              isCompletedSection: false,
                                                                              isEdit: true,
                                                                              onTapEdit: (){
                                                                                _roomController.updateTaskDurability("Daily",'1');
                                                                                taskController.text=_roomController.pendingMonthlyTasksList[index].name;
                                                                                customDialogNewTask(context, "Edit Task", "Save Changes", (){
                                                                                  if( _roomController.createTaskKey.currentState!.validate()){
                                                                                    _roomController.editTask(taskController.text.toString(), _roomController.pendingMonthlyTasksList[index].roomId.toString(), _roomController.taskValue.toString(),  _roomController.pendingMonthlyTasksList[index].id.toString());
                                                                                  }
                                                                                  // print("save");
                                                                                  // Get.back();
                                                                                  // Get.off(()=> RoomScreen(initialTitle: ""));
                                                                                },taskController,FocusNode());
                                                                              },
                                                                              onTapRemove: (){
                                                                                showCustomDialog(context, "assets/images/popup/ask.png", "Are You Sure?", "Are you sure that you want to remove this task from the list?", "Yes, Remove", (){
                                                                                  _roomController.deleteTask(_roomController.pendingMonthlyTasksList[index].id.toString());
                                                                                  print("Delete taskt");
                                                                                  // Get.back();
                                                                                }, null);
                                                                              },
                                                                              // onChanged: (value) async {
                                                                              //   if(value)
                                                                              //   {
                                                                              //     await showConfirmationDialog(value,_roomController.pendingMonthlyTasksList[index].id.toString(),_roomController.pendingMonthlyTasksList[index].status.toString());
                                                                              //   }
                                                                              // },
                                                                              onTapChangeStatus: (){
                                                                                showConfirmationDialogForPendingStatus(true,_roomController.pendingMonthlyTasksList[index].id.toString(),_roomController.pendingMonthlyTasksList[index].status.toString());

                                                                              },
                                                                            ),
                                                                          );
                                                                        }),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(height: 10),
                                                            ],
                                                          )
                                                          // taskGridView(
                                                          //     "Weekly Tasks",
                                                          //     weeklyTasks),
                                                          // taskGridView(
                                                          //     "Monthly Tasks",
                                                          //     monthlyTasks),
                                                        ],
                                                                                                          ),
                                                      ),
                                                    )) : isPortrait && widget.isNewCreated == false?
                                            // pending tasks
                                            Expanded(
                                              child: Scrollbar(
                                                  controller: _scrollControllerForPendingTasks,
                                                thumbVisibility: true,
                                                thickness: 6,
                                                interactive: true,
                                                trackVisibility: true,
                                                scrollbarOrientation:
                                                ScrollbarOrientation.right,
                                                child: Padding(
                                                  padding: const EdgeInsets.only(right:10),                                                  child: ListView(
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            // idr updat kro
                                                            // _roomController.pendingDailyTasksList.isEmpty?Text("No daily tasks yet", style: subHeading) :Text("Daily Tasks", style: headingMedium),
                                                            // SizedBox(height: 10),
                                                            _roomController.pendingDailyTasksList.isEmpty?Column(
                                                              children: [
                                                                Align(
                                                                    alignment:Alignment.centerLeft,
                                                                    child: Text("Daily Tasks", style: headingMedium)),
                                                                Padding(
                                                                  padding: EdgeInsets.only(top:isPortrait?100:50,bottom:isPortrait?70:30),

                                                                  child: Align(
                                                                      alignment:Alignment.center,
                                                                      child: Text("No daily tasks yet", style: subHeading)),
                                                                ),
                                                              ],
                                                            ) :Text("Daily Tasks", style: headingMedium),
                                                            SizedBox(height: 8),
                                                            ReorderableListView.builder(
                                                                buildDefaultDragHandles:_authController.isAdminView==false? false:true,

                                                              physics: ScrollPhysics(),
                                                              shrinkWrap: true,
                                                              itemCount: _roomController.pendingDailyTasksList.length,
                                                              onReorder: (int oldIndex, int newIndex) {
                                                                _authController.isAdminView==false;
                                                                setState(() {
                                                                  if (newIndex > oldIndex) {
                                                                    newIndex -= 1;
                                                                  }
                                                                  final TasksModel item = _roomController.pendingDailyTasksList.removeAt(oldIndex);
                                                                  _roomController.pendingDailyTasksList.insert(newIndex, item);
                                                                  if(oldIndex>newIndex){
                                                                    _roomController.swapTasks(_roomController.pendingDailyTasksList[newIndex].id, _roomController.pendingDailyTasksList[newIndex+1].id);
                                                                  }else{
                                                                    _roomController.swapTasks(_roomController.pendingDailyTasksList[newIndex].id, _roomController.pendingDailyTasksList[newIndex-1].id);
                                                                  }
                                                                });
                                                              },
                                                              itemBuilder:(context,index){
                                                                return GestureDetector(
                                                                  key: ValueKey( _roomController.pendingDailyTasksList[index]),
                                                                  child: TaskTile(
                                                                    createdAt:_roomController.pendingDailyTasksList[index].lastCompletedDateTime!=null?'Last Completed: ': "Created At: ",
                                                                    dateTime: _roomController.updateDateTime(_roomController.pendingDailyTasksList[index].createdAt.toString()),
                                                                    task: Task(name: _roomController.pendingDailyTasksList[index].name, lastCompleted: DateTime(2024, 6, 7, 9, 40), status: 'Ongoing'),
                                                                    isCompletedSection: false,
                                                                    isEdit: true,
                                                                    onTapEdit: (){
                                                                      _roomController.updateTaskDurability("Daily",'1');
                                                                      taskController.text=_roomController.pendingDailyTasksList[index].name;

                                                                      customDialogNewTask(context, "Edit Task", "Save Changes", (){
                                                                        _roomController.editTask(taskController.text.toString(), _roomController.pendingDailyTasksList[index].roomId.toString(), _roomController.taskValue.toString(),  _roomController.pendingDailyTasksList[index].id.toString());

                                                                        // print("save");
                                                                        // Get.back();
                                                                        // Get.off(()=> RoomScreen(initialTitle: ""));
                                                                      },taskController,FocusNode());
                                                                    },
                                                                    onTapRemove: (){
                                                                      showCustomDialog(context, "assets/images/popup/ask.png", "Are You Sure?", "Are you sure that you want to remove this task from the list?", "Yes, Remove", (){
                                                                          Get.back();
                                                                          _roomController.deleteTask(_roomController.pendingDailyTasksList[index].id.toString());

                                                                          print("Delete taskt");
                                                                        // Get.back();
                                                                      }, null);
                                                                    },
                                                                    // onChanged: (value) async {
                                                                    //   if(value)
                                                                    //   {
                                                                    //     await showConfirmationDialog(value,_roomController.pendingDailyTasksList[index].id.toString(),_roomController.pendingDailyTasksList[index].status.toString());
                                                                    //
                                                                    //     // await showConfirmationDialog(value,_roomController.completedMonthlyTasksList[index].id.toString(),_roomController.completedMonthlyTasksList[index].status.toString());
                                                                    //   }
                                                                    // },
                                                                    onTapChangeStatus: (){
                                                                      showConfirmationDialogForPendingStatus(true,_roomController.pendingDailyTasksList[index].id.toString(),_roomController.pendingDailyTasksList[index].status.toString());

                                                                    },
                                                                  ),
                                                                );
                                                              } ,

                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            // _roomController.pendingWeeklyTasksList.isEmpty?Text("No weekly tasks yet", style: headingMedium) :Text("Weekly Tasks", style: headingMedium),

                                                            // Text("Weekly Tasks", style: headingMedium),
                                                            _roomController.pendingWeeklyTasksList.isEmpty?Column(
                                                              children: [
                                                                Align(
                                                                    alignment:Alignment.centerLeft,
                                                                    child: Text("Weekly Tasks", style: headingMedium)),
                                                                Padding(
                                                                  padding: EdgeInsets.only(top:isPortrait?100:50,bottom:isPortrait?70:30),

                                                                  child: Align(
                                                                      alignment:Alignment.center,
                                                                      child: Text("No weekly tasks yet", style: subHeading)),
                                                                ),
                                                              ],
                                                            ) :Text("Weekly Tasks", style: headingMedium),
                                                            SizedBox(height: 8),
                                                            ReorderableListView.builder(
                                                                buildDefaultDragHandles:_authController.isAdminView==false? false:true,

                                                              physics: ScrollPhysics(),
                                                              shrinkWrap: true,
                                                              itemCount: _roomController.pendingWeeklyTasksList.length,
                                                              onReorder: (int oldIndex, int newIndex) {
                                                                setState(() {
                                                                  if (newIndex > oldIndex) {
                                                                    newIndex -= 1;
                                                                  }
                                                                  final TasksModel item = _roomController.pendingWeeklyTasksList.removeAt(oldIndex);
                                                                  _roomController.pendingWeeklyTasksList.insert(newIndex, item);
                                                                  if(oldIndex>newIndex){
                                                                    _roomController.swapTasks(_roomController.pendingWeeklyTasksList[newIndex].id, _roomController.pendingWeeklyTasksList[newIndex+1].id);
                                                                  }else{
                                                                    _roomController.swapTasks(_roomController.pendingWeeklyTasksList[newIndex].id, _roomController.pendingWeeklyTasksList[newIndex-1].id);
                                                                  }
                                                                });
                                                              },
                                                              itemBuilder:(context,index){
                                                                return GestureDetector(
                                                                  key: ValueKey( _roomController.pendingWeeklyTasksList[index]),
                                                                  child: TaskTile(
                                                                    createdAt:_roomController.pendingWeeklyTasksList[index].lastCompletedDateTime!=null?'Last Completed: ': "Created At: ",
                                                                    dateTime: _roomController.updateDateTime(_roomController.pendingWeeklyTasksList[index].createdAt.toString()),
                                                                    task: Task(name: _roomController.pendingWeeklyTasksList[index].name, lastCompleted: DateTime(2024, 6, 7, 9, 40), status: 'Ongoing'),
                                                                    isCompletedSection: false,
                                                                    isEdit: true,
                                                                    onTapEdit: (){
                                                                      _roomController.updateTaskDurability("Daily",'1');
                                                                      taskController.text=_roomController.pendingWeeklyTasksList[index].name;
                                                                      customDialogNewTask(context, "Edit Task", "Save Changes", (){
                                                                        print("Save asdas");

                                                                        _roomController.editTask(taskController.text.toString(), _roomController.pendingWeeklyTasksList[index].roomId.toString(), _roomController.taskValue.toString(),  _roomController.pendingWeeklyTasksList[index].id.toString());

                                                                        // Get.back();
                                                                        // Get.off(()=> RoomScreen(initialTitle: ""));
                                                                      },taskController,FocusNode());
                                                                    },
                                                                    onTapRemove: (){
                                                                      showCustomDialog(context, "assets/images/popup/ask.png", "Are You Sure?", "Are you sure that you want to remove this task from the list?", "Yes, Remove", (){
                                                                        _roomController.deleteTask(_roomController.pendingWeeklyTasksList[index].id.toString());

                                                                        // Get.back();
                                                                      }, null);
                                                                    },
                                                                    // onChanged: (value) async {
                                                                    //   if(value)
                                                                    //   {
                                                                    //     await showConfirmationDialog(value,_roomController.pendingDailyTasksList[index].id.toString(),_roomController.pendingDailyTasksList[index].status.toString());
                                                                    //
                                                                    //     // await showConfirmationDialog(value,_roomController.completedMonthlyTasksList[index].id.toString(),_roomController.completedMonthlyTasksList[index].status.toString());
                                                                    //   }
                                                                    // },
                                                                    onTapChangeStatus: (){
                                                                      showConfirmationDialogForPendingStatus(true,_roomController.pendingWeeklyTasksList[index].id.toString(),_roomController.pendingWeeklyTasksList[index].status.toString());

                                                                    },
                                                                  ),
                                                                );
                                                              } ,

                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            // _roomController.pendingMonthlyTasksList.isEmpty?Text("No monthly tasks yet", style: headingMedium) :Text("Monthly Tasks", style: headingMedium),
                                                            _roomController.pendingMonthlyTasksList.isEmpty?Column(
                                                              children: [
                                                                Align(
                                                                    alignment:Alignment.centerLeft,
                                                                    child: Text("Monthly Tasks", style: headingMedium)),
                                                                Padding(
                                                                  padding: EdgeInsets.only(top:isPortrait?100:50,bottom:isPortrait?70:30),

                                                                  child: Align(
                                                                      alignment:Alignment.center,
                                                                      child: Text("No monthly tasks yet", style: subHeading)),
                                                                ),
                                                              ],
                                                            ) :Text("Monthly Tasks", style: headingMedium),
                                                            // Text("Monthly Tasks", style: headingMedium),
                                                            SizedBox(height: 8),
                                                            ReorderableListView.builder(
                                                                buildDefaultDragHandles:_authController.isAdminView==false? false:true,

                                                              physics: ScrollPhysics(),
                                                              shrinkWrap: true,
                                                              itemCount: _roomController.pendingMonthlyTasksList.length,
                                                              onReorder: (int oldIndex, int newIndex) {
                                                                setState(() {
                                                                  if (newIndex > oldIndex) {
                                                                    newIndex -= 1;
                                                                  }
                                                                  final TasksModel item = _roomController.pendingMonthlyTasksList.removeAt(oldIndex);
                                                                  _roomController.pendingMonthlyTasksList.insert(newIndex, item);
                                                                  if(oldIndex>newIndex){
                                                                    _roomController.swapTasks(_roomController.pendingMonthlyTasksList[newIndex].id, _roomController.pendingMonthlyTasksList[newIndex+1].id);
                                                                  }else{
                                                                    _roomController.swapTasks(_roomController.pendingMonthlyTasksList[newIndex].id, _roomController.pendingMonthlyTasksList[newIndex-1].id);
                                                                  }
                                                                });
                                                              },
                                                              itemBuilder:(context,index){
                                                                return GestureDetector(
                                                                  key: ValueKey( _roomController.pendingMonthlyTasksList[index]),
                                                                  child: TaskTile(
                                                                    createdAt:_roomController.pendingMonthlyTasksList[index].lastCompletedDateTime!=null?'Last Completed: ': "Created At: ",
                                                                    dateTime: _roomController.updateDateTime(_roomController.pendingMonthlyTasksList[index].createdAt.toString()),
                                                                    task: Task(name: _roomController.pendingMonthlyTasksList[index].name, lastCompleted: DateTime(2024, 6, 7, 9, 40), status: 'Ongoing'),
                                                                    isCompletedSection: false,
                                                                    isEdit: true,
                                                                    onTapEdit: (){
                                                                      _roomController.updateTaskDurability("Daily",'1');
                                                                      taskController.text=_roomController.pendingMonthlyTasksList[index].name;
                                                                      customDialogNewTask(context, "Edit Task", "Save Changes", (){
                                                                        _roomController.editTask(taskController.text.toString(), _roomController.pendingMonthlyTasksList[index].roomId.toString(), _roomController.taskValue.toString(),  _roomController.pendingMonthlyTasksList[index].id.toString());

                                                                        // Get.back();
                                                                        // Get.off(()=> RoomScreen(initialTitle: ""));
                                                                      },taskController,FocusNode());
                                                                    },
                                                                    onTapRemove: (){
                                                                      showCustomDialog(context, "assets/images/popup/ask.png", "Are You Sure?", "Are you sure that you want to remove this task from the list?", "Yes, Remove", (){
                                                                        _roomController.deleteTask(_roomController.pendingMonthlyTasksList[index].id.toString());

                                                                        // Get.back();
                                                                      }, null);
                                                                    },
                                                                    // onChanged: (value) async {
                                                                    //   if(value)
                                                                    //   {
                                                                    //     await showConfirmationDialog(value,_roomController.pendingMonthlyTasksList[index].id.toString(),_roomController.pendingDailyTasksList[index].status.toString());
                                                                    //
                                                                    //     // await showConfirmationDialog(value,_roomController.completedMonthlyTasksList[index].id.toString(),_roomController.completedMonthlyTasksList[index].status.toString());
                                                                    //   }
                                                                    // },
                                                                    onTapChangeStatus: (){
                                                                      showConfirmationDialogForPendingStatus(true,_roomController.pendingMonthlyTasksList[index].id.toString(),_roomController.pendingMonthlyTasksList[index].status.toString());

                                                                    },

                                                                  ),
                                                                );
                                                              } ,

                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      // TaskSection(
                                                      //   title: 'Monthly Tasks',
                                                      //   tasks: monthlyTasks,
                                                      //   isCompleted: false,
                                                      //   isEdit: widget.isEditRoom,
                                                      // ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                                : Spacer(),
                                            // Container(
                                            //   height: 200,
                                            //   color: Colors.orange[50],
                                            //   child: Center(child: Text('No Pending Tasks')),
                                            // ),
                                            widget.isNewCreated ||
                                                    widget.isEditRoom
                                                ?_authController.isAdminView==true?isPortrait?Container(): Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      // ls create new task
                                                      Expanded(
                                                          child: CustomButton(
                                                        onTap: () {
                                                          taskController.clear();
                                                          _roomController.updateTaskDurability("Daily",'1');
                                                          customDialogNewTask(
                                                            context,
                                                            "Create New Task",
                                                            "Create",
                                                            () {
                                                              if(_roomController.createTaskKey.currentState!.validate()){
                                                                _roomController.createTask(taskController.text.toString(), widget.roomId.toString(), _roomController.taskValue.toString());
                                                                print(taskController.text.toString());
                                                              }

                                                            },taskController,
                                                            _focusNode
                                                          );
                                                        },
                                                        buttonText:
                                                            "Create New Task",
                                                      )),
                                                      Expanded(
                                                          child: Padding(
                                                              padding: const EdgeInsets.only(right:12,left:12),
                                                              child: CustomButton(
                                                                onTap: () {
                                                                  _authController.updateIsAdminView(false);
                                                                  _authPreference.setStaffView('1');
                                                                  KeepScreenOn.turnOn();
                                                                }, buttonText: "Staff Mode",
                                                              )
                                                          )),
                                                      // SizedBox(
                                                      //   width: isPortrait
                                                      //       ? 2.w
                                                      //       : 45.w,
                                                      // ),
                                                      Expanded(
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(right:12),
                                                            child: CustomButton(
                                                              onTap: () {

                                                                _generalController.updateDateForRoom("");
                                                                _roomController.updateDateAfterFiltering('');
                                                            _authPreference.setStaffView('0');
                                                            _authController.updateIsAdminView(true);
                                                            // Get.back();
                                                            Get.offAll(()=> HomeScreen());
                                                            }, buttonText: "Go to Dashboard",
                                                            )
                                                          )),
                                                    ],
                                                  ):Row(
                                                mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Container(),
                                                      // Container(
                                                      //   height:80, width:200,
                                                      //     child: CustomButton(
                                                      // onTap: () {
                                                      //   customDialogEnterCredentials(
                                                      //     context,
                                                      //     "Enter your Credential to access Dashboard",
                                                      //     "Log In",
                                                      //     true, () {},_adminEmailController,_adminPasswordController,()async{
                                                      //       if(_roomController.adminKey.currentState!.validate()){
                                                      //         await _authController.loginUserForAdminAccess(_adminEmailController.text.toString(), _adminPasswordController.text.toString());
                                                      //         _adminEmailController.clear();
                                                      //         _adminPasswordController.clear();
                                                      //       }
                                                      //
                                                      //   }
                                                      //   );
                                                      // },
                                                      // buttonText: "Exit",
                                                      //     )),
                                                      Container(),
                                                    ],
                                                  )
                                                : SizedBox.shrink(),
                                            SizedBox(
                                              height: 20,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                     
                                      width:isPortrait?50.w: 56.w,
                                      child: Container(
                                        padding: EdgeInsets.only(left: 18,top:10,bottom:10,right:5),

                                        decoration: BoxDecoration(
                                            color: Color(0xfff5f5f5),
                                            border: Border(
                                                top: BorderSide(
                                                    color: Colors.black12))),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.circle,
                                                  color: Colors.green,
                                                  size: 14,
                                                ),
                                                SizedBox(
                                                  width: 6,
                                                ),
                                                Text(
                                                  "Completed Tasks",
                                                  style: headingSmall,
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            widget.isNewCreated == false
                                                // completed tasks
                                                ? Expanded(
                                                    child: Scrollbar(
                                                      controller: _scrollControllerForCompletedTasks,
                                                      thumbVisibility: true,
                                                      thickness: 6,
                                                      interactive: true,
                                                      trackVisibility: true,
                                                      scrollbarOrientation:
                                                      ScrollbarOrientation.right,
                                                      // hoverThickness: 15,
                                                      radius: const Radius.circular(0),
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(right:10),
                                                        child: ListView(
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  // Text("Daily Tasks", style: headingMedium),
                                                                  _roomController.completedDailyTasksList.isEmpty?Column(
                                                                    children: [
                                                                      Align(
                                                                          alignment:Alignment.centerLeft,
                                                                          child: Text("Daily Tasks", style: headingMedium)),
                                                                      Padding(
                                                                        padding: EdgeInsets.only(top:isPortrait?100:50,bottom:isPortrait?70:30),

                                                                        child: Align(
                                                                            alignment:Alignment.center,
                                                                            child: Text("No daily tasks yet", style: subHeading)),
                                                                      ),
                                                                    ],
                                                                  )  :Text("Daily Tasks", style: headingMedium),

                                                                  SizedBox(height: 8),
                                                                  ReorderableListView.builder(
                                                                      buildDefaultDragHandles:_authController.isAdminView==false? false:true,

                                                                  physics: ScrollPhysics(),
                                                                    shrinkWrap: true,
                                                                    itemCount: _roomController.completedDailyTasksList.length,
                                                                    onReorder: (int oldIndex, int newIndex) {
                                                                      setState(() {
                                                                        if (newIndex > oldIndex) {
                                                                          newIndex -= 1;
                                                                        }
                                                                        final TasksModel item = _roomController.completedDailyTasksList.removeAt(oldIndex);
                                                                        _roomController.completedDailyTasksList.insert(newIndex, item);
                                                                        if(oldIndex>newIndex){
                                                                          _roomController.swapTasks(_roomController.completedDailyTasksList[newIndex].id, _roomController.completedDailyTasksList[newIndex+1].id);
                                                                        }else{
                                                                          _roomController.swapTasks(_roomController.completedDailyTasksList[newIndex].id, _roomController.completedDailyTasksList[newIndex-1].id);
                                                                        }
                                                                      });
                                                                    },
                                                                    itemBuilder:(context,index){
                                                                      return GestureDetector(
                                                                        key: ValueKey( _roomController.completedDailyTasksList[index]),

                                                                        child: TaskTile(
                                                                          completeBy: _roomController.completedDailyTasksList[index].member,
                                                                          dateTime:isPortrait? '\n'+_roomController.updateDateTime(_roomController.completedDailyTasksList[index].updatedAt.toString()):_roomController.updateDateTime(_roomController.completedDailyTasksList[index].updatedAt.toString()),
                                                                          task: Task(name: _roomController.completedDailyTasksList[index].name, lastCompleted: DateTime(2024, 6, 7, 9, 40), status: 'Ongoing'),
                                                                          isCompletedSection: true,
                                                                          isEdit: true,
                                                                          // onChanged: (value) async {
                                                                          //   // if(value)
                                                                          //   // {
                                                                          //     await showConfirmationDialog(value,_roomController.completedDailyTasksList[index].id.toString(),_roomController.completedDailyTasksList[index].status.toString());
                                                                          //   // }
                                                                          // },
                                                                          onTapChangeStatus: (){
                                                                            // print(taskStatus.toString());
                                                                            // print(_authController.isAdminView);
                                                                            // if(_roomController.completedDailyTasksList[index].status.toString()=='0'){
                                                                            //   _roomController.changeTaskStatus(_roomController.completedDailyTasksList[index].id.toString(), _roomController.completedDailyTasksList[index].status.toString()=='0'?'1':'0', memberController.text.toString());
                                                                            //   Get.back();
                                                                            //
                                                                            // }
                                                                            if(_roomController.completedDailyTasksList[index].status.toString()=='1'&&_authController.isAdminView==false){
                                                                              Get.back();
                                                                              // Future.delayed(Duration(seconds: 1), () {
                                                                              //   Get.snackbar(
                                                                              //     'Task Status',
                                                                              //     'Completed Task\'s status can only be changed by admin',
                                                                              //     snackPosition: SnackPosition.TOP,
                                                                              //     backgroundColor: Color(0xffF7941D), // Background color
                                                                              //     colorText: Colors.black, // Text color for better visibility
                                                                              //   );
                                                                              // });
                                                                            }else if((_roomController.completedDailyTasksList[index].status.toString()=='1'&&_authController.isAdminView==true)){
                                                                              showCustomDialog(context, "assets/images/popup/ask.png", "Are You Sure?", "Are you sure that you want to change this task's status?", "Yes",
                                                                                      (){
                                                                                    _roomController.changeTaskStatus(_roomController.completedDailyTasksList[index].id.toString(), _roomController.completedDailyTasksList[index].status.toString()=='0'?'1':'0', "Admin").whenComplete((){
                                                                                      _roomController.completedDailyTasksList.removeAt(index);
                                                                                      setState(() {

                                                                                      });
                                                                                    });
                                                                                    Get.back();
                                                                                  }, null);

                                                                            }
                                                                            // showCustomDialog(context, "assets/images/popup/ask.png", "Are You Sure?", "Are you sure that you want to change this task's status?", "Yes",
                                                                            //         (){
                                                                            //
                                                                            //         }, null);
                                                                            //  showConfirmationDialogForPendingStatus(true,_roomController.completedDailyTasksList[index].id.toString(),_roomController.completedDailyTasksList[index].status.toString());
                                                                            //
                                                                            // showConfirmationDialogForPendingStatus(true,_roomController.completedDailyTasksList[index].id.toString(),_roomController.completedDailyTasksList[index].status.toString());

                                                                          },
                                                                          onTapRemoveCompletedTasks: (){
                                                                            showCustomDialog(context, "assets/images/popup/ask.png", "Are You Sure?", "Are you sure that you want to remove this task from the list?", "Yes, Remove", (){
                                                                              // _roomController.deleteTask("32");
                                                                              _roomController.deleteTask(_roomController.completedDailyTasksList[index].id.toString());
                                                                              Get.back();
                                                                            }, null);
                                                                          },
                                                                        ),
                                                                      );
                                                                    } ,

                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  // Text("Weekly Tasks", style: headingMedium),
                                                                  _roomController.completedWeeklyTasksList.isEmpty?Column(
                                                                    children: [
                                                                      Align(
                                                                          alignment:Alignment.centerLeft,
                                                                          child: Text("Weekly Tasks", style: headingMedium)),
                                                                      Padding(
                                                                        padding: EdgeInsets.only(top:isPortrait?100:50,bottom:isPortrait?70:30),

                                                                        child: Align(
                                                                            alignment:Alignment.center,
                                                                            child: Text("No weekly tasks yet", style: subHeading)),
                                                                      ),
                                                                    ],
                                                                  ) :Text("Weekly Tasks", style: headingMedium),

                                                                  SizedBox(height: 8),
                                                                  ReorderableListView.builder(
                                                                      buildDefaultDragHandles:_authController.isAdminView==false? false:true,

                                                                    physics: ScrollPhysics(),
                                                                    shrinkWrap: true,
                                                                    itemCount: _roomController.completedWeeklyTasksList.length,
                                                                    onReorder: (int oldIndex, int newIndex) {
                                                                      setState(() {
                                                                        if (newIndex > oldIndex) {
                                                                          newIndex -= 1;
                                                                        }
                                                                        final TasksModel item = _roomController.completedWeeklyTasksList.removeAt(oldIndex);
                                                                        _roomController.completedWeeklyTasksList.insert(newIndex, item);
                                                                        if(oldIndex>newIndex){
                                                                          _roomController.swapTasks(_roomController.completedWeeklyTasksList[newIndex].id, _roomController.completedWeeklyTasksList[newIndex+1].id);
                                                                        }else{
                                                                          _roomController.swapTasks(_roomController.completedWeeklyTasksList[newIndex].id, _roomController.completedWeeklyTasksList[newIndex-1].id);
                                                                        }
                                                                      });
                                                                    },
                                                                    itemBuilder:(context,index){
                                                                      return GestureDetector(
                                                                        key: ValueKey( _roomController.completedWeeklyTasksList[index]),
                                                                        child: TaskTile(
                                                                          completeBy: _roomController.completedWeeklyTasksList[index].member,
                                                                          dateTime:isPortrait? '\n'+ _roomController.updateDateTime(_roomController.completedWeeklyTasksList[index].updatedAt.toString()):_roomController.updateDateTime(_roomController.completedWeeklyTasksList[index].updatedAt.toString()),
                                                                          task: Task(name: _roomController.completedWeeklyTasksList[index].name, lastCompleted: DateTime(2024, 6, 7, 9, 40), status: 'Ongoing'),
                                                                          isCompletedSection: true,
                                                                          isEdit: true,
                                                                          onTapRemoveCompletedTasks: (){
                                                                            showCustomDialog(context, "assets/images/popup/ask.png", "Are You Sure?", "Are you sure that you want to remove this task from the list?", "Yes, Remove", (){
                                                                              _roomController.deleteTask(_roomController.completedWeeklyTasksList[index].id.toString());
                                                                              Get.back();
                                                                            }, null);
                                                                          },
                                                                          // onChanged: (value) async {
                                                                          //   await showConfirmationDialog(value,_roomController.completedWeeklyTasksList[index].id.toString(),_roomController.completedWeeklyTasksList[index].status.toString());
                                                                          //
                                                                          // },
                                                                          onTapChangeStatus: (){
                                                                            if(_roomController.completedWeeklyTasksList[index].status.toString()=='1'&&_authController.isAdminView==false){
                                                                              Get.back();
                                                                              // Future.delayed(Duration(seconds: 1), () {
                                                                              //   Get.snackbar(
                                                                              //     'Task Status',
                                                                              //     'Completed Task\'s status can only be changed by admin',
                                                                              //     snackPosition: SnackPosition.TOP,
                                                                              //     backgroundColor: Color(0xffF7941D), // Background color
                                                                              //     colorText: Colors.black, // Text color for better visibility
                                                                              //   );
                                                                              // });
                                                                            }else if((_roomController.completedWeeklyTasksList[index].status.toString()=='1'&&_authController.isAdminView==true)){
                                                                              showCustomDialog(context, "assets/images/popup/ask.png", "Are You Sure?", "Are you sure that you want to change this task's status?", "Yes",
                                                                                      (){
                                                                                    _roomController.changeTaskStatus(_roomController.completedWeeklyTasksList[index].id.toString(), _roomController.completedWeeklyTasksList[index].status.toString()=='0'?'1':'0', "Admin").whenComplete((){
                                                                                      _roomController.completedWeeklyTasksList.removeAt(index);
                                                                                      setState(() {

                                                                                      });
                                                                                    });
                                                                                    Get.back();
                                                                                  }, null);

                                                                            }

                                                                            // showConfirmationDialogForPendingStatus(true,_roomController.completedWeeklyTasksList[index].id.toString(),_roomController.completedWeeklyTasksList[index].status.toString());

                                                                          },
                                                                        ),
                                                                      );
                                                                    } ,

                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  // Text("Monthly Tasks", style: headingMedium),
                                                                  _roomController.completedMonthlyTasksList.isEmpty?Column(
                                                                    children: [
                                                                      Align(
                                                                          alignment:Alignment.centerLeft,
                                                                          child: Text("Monthly Tasks", style: headingMedium)),
                                                                      Padding(
                                                                        padding: EdgeInsets.only(top:isPortrait?100:50,bottom:isPortrait?70:30),

                                                                        child: Align(
                                                                            alignment:Alignment.center,
                                                                            child: Text("No monthly tasks yet", style: subHeading)),
                                                                      ),
                                                                    ],
                                                                  ) :Text("Monthly Tasks", style: headingMedium),

                                                                  SizedBox(height: 8),
                                                                  ReorderableListView.builder(
                                                                      buildDefaultDragHandles:_authController.isAdminView==false? false:true,

                                                                    physics: ScrollPhysics(),
                                                                    shrinkWrap: true,
                                                                    itemCount: _roomController.completedMonthlyTasksList.length,
                                                                    onReorder: (int oldIndex, int newIndex) {
                                                                      setState(() {
                                                                        if (newIndex > oldIndex) {
                                                                          newIndex -= 1;
                                                                        }
                                                                        final TasksModel item = _roomController.completedMonthlyTasksList.removeAt(oldIndex);
                                                                        _roomController.completedMonthlyTasksList.insert(newIndex, item);
                                                                        if(oldIndex>newIndex){
                                                                          _roomController.swapTasks(_roomController.completedMonthlyTasksList[newIndex].id, _roomController.completedMonthlyTasksList[newIndex+1].id);
                                                                        }else{
                                                                          _roomController.swapTasks(_roomController.completedMonthlyTasksList[newIndex].id, _roomController.completedMonthlyTasksList[newIndex-1].id);
                                                                        }
                                                                      });
                                                                    },
                                                                    itemBuilder:(context,index){
                                                                      // String isoTimestamp = _roomController.completedMonthlyTasksList[index].updatedAt.toString();
                                                                      // DateTime dateTime = DateTime.parse(isoTimestamp);
                                                                      // String formattedDate = DateFormat('EEE, d MMMM yyyy h:mm a').format(dateTime);
                                                                      return GestureDetector(
                                                                        key: ValueKey( _roomController.completedMonthlyTasksList[index]),

                                                                        child: TaskTile(
                                                                          completeBy: _roomController.completedMonthlyTasksList[index].member,
                                                                          dateTime:isPortrait? '\n'+  _roomController.updateDateTime(_roomController.completedMonthlyTasksList[index].updatedAt.toString()):_roomController.updateDateTime(_roomController.completedMonthlyTasksList[index].updatedAt.toString()),
                                                                          task: Task(name: _roomController.completedMonthlyTasksList[index].name, lastCompleted: DateTime(2024, 6, 7, 9, 40), status: 'Ongoing'),
                                                                          isCompletedSection: true,
                                                                          isEdit: true,
                                                                          onTapRemoveCompletedTasks: (){
                                                                            // print("object");
                                                                            showCustomDialog(context, "assets/images/popup/ask.png", "Are You Sure?", "Are you sure that you want to remove this task from the list?", "Yes, Remove", (){
                                                                              print("object");
                                                                              _roomController.deleteTask(_roomController.completedMonthlyTasksList[index].id.toString());
                                                                              // Get.back();
                                                                            }, null);
                                                                          },
                                                                          // onChanged: (value) async {
                                                                          //   await showConfirmationDialog(value,_roomController.completedMonthlyTasksList[index].id.toString(),_roomController.completedMonthlyTasksList[index].status.toString());
                                                                          //
                                                                          // },
                                                                          onTapChangeStatus: (){
                                                                            if(_roomController.completedMonthlyTasksList[index].status.toString()=='1'&&_authController.isAdminView==false){
                                                                              Get.back();
                                                                              // Future.delayed(Duration(seconds: 1), () {
                                                                              //   Get.snackbar(
                                                                              //     'Task Status',
                                                                              //     'Completed Task\'s status can only be changed by admin',
                                                                              //     snackPosition: SnackPosition.TOP,
                                                                              //     backgroundColor: Color(0xffF7941D), // Background color
                                                                              //     colorText: Colors.black, // Text color for better visibility
                                                                              //   );
                                                                              // });
                                                                            }else if((_roomController.completedMonthlyTasksList[index].status.toString()=='1'&&_authController.isAdminView==true)){
                                                                              showCustomDialog(context, "assets/images/popup/ask.png", "Are You Sure?", "Are you sure that you want to change this task's status?", "Yes",
                                                                                      (){
                                                                                    _roomController.changeTaskStatus(_roomController.completedMonthlyTasksList[index].id.toString(), _roomController.completedMonthlyTasksList[index].status.toString()=='0'?'1':'0', "Admin").whenComplete((){
                                                                                      _roomController.completedMonthlyTasksList.removeAt(index);
                                                                                      setState(() {
                                                                        
                                                                                      });
                                                                                    });
                                                                                    Get.back();
                                                                                  }, null);
                                                                        
                                                                            }
                                                                            // showConfirmationDialogForPendingStatus(true,_roomController.completedMonthlyTasksList[index].id.toString(),_roomController.completedMonthlyTasksList[index].status.toString());
                                                                        
                                                                          },
                                                                        ),
                                                                      );
                                                                    } ,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            // TaskSection(
                                                            //   title: 'Monthly Tasks',
                                                            //   tasks: monthlyTasks,
                                                            //   isCompleted: true,
                                                            //   isEdit: widget.isEditRoom,
                                                            // ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : SizedBox.shrink(),
                                            // Container(
                                            //   height: 200,
                                            //   color: Colors.green[50],
                                            //   child: Center(child: Text('No Completed Tasks')),
                                            // ),
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
           _authController.isAdminView==true?isPortrait? Padding(
             padding: const EdgeInsets.only(left:36,right:24),
             child: Row(
                mainAxisAlignment:
                MainAxisAlignment
                    .spaceBetween,
                children: [
                  // ls create new task
                  Expanded(
                      child: CustomButton(
                        onTap: () {
                          taskController.clear();
                          _roomController.updateTaskDurability("Daily",'1');
                          customDialogNewTask(
                              context,
                              "Create New Task",
                              "Create",
                                  () {
                                if(_roomController.createTaskKey.currentState!.validate()){
                                  _roomController.createTask(taskController.text.toString(), widget.roomId.toString(), _roomController.taskValue.toString());
                                  print(taskController.text.toString());
                                }
             
                              },taskController,
                              _focusNode
                          );
                        },
                        buttonText:
                        "Create New Task",
                      )),
                  Expanded(
                      child: Padding(
                          padding: const EdgeInsets.only(right:12,left:12),
                          child: CustomButton(
                            onTap: () {
                              _authController.updateIsAdminView(false);
                              _authPreference.setStaffView('1');
                              KeepScreenOn.turnOn();
                            }, buttonText: "Staff Mode",
                          )
                      )),
                  // SizedBox(
                  //   width: isPortrait
                  //       ? 2.w
                  //       : 45.w,
                  // ),
                  Expanded(
                      child: Padding(
                          padding: const EdgeInsets.only(right:12),
                          child: CustomButton(
                            onTap: () {
             
                              _generalController.updateDateForRoom("");
                              _roomController.updateDateAfterFiltering('');
                              _authPreference.setStaffView('0');
                              _authController.updateIsAdminView(true);
                              Get.offAll(()=> HomeScreen());
                            }, buttonText: "Go to Dashboard",
                          )
                      )),
                ],
              ),
           ):Container():Container(),
          ],
        ),
      ),
    );
  }

  taskGridView(String title, List<Task> tasks) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: headingMedium),
        SizedBox(height: 8),
        SizedBox(
          height: tasks.length%2 == 0? (tasks.length/2) * 180 : (tasks.length/2).ceil()*180,
          child: GridView.builder(

              physics: NeverScrollableScrollPhysics(),
              itemCount: tasks.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2.5,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0),
              itemBuilder: (BuildContext context, int index) {
                return TaskTile(
                  task: tasks[index],
                  isCompletedSection: tasks[index].isCompleted,
                  isEdit: widget.isEditRoom,
                );
              }),
        ),
      ],
    );
  }
  // Future<void> showConfirmationDialog(bool newValue,String taskId,String taskStatus,String member) async {
  //   TextEditingController memberController=TextEditingController();
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
  //                       controller: memberController,
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
  //                           if(memberController.text.toString().isEmpty){
  //                             // _roomController.changeTaskStatus(taskId, taskStatus=='0'?'1':'0', memberController.text.toString());
  //                             Get.back();
  //                           }
  //                           if(memberController.text.toString()!=member && memberController.text.toString().isNotEmpty){
  //                             Get.back();
  //                             Future.delayed(Duration(seconds: 1), () {
  //                               Get.snackbar(
  //                                 'Completed Task',
  //                                 'Task status can not be changed by you.',
  //                                 snackPosition: SnackPosition.TOP,
  //                                 backgroundColor: Color(0xffF7941D), // Background color
  //                                 colorText: Colors.black, // Text color for better visibility
  //                               );
  //                             });
  //                           }
  //                           else{
  //                             _roomController.changeTaskStatus(taskId, taskStatus=='0'?'1':'0', memberController.text.toString());
  //                             Get.back();
  //                           }
  //
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

Future<void> showConfirmationDialogForPendingStatus(bool newValue,String taskId,String taskStatus) async {
  final GlobalKey<FormState> _changeStatusKey = GlobalKey<FormState>();
  FocusNode focusNode=FocusNode();

  TextEditingController memberController=TextEditingController();
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          focusNode.requestFocus();
        });
        return BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 6,
            sigmaY: 6,
          ),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Dialog(
              insetPadding: EdgeInsets.symmetric(horizontal:  MediaQuery.of(context).orientation == Orientation.portrait? 20.w : 50.w),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              backgroundColor: Colors.white,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Form(
                  key: _changeStatusKey,
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
                            _controller.value = false;
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
                          "Enter your Name to complete Task",
                          style: headingLarge.copyWith(
                              color: Colors.black, fontSize: 22),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(
                        height: 45,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                        child: AuthTextField(
                          controller: memberController,
                          keyboardType: TextInputType.name,
                          hintText: "Enter Name",
                          validator: (value) => CustomValidator.isEmptyUserName(value),
                          focusNode: focusNode,
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
                              if(_changeStatusKey.currentState!.validate()){
                                print(taskStatus.toString());
                                print(_authController.isAdminView);
                                if(taskStatus.toString()=='0'){
                                  _roomController.changeTaskStatus(taskId, taskStatus=='0'?'1':'0', memberController.text.toString());
                                  Get.back();

                                }
                                else if(taskStatus.toString()=='1'&&_authController.isAdminView==false){
                                  Get.back();

                                }else if((taskStatus.toString()=='1'&&_authController.isAdminView==true)){
                                  _roomController.changeTaskStatus(taskId, taskStatus=='0'?'1':'0', memberController.text.toString());
                                  Get.back();
                                }
                              }


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
                                child: Text("Continue",
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
}
