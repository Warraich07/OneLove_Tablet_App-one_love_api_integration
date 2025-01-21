import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:one_love/constants/global_variables.dart';
import 'package:one_love/controllers/auth_controller.dart';
import 'package:one_love/controllers/room_controller.dart';
import 'package:one_love/views/auth/login_screen.dart';
import 'package:one_love/views/home/room_screen.dart';
import 'package:one_love/widgets/custom_widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import 'package:sizer/sizer.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../constants/custom_validators.dart';
import '../../controllers/general_controller.dart';
import '../../models/rooms_model.dart';
import '../../models/rooms_model.dart';
import '../../models/tasks_model.dart';
import '../../utils/custom_dialogbox.dart';
import '../../utils/shared_preference.dart';
import '../../widgets/custom_dialog.dart';
import '../../widgets/room_tile_widget.dart';
import '../../widgets/show_case.dart';
import '../../widgets/task_section_widget.dart';
import '../../widgets/text_form_fields.dart';
import 'notifications_detail_screen.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:cron/cron.dart' as cr;
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime? selectedDate;
  bool onboardingShownHome=false;
  final GlobalKey _showcaseKey = GlobalKey();
  List<int> items = List<int>.generate(3, (int index) => index); // List of items
  getAutoToolTip() async {
    Future.delayed(Duration(milliseconds: 10), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      onboardingShownHome = prefs.getBool('onboardingShownHome') ?? false;
      prefs.setBool('onboardingShownHome', true);

      if(!onboardingShownHome){
        WidgetsBinding.instance?.addPostFrameCallback((_) {
          ShowCaseWidget.of(context).startShowCase([_showcaseKey]);
        });
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    // Define the theme for the date picker
    final ThemeData theme = ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: AppColors.primaryColor, // Primary color for the theme
        onPrimary: Colors.white, // Color for text on primary backgrounds
        surface: Colors.white, // Background color for surfaces
        onSurface: Colors.black, // Color for text on surfaces
        onBackground: Colors.black, // Color for text on background
        onSecondary: Colors.black, // Color for secondary text
      ),
    );

    // Show the date picker dialog
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

        // Format the selected date to 'yyyy-MM-dd'
        String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate!);

        // Update room data with the formatted date
        _roomController.getFilteredRoomData(
          _roomController.roomIdentifier.value,
          'Haider',
          formattedDate,
        );

        // Format the date for display purposes
        String updatedData = DateFormat('EEE, d MMMM yyyy').format(selectedDate!);
        String todayDate = DateFormat('EEE, d MMMM yyyy').format(DateTime.now());

        // Update the general controller with the formatted date
        if (updatedData == todayDate) {
          _generalController.updateDateForHome("");
        } else {
          print(updatedData);
          _roomController.updateDateAfterFiltering(updatedData);
          _generalController.updateDateForHome(updatedData);
        }
      });
    }
  }


  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime? pickedDate = await showDatePicker(
  //     // barrierColor: Colors.indigo,
  //     context: context,
  //     initialDate: selectedDate ?? DateTime.now(),
  //     firstDate: DateTime(2000),
  //     lastDate: DateTime.now(),
  //   );
  //
  //   if (pickedDate != null && pickedDate != selectedDate) {
  //     setState(() {
  //
  //       selectedDate = pickedDate;
  //       // Format the date to 'yyyy-MM-dd'
  //       String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate!);
  //
  //             _roomController.getFilteredRoomData(_roomController.roomIdentifier.value, 'Haider', formattedDate);
  //       String updatedData = DateFormat('EEE, d MMMM yyyy').format(selectedDate!);
  //       String todayDate = DateFormat('EEE, d MMMM yyyy').format(DateTime.now());
  //       if(updatedData==todayDate){
  //         _generalController.updateDateForHome("");
  //       }else{
  //       print(updatedData);
  //       _generalController.updateDateForHome(updatedData);}
  //
  //     });
  //   }
  // }

  int selectedBoard = 0;
  // final List<String> rooms = ['Room 1', 'Room 2', 'Room 3', 'Room 4', 'Room 5'];
  int selectedRoomIndex=0;
  double _swipeOffset = 0.0;
  Map<int, double> _swipeOffsets = {};


  late ValueNotifier<bool> _controller = ValueNotifier<bool>(false);
  GeneralController _generalController=Get.find();
  AuthController _authController=Get.find();
  RoomController _roomController=Get.find();
  TextEditingController roomNameController=TextEditingController();
  TextEditingController taskController=TextEditingController();

Color unreadColor=Color(0xfff5ddbf);
Color readColor=Colors.white;
  final AuthPreference _authPreference = AuthPreference.instance;
  late RefreshController _notificationRefreshController;
  cr.Cron? cron;
  void startCronJob() {
    cron = cr.Cron();

    // Schedule the cron job to run every minute
    cron?.schedule(cr.Schedule.parse('*/1 * * * *'), () async {
      // Get the current time from _generalController.formattedDateTime.value
      String currentTime = _generalController.formattedDateTime.value;

      // Check if the time is exactly 8:10 PM
      if (currentTime.contains('12:00 AM')) {
        await _roomController.getRooms();
        print(_roomController.roomIdentifier.value+"this is home>>>>>>>>>>>>>>>");
        selectedDate=null;
        _generalController.updateDateForHome("");
        _roomController.updateDateAfterFiltering('');
        _roomController.roomIndexForSelectedRoom.value = _generalController.roomIndex.value;
        _roomController.updateRoomId(_roomController.roomsList[_generalController.roomIndex.value].id.toString());
        _roomController.getRoomData(_roomController.roomsList[_generalController.roomIndex.value].id.toString(),'Haider');
      } else {
        print("It's not 12:00 AM yet. Waiting...");
      }
    });
  }

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
  _notificationRefreshController = RefreshController(initialRefresh: false);

    // _roomController.roomsList.clear();
    _roomController.roomsCurrentPage.value=0;
    _roomController.roomsLastPage.value=0;
      _roomController.getRooms();

    _roomController.getNotificationsCount();
    _roomController.notificationsList.clear();
    _roomController.notificationsCurrentPage.value=0;
    _roomController.notificationsLastPage.value=0;
   _roomController.getNotifications();
   if(_authController.isNotificationView==true){
     selectedBoard=1;
     setState(() {

     });
   }
    startCronJob();

  }
  final ScrollController _scrollControllerForPendingTasks = ScrollController();
  final ScrollController _scrollControllerForCompletedTasks = ScrollController();


  @override
  Widget build(BuildContext context) {

    DateTime now = DateTime.now();
    String formattedDateTime = DateFormat('EEE, d MMMM, yyyy h:mm a').format(now);
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return Obx(
      ()=> Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: 80,
          elevation: 1,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset("assets/images/app_logo.png", scale: 3,),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                 ClipRRect(
                     borderRadius: BorderRadius.circular(100),
                     child: Container(
                       height: 40,
                       width: 40,
                       child: CachedNetworkImage(imageUrl: _authController.userData.value!.data.userImage.toString(),
                         placeholder: (context, url) =>
                             Center(
                                 child: CircularProgressIndicator()),
                         errorWidget: (context, url,
                             error) =>
                             Image.asset(
                                 "assets/img.png"),
                         fit: BoxFit.cover,
                       ),
                     ),
                 ),

                  SizedBox(width: 10),

                  Text(
                            "Admin",
                    // _authController.userData.value!.data.name.toString(),
                    style: headingSmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
        body:
             Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    _dashBoardPanel(),
                    selectedBoard == 0?

                    Expanded(
                      child: Row(
                        children: [
                          isPortrait?
                              SizedBox.shrink():
                          _roomsPanel(isPortrait, isData: true),
                          Expanded(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [

                                          Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment:CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Tasks Progress",
                                                    style: headingMedium,
                                                  ),
                                                  isPortrait? SizedBox(height:10):SizedBox(),
                                                  Row(
                                                      children :[
                                                        isPortrait?
                                                        SizedBox(
                                                          width: 130,
                                                          child: LinearProgressIndicator(
                                                            value: _roomController.completedTasksList.isEmpty?0: _roomController.completedTasksList.length/((_roomController.tasksList.isEmpty?0:_roomController.tasksList.length)+(_roomController.completedTasksList.isEmpty?0:_roomController.completedTasksList.length)),
                                                            backgroundColor: Colors.grey[300],
                                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                                                          ),
                                                        ):Container(),
                                                        SizedBox(width: 10,),
                                                        isPortrait?
                                                        Text(
                                                          "${_roomController.completedTasksList.isEmpty?0: _roomController.completedTasksList.length}/${(_roomController.tasksList.isEmpty?0:_roomController.tasksList.length)+(_roomController.completedTasksList.isEmpty?0:_roomController.completedTasksList.length)} Tasks completed",
                                                          style: headingSmall.copyWith(color: Colors.grey, fontSize: 13),):Container(),
                                                      ]
                                                  )
                                                ],
                                              ),

                                              SizedBox(width: 10,),
                                              isPortrait?Container():
                                              SizedBox(
                                                width: 200,
                                                child: LinearProgressIndicator(
                                                  value: _roomController.completedTasksList.isEmpty?0: _roomController.completedTasksList.length/((_roomController.tasksList.isEmpty?0:_roomController.tasksList.length)+(_roomController.completedTasksList.isEmpty?0:_roomController.completedTasksList.length)),
                                                  backgroundColor: Colors.grey[300],
                                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                                                ),
                                              ),
                                              SizedBox(width: 10,),
                                              isPortrait?Container():
                                              Text(
                                                "${_roomController.completedTasksList.isEmpty?0: _roomController.completedTasksList.length}/${(_roomController.tasksList.isEmpty?0:_roomController.tasksList.length)+(_roomController.completedTasksList.isEmpty?0:_roomController.completedTasksList.length)} Tasks completed",
                                                style: headingSmall.copyWith(color: Colors.grey, fontSize: 13),),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Obx(
                                                ()=>GestureDetector(
                                                  onTap: (){
                                                    // selectedDate=null;
                                                    _selectDate(context);
                                                  },
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                      Text(
                                                        _generalController.homeDate.isEmpty?  _generalController.formattedDateTime.value:_generalController.homeDate.value,
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
                                                      _generalController.homeDate.isEmpty?Container(): GestureDetector(
                                                        onTap: (){
                                                          selectedDate=null;
                                                          _generalController.updateDateForHome("");
                                                          _roomController.getFilteredRoomData(_roomController.roomIdentifier.value, 'Haider', "");

                                                        },
                                                        child: Container(
                                                            padding:EdgeInsets.only(top:5),
                                                          child: Text("Clear filter?",style:TextStyle(color:AppColors.primaryColor)),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                          ),

                                        ],
                                      ),
                                      // Row(
                                      //   children: [
                                      //     Obx(()=> Text(_generalController.formattedDateTime.value, style: headingSmall.copyWith(color: Colors.grey, fontSize: 13),)),
                                      //     SizedBox(width: 10,),
                                      //     GestureDetector(
                                      //         onTap: () => _selectDate(context),
                                      //         child: Image.asset("assets/icons/calender_icon.png", scale: 4,)),
                                      //   ],
                                      // ),
                                    ],
                                  ),
                                ),
                                isPortrait?
                                Column(
                                  children: [
                                    // SizedBox(height: 10,),
                                    Padding(padding: EdgeInsets.symmetric(horizontal: 18), child: _roomsPanel(isPortrait, isData: false)),
                                    // liner
                                    SizedBox(height: 10,),
                                  ],
                                ) : SizedBox.shrink(),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.only(left: 18,top:10,bottom:10,right:0),
                                          decoration: BoxDecoration(
                                              color: Color(0xfff5f5f5),
                                              border: Border(right: BorderSide(color: Colors.black12,), top: BorderSide(color: Colors.black12))
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(Icons.circle, color: Colors.deepOrangeAccent, size: 14,),
                                                  SizedBox(width: 6,),
                                                  Text(
                                                    "Pending Tasks",
                                                    style: headingSmall,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 10),
                                              // add shimmer here for pending tasks
                                              _roomController.isLoadingForRoomData==true?Shimmer(
                                                  child: Container(
                                                    // height:40.h,
                                                    child: Column(
                                                      children: [
                                                      ListView.builder(

                                                            itemCount: items.length,
                                                            shrinkWrap:true,
                                                            itemBuilder: (context,index){
                                                              return Padding(

                                                                padding: const EdgeInsets.only(bottom: 5,right: 10),
                                                                child: Container(
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(10),
                                                                      color: Colors.grey.withOpacity(.5),
                                                                    ),
                                                                    child: SizedBox(
                                                                      height: 12.h,
                                                                      // width: 100,
                                                                      child:Padding(
                                                                        padding: const EdgeInsets.all(8.0),
                                                                        child: Column(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children:[
                                                                            Container(

                                                                                // padding:const EdgeInsets.only(bottom: 10),
                                                                              height:20,
                                                                              decoration:BoxDecoration(
                                                                                borderRadius:BorderRadius.circular(10),
                                                                                color:Colors.white,
                                                                              )
                                                                            ),
                                                                            Container(
                                                                              // padding:const EdgeInsets.only(bottom: 10),
                                                                                height:20,
                                                                                width:100,
                                                                                decoration:BoxDecoration(
                                                                                  borderRadius:BorderRadius.circular(10),
                                                                                  color:Colors.white,
                                                                                )
                                                                            ),
                                                                            Container(
                                                                                // padding:const EdgeInsets.only(top: 10),
                                                                                height:30,
                                                                                width:200,
                                                                                decoration:BoxDecoration(
                                                                                  borderRadius:BorderRadius.circular(10),
                                                                                  color:Colors.white,
                                                                                )
                                                                            ),
                                                                            Container(
                                                                                // padding:const EdgeInsets.only(top: 10),
                                                                                height:35,
                                                                                decoration:BoxDecoration(
                                                                                  borderRadius:BorderRadius.circular(10),
                                                                                  color:Colors.white,
                                                                                )
                                                                            )
                                                                          ]
                                                                        ),
                                                                      )
                                                                    ),),
                                                              );
                                                            })

                                                      ],
                                                    ),
                                                  ),
                                                  gradient: const LinearGradient(
                                                      colors: [
                                                        Colors.grey,
                                                        Colors.white70
                                                      ],
                                                      begin: Alignment.topLeft,
                                                      end: Alignment.bottomRight)):
                                              Expanded(
                                                child:  Container(
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
                                                            Padding(
                                                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  // idr updat kro
                                                                  // Text("Daily Tasks", style: headingMedium),
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
                                                                  ):Text("Daily Tasks", style: headingMedium),

                                                                  SizedBox(height: 8),
                                                                  ReorderableListView.builder(
                                                                    physics: ScrollPhysics(),
                                                                    shrinkWrap: true,
                                                                    itemCount: _roomController.pendingDailyTasksList.length,
                                                                    onReorder: (int oldIndex, int newIndex) {
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
                                                                          dateTime: isPortrait?
                                                                         '\n'+ _roomController.updateDateTime(_roomController.pendingDailyTasksList[index].createdAt.toString())
                                                                              :_roomController.updateDateTime(_roomController.pendingDailyTasksList[index].createdAt.toString()),
                                                                          task: Task(name: _roomController.pendingDailyTasksList[index].name, lastCompleted: DateTime(2024, 6, 7, 9, 40), status: 'Ongoing'),
                                                                          isCompletedSection: false,
                                                                          isEdit: true,
                                                                          onTapEdit: (){
                                                                            print("object");
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
                                                                              Get.back();
                                                                              _roomController.deleteTask(_roomController.pendingDailyTasksList[index].id.toString());

                                                                              print("Delete taskt");
                                                                              // Get.back();
                                                                            }, null);
                                                                          },
                                                                          // onChanged: (value) async {
                                                                          //   // if(value)
                                                                          //   // {
                                                                          //     await showConfirmationDialog(value,_roomController.pendingDailyTasksList[index].id.toString(),_roomController.pendingDailyTasksList[index].status.toString());
                                                                          //
                                                                          //     // await showConfirmationDialog(value,_roomController.completedMonthlyTasksList[index].id.toString(),_roomController.completedMonthlyTasksList[index].status.toString());
                                                                          //   // }
                                                                          // },
                                                                          onTapChangeStatus: (){
                                                                            showConfirmationDialogForPendingTask(true,_roomController.pendingDailyTasksList[index].id.toString(),_roomController.pendingDailyTasksList[index].status.toString());

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
                                                                  ):Text("Weekly Tasks", style: headingMedium),

                                                                  // Text("Weekly Tasks", style: headingMedium),
                                                                  SizedBox(height: 8),
                                                                  ReorderableListView.builder(
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
                                                                        key: ValueKey( _roomController.pendingWeeklyTasksList[index]),                                                                        child: TaskTile(
                                                                        createdAt:_roomController.pendingWeeklyTasksList[index].lastCompletedDateTime!=null?'Last Completed: ': "Created At: ",
                                                                          dateTime: isPortrait?
                                                                          '\n'+ _roomController.updateDateTime(_roomController.pendingWeeklyTasksList[index].createdAt.toString())
                                                                              :_roomController.updateDateTime(_roomController.pendingWeeklyTasksList[index].createdAt.toString()),
                                                                          task: Task(name: _roomController.pendingWeeklyTasksList[index].name, lastCompleted: DateTime(2024, 6, 7, 9, 40), status: 'Ongoing'),
                                                                          isCompletedSection: false,
                                                                          isEdit: true,
                                                                          onTapEdit: (){
                                                                            _roomController.updateTaskDurability("Daily",'1');
                                                                            taskController.text=_roomController.pendingWeeklyTasksList[index].name;
                                                                            customDialogNewTask(context, "Edit Task", "Save Changes", (){
                                                                              print("Save asdas");
                                                                              if( _roomController.createTaskKey.currentState!.validate()){
                                                                                _roomController.editTask(taskController.text.toString(), _roomController.pendingWeeklyTasksList[index].roomId.toString(), _roomController.taskValue.toString(),  _roomController.pendingWeeklyTasksList[index].id.toString());
                                                                        
                                                                              }
                                                                        
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
                                                                          // print(value.toString());
                                                                          //   await showConfirmationDialog(value,_roomController.pendingDailyTasksList[index].id.toString(),_roomController.pendingDailyTasksList[index].status.toString());
                                                                          //
                                                                          // },
                                                                          onTapChangeStatus: (){
                                                                            showConfirmationDialogForPendingTask(true,_roomController.pendingWeeklyTasksList[index].id.toString(),_roomController.pendingWeeklyTasksList[index].status.toString());
                                                                        
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
                                                                          dateTime: isPortrait?
                                                                          '\n'+ _roomController.updateDateTime(_roomController.pendingMonthlyTasksList[index].createdAt.toString())
                                                                              :_roomController.updateDateTime(_roomController.pendingMonthlyTasksList[index].createdAt.toString()),
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
                                                                          //   await showConfirmationDialog(value,_roomController.pendingMonthlyTasksList[index].id.toString(),_roomController.pendingDailyTasksList[index].status.toString());
                                                                          //
                                                                          // },
                                                                          onTapChangeStatus: (){
                                                                            showConfirmationDialogForPendingTask(true,_roomController.pendingMonthlyTasksList[index].id.toString(),_roomController.pendingMonthlyTasksList[index].status.toString());

                                                                          },
                                                                        ),
                                                                      );
                                                                    } ,

                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            // Padding(
                                                            //   padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                            //   child: Column(
                                                            //     crossAxisAlignment: CrossAxisAlignment.start,
                                                            //     children: [
                                                            //       Text("Daily Tasks", style: headingMedium),
                                                            //       SizedBox(height: 8),
                                                            //       ListView.builder(
                                                            //         physics: ScrollPhysics(),
                                                            //         shrinkWrap: true,
                                                            //         itemCount: 1,
                                                            //         itemBuilder:(context,index){
                                                            //           return TaskTile(task: Task(name: _roomController.pendingDailyTasksList[index].name, lastCompleted: DateTime(2024, 6, 7, 9, 40), status: 'Ongoing'),
                                                            //             isCompletedSection: false,
                                                            //             isEdit: true,
                                                            //             onTapEdit: (){
                                                            //
                                                            //               customDialogNewTask(context, "Edit Task", "Save Changes", (){
                                                            //                 Get.back();
                                                            //                 Get.off(()=> RoomScreen(initialTitle: ""));
                                                            //               },taskController);
                                                            //             },
                                                            //             onTapRemove: (){
                                                            //               showCustomDialog(context, "assets/images/popup/ask.png", "Are You Sure?", "Are you sure that you want to remove this task from the list?", "Yes, Remove", (){
                                                            //                 // Get.back();
                                                            //               }, null);
                                                            //             },
                                                            //             onChanged: (value) async {
                                                            //               if(value)
                                                            //                 {
                                                            //                    await showConfirmationDialog(value);
                                                            //                 }
                                                            //             },
                                                            //           );
                                                            //         } ,
                                                            //
                                                            //       ),
                                                            //     ],
                                                            //   ),
                                                            // ),
                                                            // Padding(
                                                            //   padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                            //   child: Column(
                                                            //     crossAxisAlignment: CrossAxisAlignment.start,
                                                            //     children: [
                                                            //       Text("Weekly Tasks", style: headingMedium),
                                                            //       SizedBox(height: 8),
                                                            //       ListView.builder(
                                                            //         physics: ScrollPhysics(),
                                                            //         shrinkWrap: true,
                                                            //         itemCount: 1,
                                                            //         itemBuilder:(context,index){
                                                            //           return TaskTile(task: Task(name: 'Feed All Animals', lastCompleted: DateTime(2024, 6, 7, 9, 40), status: 'Ongoing'),
                                                            //             isCompletedSection: false,
                                                            //             isEdit: true,
                                                            //             onTapEdit: (){
                                                            //
                                                            //               customDialogNewTask(context, "Edit Task", "Save Changes", (){
                                                            //                 Get.back();
                                                            //                 Get.off(()=> RoomScreen(initialTitle: ""));
                                                            //               },taskController);
                                                            //             },
                                                            //             onTapRemove: (){
                                                            //               showCustomDialog(context, "assets/images/popup/ask.png", "Are You Sure?", "Are you sure that you want to remove this task from the list?", "Yes, Remove", (){
                                                            //                 // Get.back();
                                                            //               }, null);
                                                            //             },
                                                            //             onChanged: (value) async {
                                                            //               if(value)
                                                            //               {
                                                            //                 await showConfirmationDialog(value);
                                                            //               }
                                                            //             },
                                                            //           );
                                                            //         } ,
                                                            //
                                                            //       ),
                                                            //     ],
                                                            //   ),
                                                            // ),
                                                            // Padding(
                                                            //   padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                            //   child: Column(
                                                            //     crossAxisAlignment: CrossAxisAlignment.start,
                                                            //     children: [
                                                            //       Text("Monthly Tasks", style: headingMedium),
                                                            //       SizedBox(height: 8),
                                                            //       ListView.builder(
                                                            //         physics: ScrollPhysics(),
                                                            //         shrinkWrap: true,
                                                            //         itemCount: 1,
                                                            //         itemBuilder:(context,index){
                                                            //           return TaskTile(
                                                            //             task: Task(name: 'Feed All Animals', lastCompleted: DateTime(2024, 6, 7, 9, 40), status: 'Ongoing'),
                                                            //             isCompletedSection: false,
                                                            //             isEdit: true,
                                                            //             onTapEdit: (){
                                                            //               customDialogNewTask(context, "Edit Task", "Save Changes", (){
                                                            //                 Get.back();
                                                            //                 Get.off(()=> RoomScreen(initialTitle: ""));
                                                            //               },taskController);
                                                            //             },
                                                            //             onTapRemove: (){
                                                            //               showCustomDialog(context, "assets/images/popup/ask.png", "Are You Sure?", "Are you sure that you want to remove this task from the list?", "Yes, Remove", (){
                                                            //                 // Get.back();
                                                            //               }, null);
                                                            //             },
                                                            //             onChanged: (value) async {
                                                            //               if(value)
                                                            //               {
                                                            //                 await showConfirmationDialog(value);
                                                            //               }
                                                            //             },
                                                            //           );
                                                            //         } ,
                                                            //
                                                            //       ),
                                                            //     ],
                                                            //   ),
                                                            // ),
                                                            // TaskSection(title: 'Monthly Tasks', tasks: monthlyTasks, isEdit: true,),
                                                          ],
                                                        ),
                                                    ),
                                                  ),
                                                ),

                                              ),
                                              // Container(
                                              //   height: 200,
                                              //   color: Colors.orange[50],
                                              //   child: Center(child: Text('No Pending Tasks')),
                                              // ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.only(left: 18,top:10,bottom:10,right:5),

                                          decoration: BoxDecoration(
                                              color: Color(0xfff5f5f5),
                                              border: Border(top: BorderSide(color: Colors.black12))
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(Icons.circle, color: Colors.green, size: 14,),
                                                  SizedBox(width: 6,),
                                                  Text(
                                                    "Completed Tasks",
                                                    style: headingSmall,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 10),
                                              // add shimmer here for completed task
                                              _roomController.isLoadingForRoomData==true?Shimmer(
                                                  child: Column(
                                                    children: [
                                                      ListView.builder(
                                                          itemCount: 3,
                                                          shrinkWrap:true,

                                                          itemBuilder: (context,index){
                                                            return Padding(

                                                              padding: const EdgeInsets.only(bottom: 5,right: 10),
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(10),
                                                                  color: Colors.grey.withOpacity(.5),
                                                                ),
                                                                child: SizedBox(
                                                                    height: 12.h,
                                                                    // width: 100,
                                                                    child:Padding(
                                                                      padding: const EdgeInsets.all(8.0),
                                                                      child: Column(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children:[
                                                                            Container(

                                                                              // padding:const EdgeInsets.only(bottom: 10),
                                                                                height:20,
                                                                                decoration:BoxDecoration(
                                                                                  borderRadius:BorderRadius.circular(10),
                                                                                  color:Colors.white,
                                                                                )
                                                                            ),
                                                                            Container(
                                                                              // padding:const EdgeInsets.only(bottom: 10),
                                                                                height:20,
                                                                                width:100,
                                                                                decoration:BoxDecoration(
                                                                                  borderRadius:BorderRadius.circular(10),
                                                                                  color:Colors.white,
                                                                                )
                                                                            ),
                                                                            Container(
                                                                              // padding:const EdgeInsets.only(top: 10),
                                                                                height:30,
                                                                                width:200,
                                                                                decoration:BoxDecoration(
                                                                                  borderRadius:BorderRadius.circular(10),
                                                                                  color:Colors.white,
                                                                                )
                                                                            ),
                                                                            Container(
                                                                              // padding:const EdgeInsets.only(top: 10),
                                                                                height:35,
                                                                                decoration:BoxDecoration(
                                                                                  borderRadius:BorderRadius.circular(10),
                                                                                  color:Colors.white,
                                                                                )
                                                                            )
                                                                          ]
                                                                      ),
                                                                    )
                                                                ),),
                                                            );
                                                          })

                                                    ],
                                                  ),
                                                  gradient: const LinearGradient(
                                                      colors: [
                                                        Colors.grey,
                                                        Colors.white70
                                                      ],
                                                      begin: Alignment.topLeft,
                                                      end: Alignment.bottomRight)):
                                              Expanded(
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
                                                              ) :Text("Daily Tasks", style: headingMedium),

                                                              // Text("Daily Tasks", style: headingMedium),
                                                              SizedBox(height: 8),
                                                              ReorderableListView.builder(
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
                                                                      completeBy:_roomController.completedDailyTasksList[index].member,
                                                                      dateTime: isPortrait?
                                                                      '\n'+ _roomController.updateDateTime(_roomController.completedDailyTasksList[index].updatedAt.toString())
                                                                          :_roomController.updateDateTime(_roomController.completedDailyTasksList[index].updatedAt.toString()),
                                                                      task: Task(name: _roomController.completedDailyTasksList[index].name, lastCompleted: DateTime(2024, 6, 7, 9, 40), status: 'Ongoing'),
                                                                      isCompletedSection: true,
                                                                      isEdit: true,
                                                                      // onChanged: (value) async {
                                                                      //   // if(value)
                                                                      //   // {
                                                                      //   await showConfirmationDialog(value,_roomController.completedDailyTasksList[index].id.toString(),_roomController.completedDailyTasksList[index].status.toString());
                                                                      //   // }
                                                                      // },
                                                                      onTapRemoveCompletedTasks: (){
                                                                        showCustomDialog(context, "assets/images/popup/ask.png", "Are You Sure?", "Are you sure that you want to remove this task from the list?", "Yes, Remove", (){
                                                                          // _roomController.deleteTask("32");
                                                                          _roomController.deleteTask(_roomController.completedDailyTasksList[index].id.toString());
                                                                          Get.back();
                                                                        }, null);
                                                                      },
                                                                      onTapChangeStatus: (){

                                                                          showCustomDialog(context, "assets/images/popup/ask.png", "Are You Sure?", "Are you sure that you want to change this task's status?", "Yes",
                                                                                  (){
                                                                                _roomController.changeTaskStatus(_roomController.completedDailyTasksList[index].id.toString(), _roomController.completedDailyTasksList[index].status.toString()=='0'?'1':'0', "Admin").whenComplete((){
                                                                                  _roomController.completedDailyTasksList.removeAt(index);
                                                                                  setState(() {

                                                                                  });
                                                                                });
                                                                                Get.back();
                                                                              }, null);


                                                                        // print(_roomController.completedDailyTasksList[index].member.toString());

                                                                        // showConfirmationDialog(true,_roomController.completedDailyTasksList[index].id.toString(),_roomController.completedDailyTasksList[index].status.toString(),_roomController.completedDailyTasksList[index].member.toString());

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
                                                                      completeBy:_roomController.completedWeeklyTasksList[index].member,
                                                                      dateTime: isPortrait?
                                                                      '\n'+ _roomController.updateDateTime(_roomController.completedWeeklyTasksList[index].updatedAt.toString())
                                                                          :_roomController.updateDateTime(_roomController.completedWeeklyTasksList[index].updatedAt.toString()),
                                                                      task: Task(name: _roomController.completedWeeklyTasksList[index].name, lastCompleted: DateTime(2024, 6, 7, 9, 40), status: 'Ongoing'),
                                                                      isCompletedSection: true,
                                                                      isEdit: true,
                                                                      onTapRemoveCompletedTasks: (){
                                                                        showCustomDialog(context, "assets/images/popup/ask.png", "Are You Sure?", "Are you sure that you want to remove this task from the list?", "Yes, Remove", (){
                                                                          _roomController.deleteTask(_roomController.completedWeeklyTasksList[index].id.toString());
                                                                          // Get.back();
                                                                    
                                                                        }, null);
                                                                      },
                                                                      // onChanged: (value) async {
                                                                      //   await showConfirmationDialog(value,_roomController.completedWeeklyTasksList[index].id.toString(),_roomController.completedWeeklyTasksList[index].status.toString());
                                                                      //
                                                                      // },
                                                                      onTapChangeStatus: (){
                                                                        showCustomDialog(context, "assets/images/popup/ask.png", "Are You Sure?", "Are you sure that you want to change this task's status?", "Yes",
                                                                                (){
                                                                              _roomController.changeTaskStatus(_roomController.completedWeeklyTasksList[index].id.toString(), _roomController.completedWeeklyTasksList[index].status.toString()=='0'?'1':'0', "Admin").whenComplete((){
                                                                                _roomController.completedWeeklyTasksList.removeAt(index);
                                                                                setState(() {
                                                                    
                                                                                });
                                                                              });
                                                                              Get.back();
                                                                            }, null);
                                                                    
                                                                        // showConfirmationDialog(true,_roomController.completedWeeklyTasksList[index].id.toString(),_roomController.completedWeeklyTasksList[index].status.toString(),_roomController.completedWeeklyTasksList[index].member.toString());
                                                                    
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
                                                                  return GestureDetector(
                                                                    key: ValueKey( _roomController.completedMonthlyTasksList[index]),
                                                                    child: TaskTile(
                                                                      completeBy: _roomController.completedMonthlyTasksList[index].member,
                                                                      dateTime: isPortrait?
                                                                      '\n'+ _roomController.updateDateTime(_roomController.completedMonthlyTasksList[index].updatedAt.toString())
                                                                          :_roomController.updateDateTime(_roomController.completedMonthlyTasksList[index].updatedAt.toString()),
                                                                      task: Task(name: _roomController.completedMonthlyTasksList[index].name, lastCompleted: DateTime(2024, 6, 7, 9, 40), status: 'Ongoing'),
                                                                      isCompletedSection: true,
                                                                      isEdit: true,
                                                                      onTapRemoveCompletedTasks: (){
                                                                        showCustomDialog(context, "assets/images/popup/ask.png", "Are You Sure?", "Are you sure that you want to remove this task from the list?", "Yes, Remove", (){
                                                                          _roomController.deleteTask(_roomController.completedMonthlyTasksList[index].id.toString());
                                                                          // Get.back();
                                                                        }, null);
                                                                      },
                                                                      // onChanged: (value) async {
                                                                      //   await showConfirmationDialog(value,_roomController.completedMonthlyTasksList[index].id.toString(),_roomController.completedMonthlyTasksList[index].status.toString());
                                                                      //
                                                                      // },
                                                                      onTapChangeStatus: (){
                                                                        showCustomDialog(context, "assets/images/popup/ask.png", "Are You Sure?", "Are you sure that you want to change this task's status?", "Yes",
                                                                                (){
                                                                              _roomController.changeTaskStatus(_roomController.completedMonthlyTasksList[index].id.toString(), _roomController.completedMonthlyTasksList[index].status.toString()=='0'?'1':'0', "Admin").whenComplete((){
                                                                                _roomController.completedMonthlyTasksList.removeAt(index);
                                                                                setState(() {
                                                                    
                                                                                });
                                                                              });
                                                                              Get.back();
                                                                            }, null);
                                                                        // showConfirmationDialog(true,_roomController.completedMonthlyTasksList[index].id.toString(),_roomController.completedMonthlyTasksList[index].status.toString(),_roomController.completedMonthlyTasksList[index].member.toString());
                                                                    
                                                                      },
                                                                    ),
                                                                  );
                                                                } ,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        // Padding(
                                                        //   padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                        //   child: Column(
                                                        //     crossAxisAlignment: CrossAxisAlignment.start,
                                                        //     children: [
                                                        //       Text("Daily Tasks", style: headingMedium),
                                                        //       SizedBox(height: 8),
                                                        //       ListView.builder(
                                                        //         physics: ScrollPhysics(),
                                                        //         shrinkWrap: true,
                                                        //         itemCount: 1,
                                                        //         itemBuilder:(context,index){
                                                        //           return TaskTile(
                                                        //             task: Task(name: 'Feed All Animals', lastCompleted: DateTime(2024, 6, 7, 9, 40), status: 'Ongoing'),
                                                        //             isCompletedSection: true,
                                                        //             isEdit: true,
                                                        //             onChanged: (value) async {
                                                        //               if(value)
                                                        //               {
                                                        //                 await showConfirmationDialog(value);
                                                        //               }
                                                        //             },
                                                        //             onTapRemoveCompletedTasks: (){
                                                        //               showCustomDialog(context, "assets/images/popup/ask.png", "Are You Sure?", "Are you sure that you want to remove this task from the list?", "Yes, Remove", (){
                                                        //                 Get.back();
                                                        //               }, null);
                                                        //             },
                                                        //           );
                                                        //         } ,
                                                        //
                                                        //       ),
                                                        //     ],
                                                        //   ),
                                                        // ),
                                                        // Padding(
                                                        //   padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                        //   child: Column(
                                                        //     crossAxisAlignment: CrossAxisAlignment.start,
                                                        //     children: [
                                                        //       Text("Weekly Tasks", style: headingMedium),
                                                        //       SizedBox(height: 8),
                                                        //       ListView.builder(
                                                        //         physics: ScrollPhysics(),
                                                        //         shrinkWrap: true,
                                                        //         itemCount: 1,
                                                        //         itemBuilder:(context,index){
                                                        //           return TaskTile(
                                                        //             task: Task(name: 'Feed All Animals', lastCompleted: DateTime(2024, 6, 7, 9, 40), status: 'Ongoing'),
                                                        //             isCompletedSection: true,
                                                        //             isEdit: true,
                                                        //             onTapRemoveCompletedTasks: (){
                                                        //               showCustomDialog(context, "assets/images/popup/ask.png", "Are You Sure?", "Are you sure that you want to remove this task from the list?", "Yes, Remove", (){
                                                        //                 Get.back();
                                                        //               }, null);
                                                        //             },
                                                        //             onChanged: (value) async {
                                                        //               if(value)
                                                        //               {
                                                        //                 await showConfirmationDialog(value);
                                                        //               }
                                                        //             },
                                                        //           );
                                                        //         } ,
                                                        //
                                                        //       ),
                                                        //     ],
                                                        //   ),
                                                        // ),
                                                        // Padding(
                                                        //   padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                        //   child: Column(
                                                        //     crossAxisAlignment: CrossAxisAlignment.start,
                                                        //     children: [
                                                        //       Text("Monthly Tasks", style: headingMedium),
                                                        //       SizedBox(height: 8),
                                                        //       ListView.builder(
                                                        //         physics: ScrollPhysics(),
                                                        //         shrinkWrap: true,
                                                        //         itemCount: 1,
                                                        //         itemBuilder:(context,index){
                                                        //           return TaskTile(
                                                        //             task: Task(name: 'Feed All Animals', lastCompleted: DateTime(2024, 6, 7, 9, 40), status: 'Ongoing'),
                                                        //             isCompletedSection: true,
                                                        //             isEdit: true,
                                                        //             onTapRemoveCompletedTasks: (){
                                                        //               showCustomDialog(context, "assets/images/popup/ask.png", "Are You Sure?", "Are you sure that you want to remove this task from the list?", "Yes, Remove", (){
                                                        //                 Get.back();
                                                        //               }, null);
                                                        //             },
                                                        //             onChanged: (value) async {
                                                        //               if(value)
                                                        //               {
                                                        //                 await showConfirmationDialog(value);
                                                        //               }
                                                        //             },
                                                        //           );
                                                        //         } ,
                                                        //       ),
                                                        //     ],
                                                        //   ),
                                                        // ),
                                                        // TaskSection(title: 'Weekly Tasks', tasks: weeklyTasks, isCompleted: true,isEdit: true,),
                                                        // TaskSection(title: 'Monthly Tasks', tasks: monthlyTasks, isCompleted: true,isEdit: true,),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
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
                    ) :  Expanded(
                      child: Container(
                        color:Colors.grey.shade50,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 22.0, top: 10),
                                  child: Text(
                                    "Notifications",
                                    style: headingLarge,
                                  ),
                                ),
                                Spacer(),
                               _roomController.notificationsList.isNotEmpty? GestureDetector(
                                   onTap:(){
                                     showCustomDialog(context, "assets/images/popup/ask.png", "Are You Sure?", "Are you sure that you want to delete all notifications?", "Yes, Delete", (){

                                       _roomController.deleteAllNotifications();
                                       print("Delete taskt");
                                       // Get.back();
                                     }, null);
                                   },
                                   child: Row(
                                    children: [

                                      Icon(Icons.delete,color:AppColors.primaryColor,size:25),
                                      Padding(
                                        padding: const EdgeInsets.only(top:5),
                                        child: Text("Clear All Notifications?",
                                          style: headingMedium,
                                        ),
                                      ),
                                    ],
                                  ),
                               ):Container(),
                                SizedBox(width:15)
                              ],
                            ),
                            SizedBox(height: 20),
                          _roomController.isLoading==true?Expanded(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ): Expanded(
                              child: SmartRefresher(
                                enablePullDown: true,
                                enablePullUp: true,
                                // footer:ClassicFooter(),
                                controller: _notificationRefreshController,
                                onLoading: () async {
                                  print("object");
                                  // Future.delayed(Duration(seconds: 2));
                                  if (_roomController.notificationsCurrentPage.value<_roomController.notificationsLastPage.value) {
                                    await _roomController.getNotifications();
                                    setState(() {});
                                  }
                                  _notificationRefreshController.loadComplete();
                                },
                                child:
                                _roomController.notificationsList.isNotEmpty ?
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal:20),
                                  child: AlignedGridView.count(
                                    crossAxisCount: isPortrait ? 1 : 2,
                                    crossAxisSpacing: 15,
                                    mainAxisSpacing: 15,
                                    padding: EdgeInsets.only(bottom: 30),
                                    itemCount: _roomController.notificationsList.length, // Replace with your actual number of notifications
                                    itemBuilder: (context, index) {
                                      _swipeOffsets[index] = _swipeOffsets[index] ?? 0.0;
                                      return Stack(
                                        key: ValueKey(index),
                                        children: [
                                          // Background container with delete icon
                                          Positioned.fill(
                                            child: GestureDetector(
                                              onTap:(){
                                                showCustomDialog(context, "assets/images/popup/ask.png", "Are You Sure?", "Are you sure that you want to remove this notification from the list?", "Yes, Remove", ()
                                                {
                                                  if(_roomController.notificationsList[index].markAsRead.toString()=='0'){
                                                    // i added this line here
                                                    // _roomController.notificationsList[index].markAsRead.toString()=='1';
                                                    _roomController.notificationCounts.value=_roomController.notificationCounts.value-1;
                                                  }
                                                  _roomController.deleteNotification(_roomController.notificationsList[index].id);
                                                  setState(() {
                                                    _swipeOffsets.remove(index);
                                                    _roomController.notificationsList.removeAt(index);
                                                  });
                                                }, null);



                                                print("object");
                                              },
                                              child: Container(
                                                alignment: Alignment.centerRight,
                                                padding: EdgeInsets.only(right: 20),
                                                child: Container(
                                                  width: 100,
                                                  height: 100,
                                                  decoration: BoxDecoration(
                                                    color: Color(0xffF7941D),
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  child: Icon(
                                                    Icons.delete,
                                                    color: Colors.white,
                                                    size: 30,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          // Foreground card that can be swiped
                                          GestureDetector(
                                            onHorizontalDragUpdate: (details) {
                                              setState(() {
                                                // Swipe right to left (negative delta) to reveal the delete icon, limit to 100 pixels
                                                _swipeOffsets[index] =
                                                    (_swipeOffsets[index]! + details.primaryDelta!).clamp(-100.0, 0.0);
                                              });
                                            },
                                            onHorizontalDragEnd: (details) {
                                              setState(() {
                                                // If card is less than halfway swiped (i.e., more than -50 pixels), snap it back
                                                if (_swipeOffsets[index]! > -50) {
                                                  _swipeOffsets[index] = 0.0;
                                                } else {
                                                  _swipeOffsets[index] = -100.0;
                                                }
                                              });
                                            },
                                            child: Transform.translate(
                                              offset: Offset(_swipeOffsets[index]!, 0),
                                              child: GestureDetector(
                                                onTap:(){
                                                  if(_roomController.notificationsList[index].markAsRead.toString()=='0'){
                                                    _roomController.notificationCounts.value=_roomController.notificationCounts.value-1;
                                                    setState(() {

                                                    });
                                                    _roomController.markAsRead(_roomController.notificationsList[index].id.toString());

                                                    setState(() {
                                                      _roomController.notificationsList[index].markAsRead="1";
                                                      // unreadColor=readColor;
                                                    });
                                                  }
                                                  if(_roomController.notificationsList[index].data.status.toString() == ''){
                                                    Get.to(()=> NotificationDetailScreen(notificationMessage: _roomController.notificationsList[index].data.message.toString(),notificationTitle: _roomController.notificationsList[index].data.title.toString(),userName: _roomController.notificationsList[index].data.name.toString(),));
                                                  }else{
                                                    _roomController.updateRoomId(_roomController.roomsList[index].id.toString());
                                                    print(_roomController.roomsList[index].id.toString());
                                                    Get.offAll(() => ShowCaseRoom(initialTitle: _roomController.roomsList[index].name.toString(),
                                                      isNewCreated: false, isEditRoom: true,roomId: _roomController.notificationsList[index].data.roomId.toString(),));
                                                    _authController.updateIsAdminView(true);
                                                    // Get.to(()=> RoomScreen(notificationMessage: _roomController.notificationsList[index].data.message.toString(),notificationTitle: _roomController.notificationsList[index].data.title.toString(),userName: _roomController.notificationsList[index].data.name.toString(),));

                                                    print("no ");
                                                  }
                                                },
                                                child: Card(
                                                  color:_roomController.notificationsList[index].markAsRead.toString()=='0'? unreadColor:readColor,
                                                  elevation: 2,
                                                  shadowColor: Colors.black26,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(16.0),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius: BorderRadius.circular(100),
                                                              child: Container(
                                                                width: 35,
                                                                decoration: BoxDecoration(
                                                                  shape: BoxShape.circle,
                                                                  color: Colors.black12,
                                                                ),
                                                                child: Image.asset(
                                                                  "assets/icons/user_icon.png",
                                                                  scale: 4,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(width: 16),
                                                            Text(
                                                              _roomController.notificationsList[index].data.status.toString() == ''
                                                                  ? _roomController.notificationsList[index].data.name.toString()
                                                                  : _roomController.notificationsList[index].data.member.toString(),
                                                              style: headingMedium,
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 8),
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              _roomController.notificationsList[index].data.status.toString() == ''
                                                                  ? _roomController.notificationsList[index].data.title.toString()
                                                                  : "Task Status",
                                                              style: headingMedium,
                                                            ),
                                                            // Text(_roomController.notificationsList[index].data.status.toString() == ""?_roomController.notificationsList[index].data.title.toString():''),
                                                            SizedBox(height: 10),
                                                            Align(
                                                              alignment: Alignment.centerLeft,
                                                              child: Text(
                                                                _roomController.notificationsList[index].data.status.toString()=='Completed'?_roomController.notificationsList[index].data.name.toString()+" is completed":_roomController.notificationsList[index].data.message.toString(),
                                                                style: notificationBody.copyWith(color: Colors.grey),
                                                                maxLines: 2,
                                                                overflow: TextOverflow.ellipsis,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );



                                    },
                                  ),
                                ):Center(
                                    child: Text("No notifications yet",
                                      style: headingSmall,

                                    )
                                ),
                              ),
                            ),
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
    );
  }
  _dashBoardPanel(){
    return Container(
      width: 80,
      // height: double.infinity,
      decoration: BoxDecoration(
          border: Border(right: BorderSide(color: Colors.black12))
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: (){
              setState(() {
                selectedBoard = 0;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 50,
                  width: 8,
                  decoration: BoxDecoration(
                      color: selectedBoard == 0? AppColors.primaryColor : Colors.transparent
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 18.0),
                  child: Image.asset("assets/icons/tasks.png", scale: 3, color: selectedBoard == 0? AppColors.primaryColor : Colors.grey,),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: (){
              setState(() {
                selectedBoard = 1;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(

                  height: 55,
                  width: 8,
                  decoration: BoxDecoration(

                      color: selectedBoard == 1? AppColors.primaryColor : Colors.transparent
                  ),
                ),
                Stack(
                  children: [
                    Container(
                      // color:Colors.grey,
                      padding: EdgeInsets.only(top: 5),
                      height: 45,
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 18.0),
                            child: Image.asset("assets/icons/notification.png", scale: 3, color: selectedBoard == 1? AppColors.primaryColor : Colors.grey,),
                          ),
                        ],
                      ),
                    ),
                    _roomController.notificationCounts.value<1?Container() : Positioned(
                        right: 9,
                        top: 3,
                        child: Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: AppColors.primaryColor,
                            ),
                            child: Center(child: Text(_roomController.notificationCounts.value.toString(),style: TextStyle(color: AppColors.scaffoldColor,fontSize: 10),))))
                  ],
                )

               
              ],
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: GestureDetector(
              onTap: (){
                showCustomDialog(context, "assets/images/popup/ask.png", "Are You Sure?", "Are you sure that you want to logout?", "Yes", (){
                  // _roomController.deleteRoom("10");
                  // Get.back();
                  _authController.logoutUser();
                }, null);

                // Get.offAll(()=> LogInScreen());
                print("logout");
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/icons/logout.png", scale: 3,),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  _roomsPanel(bool isPortrait, {bool isData = false}) {
    RefreshController _refreshController = RefreshController(initialRefresh: false);
    return Container(
          width: isPortrait ? null : 220,
          height: isPortrait ? 120 : null,
          decoration: BoxDecoration(
            border: isPortrait
                ? Border(bottom: BorderSide.none)
                : Border(right: BorderSide(color: Colors.black12)),
          ),
          child:  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: isPortrait ? 8.0 : 8.0, top: isPortrait ? 18 : 12,bottom: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Rooms",
                          style: isPortrait ? headingMedium.copyWith(fontSize: 19) : headingMedium.copyWith(fontSize: 19),
                        ),

                       isPortrait? GestureDetector(
                          onTap: (){
                            roomNameController.clear();
                            customDialogTextField(context,"Create New Room", "Create", "Enter Room Name", (){

                              if(_roomController.roomKey.currentState!.validate()){
                                _roomController.createRoom(roomNameController.text.toString());
                              }
                              // Get.to(()=> RoomScreen(initialTitle: "Room Title", isNewCreated: true,));
                            }, roomNameController,FocusNode());
                          },
                          child: Text(
                            "Create New Room",
                            style: TextStyle(
                                fontSize: 17, color:AppColors.primaryColor, fontFamily: 'SemiBoldText'),
                          ),
                        ):Container(),
                      ],
                    ),
                  ),
                  isPortrait?SizedBox():
                  SizedBox(
                    height: 10,
                  ),
                  isData == false
                      // here is final ui change
                      ?Expanded(
                        child:_roomController.isLoading==true?Center(child:CircularProgressIndicator()) : _roomController.roomsList.isNotEmpty?
                        ReorderableListView.builder(
                          // physics: BouncingScrollPhysics(),
                          scrollDirection:Axis.horizontal,
                          // isPortrait ? Axis.horizontal : Axis.vertical,
                          itemCount: _roomController.roomsList.length,
                          onReorder: (int oldIndex, int newIndex) {
                            setState(() {
                              if (newIndex > oldIndex) {
                                newIndex -= 1;
                              }
                              // bordy
                              // selectedBoard=newIndex;
                              int myId= _roomController.roomsList[_roomController.roomIndexForSelectedRoom.value].id;
                              final RoomsModel item = _roomController.roomsList.removeAt(oldIndex);
                              _roomController.roomsList.insert(newIndex, item);
                              _roomController.roomIndexForSelectedRoom.value= _roomController.roomsList.indexWhere((e)=>e.id==myId);
                              print(oldIndex);
                              print(newIndex);
                              if(oldIndex>newIndex){
                                print(_roomController.roomsList[newIndex].id);
                                print(_roomController.roomsList[newIndex+1].id);
                                _roomController.swapRooms(_roomController.roomsList[newIndex].id, _roomController.roomsList[newIndex+1].id);
                              }else{
                                print(_roomController.roomsList[newIndex-1].id);
                                print(_roomController.roomsList[newIndex].id);
                                _roomController.swapRooms(_roomController.roomsList[newIndex].id, _roomController.roomsList[newIndex-1].id);

                              }





                              // _roomController.swapRooms(firstRoomId, secondRoomId)
                              // setState(() {
                              //
                              // });
                            });
                          },
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              key: ValueKey( _roomController.roomsList[index]),
                              onTap: () {
                                setState(() {
                                  // specific room
                                  selectedDate=null;
                                  _generalController.updateDateForHome("");
                                  _generalController.updateRoomIndexForResetATTwelveAM(index);
                                  _roomController.updateDateAfterFiltering('');
                                  _roomController.roomIndexForSelectedRoom.value = index;
                                  _roomController.updateRoomId(_roomController.roomsList[index].id.toString());
                                  _roomController.getRoomData(_roomController.roomsList[index].id.toString(),'Haider');
                                  print(_roomController.roomIndexForSelectedRoom.value);
                                  print(index);

                                  // customDialogTextField(context, isPortrait? 30.w : 60.w,"Create New Room", "Create", (){},);
                                });
                              },
                              child: Container(
                                width: 250,
                                child: RoomTile(
                                  onTapEnterRoomAdminMode:(){
                                    selectedDate=null;
                                    _generalController.updateDateForHome("");
                                    _roomController.updateDateAfterFiltering('');
                                    _roomController.roomIndexForSelectedRoom.value = index;
                                    Get.back();
                                    print("Enter room in admin mode");
                                    _authController.updateIsAdminView(true);
                                    _roomController.updateRoomIndex(index);
                                    // _authPreference.setRoomId(_roomController.roomsList[index].id.toString());
                                    // _authPreference.setStaffView('1');
                                    _authPreference.setRoomName(_roomController.roomsList[index].name.toString());
                                    _authPreference.setRoomId(_roomController.roomsList[index].id.toString());
                                    // set room index to select the highlight the color of room tile if staff view implemented and restarted the app
                                    _authPreference.setRoomIndex(index.toString());
                                    _roomController.updateRoomId(_roomController.roomsList[index].id.toString());
                                    print(_roomController.roomsList[index].id.toString());
                                    Get.offAll(() => ShowCaseRoom(initialTitle: _roomController.roomsList[index].name.toString(),
                                      isNewCreated: false, isEditRoom: true,roomId: _roomController.roomsList[index].id.toString(),));

                                  },
                                  onTapEnterRoom: (){
                                    selectedDate=null;

                                    _generalController.updateDateForHome("");
                                    _roomController.updateDateAfterFiltering('');
                                    Get.back();
                                    print("Enter room");
                                    _roomController.roomIndexForSelectedRoom.value = index;
                                    _authController.updateIsAdminView(false);
                                    _authPreference.setRoomId(_roomController.roomsList[index].id.toString());
                                    _authPreference.setStaffView('1');
                                    // set room index to select the highlight the color of room tile if staff view implemented and restarted the app
                                    _authPreference.setRoomIndex(index.toString());
                                    _authPreference.setRoomName(_roomController.roomsList[index].name.toString());
                                    _roomController.updateRoomId(_roomController.roomsList[index].id.toString());
                                    print(_roomController.roomsList[index].id.toString());
                                    Get.offAll(() => ShowCaseRoom(initialTitle: _roomController.roomsList[index].name.toString(),
                                      isNewCreated: false, isEditRoom: true,roomId: _roomController.roomsList[index].id.toString(),));
                                    // Get.offAll(()=> RoomScreen(initialTitle: "Room 1", isEditRoom: false,), transition: Transition.rightToLeft);
                                  },
                                  onTapEditRoom: (){

                                    Get.back();
                                    print("Edit room");
                                    roomNameController.text= _roomController.roomsList[index].name;
                                    customDialogTextField(context,"Edit Room Name", "Save", "Enter Room Name", (){
                                      if(_roomController.roomKey.currentState!.validate()){
                                        _roomController.editRoom(roomNameController.text.toString(), _roomController.roomsList[index].id.toString()).whenComplete((){
                                          setState(() {
                                            _roomController.roomsList[index].name=roomNameController.text;
                                          });
                                        });
                                      }
                                      // if(roomNameController.text.toString().isEmpty){
                                      //   CustomDialog.showErrorDialog(description: "Please Enter Room name");
                                      //
                                      // }else{
                                      //   _roomController.editRoom(roomNameController.text.toString(), _roomController.roomsList[index].id.toString()).whenComplete((){
                                      //     setState(() {
                                      //       _roomController.roomsList[index].name=roomNameController.text;
                                      //     });
                                      //   });
                                      // }


                                    }, roomNameController,FocusNode());

                                    // Get.to(()=> RoomScreen(initialTitle: "Room 1", isEditRoom: true,), transition: Transition.rightToLeft);
                                  },
                                  onTapDeleteRoom: (){
                                    Get.back();
                                    showCustomDialog(context, "assets/images/popup/ask.png", "Are You Sure?", "Are you sure that you want to remove this room from the list?", "Yes, Remove", (){
                                      // _roomController.deleteRoom("10");
                                      selectedDate=null;
                                      _generalController.updateDateForHome("");

                                      _roomController.deleteRoom(_roomController.roomsList[index].id.toString()).whenComplete((){
                                        _roomController.roomsList.removeAt(index);
                                        setState(() {
                                        //   final change
                                          if(_roomController.roomIndexForSelectedRoom.value == index){
                                            selectedDate=null;
                                            _generalController.updateDateForHome("");
                                            _roomController.updateDateAfterFiltering('');
                                            _roomController.roomIndexForSelectedRoom.value = 0;
                                            _roomController.updateRoomId(_roomController.roomsList[0].id.toString());
                                            _roomController.getRoomData(_roomController.roomsList[0].id.toString(),'Haider');
                                            print(_roomController.roomIndexForSelectedRoom.value);
                                            print(index);
                                          }


                                        });
                                      });


                                      // Get.back();
                                    }, null);
                                  },


                                  roomName: _roomController.roomsList[index].name.toString(),
                                  isSelected: _roomController.roomIndexForSelectedRoom.value == index,
                                ),
                              ),
                            );
                          },
                        ):
                    Padding(
padding: EdgeInsets.symmetric(horizontal: isPortrait ? 8.0 : 10),
child: SizedBox(
height: 65,
child: CustomButton(
onTap: () {
  roomNameController.clear();
  customDialogTextField(context,"Create New Room", "Create", "Enter Room Name", (){

    if(_roomController.roomKey.currentState!.validate()){
      _roomController.createRoom(roomNameController.text.toString());


    }
    // Get.to(()=> RoomScreen(initialTitle: "Room Title", isNewCreated: true,));
  }, roomNameController,FocusNode());
},
buttonText: "Create New Room",
),
),
),
                      )
                      :
                  _roomController.isLoading==true? Shimmer(
                      child: Column(
                        children: [
                          ListView.builder(
                            itemCount: 3,
                              shrinkWrap:true,
                              itemBuilder: (context,index){
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 5,left: 5,right: 5),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey.withOpacity(.5),
                                ),

                                  child: SizedBox(
                                    height: 5.h,
                                    width: 100,
                                  )),
                            );
                          })

                        ],
                      ),
                      gradient: const LinearGradient(
                          colors: [
                            Colors.grey,
                            Colors.white70
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight)):
                  Expanded(
                    child: SmartRefresher(
                      enablePullDown: false,
                      enablePullUp: true,
                      controller: _refreshController,
                      onLoading: () async {
                        if (_roomController.roomsCurrentPage.value<_roomController.roomsLastPage.value) {
                            await _roomController.getPaginationRooms();

                          setState(() {});
                        }
                        _refreshController.loadComplete();
                      },
                      child:
                      _roomController.roomsList.isNotEmpty ?
                      ReorderableListView.builder(
                        // reOrderable
                        physics: BouncingScrollPhysics(),
                        scrollDirection:Axis.vertical,
                        // isPortrait ? Axis.horizontal : Axis.vertical,
                        itemCount: _roomController.roomsList.length,
                        onReorder: (int oldIndex, int newIndex) {
                          setState(() {
                            if (newIndex > oldIndex) {
                              newIndex -= 1;
                            }
                            // bordy
                            // selectedBoard=newIndex;
                            int myId= _roomController.roomsList[_roomController.roomIndexForSelectedRoom.value].id;
                            final RoomsModel item = _roomController.roomsList.removeAt(oldIndex);
                            _roomController.roomsList.insert(newIndex, item);
                            _roomController.roomIndexForSelectedRoom.value= _roomController.roomsList.indexWhere((e)=>e.id==myId);
                            print(oldIndex);
                            print(newIndex);

                            if(oldIndex>newIndex){
                              print(_roomController.roomsList[newIndex].id);
                              print(_roomController.roomsList[newIndex+1].id);
                              _roomController.swapRooms(_roomController.roomsList[newIndex].id, _roomController.roomsList[newIndex+1].id);
                            }else{
                              print(_roomController.roomsList[newIndex-1].id);
                              print(_roomController.roomsList[newIndex].id);
                              _roomController.swapRooms(_roomController.roomsList[newIndex].id, _roomController.roomsList[newIndex-1].id);

                            }
                           // setState(() {
                           //
                           // });

                          });
                        },
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            key: ValueKey(_roomController.roomsList[index]),
                            onTap: () {
                              setState(() {
                                // specific room
                                selectedDate=null;
                                _generalController.updateDateForHome("");
                                _roomController.updateDateAfterFiltering('');
                                _roomController.roomIndexForSelectedRoom.value = index;
                                _generalController.updateRoomIndexForResetATTwelveAM(index);
                                _roomController.updateRoomId(_roomController.roomsList[index].id.toString());
                                _roomController.getRoomData(_roomController.roomsList[index].id.toString(),'Haider');
                                print(_roomController.roomIndexForSelectedRoom.value);
                                print(index);

                                // customDialogTextField(context, isPortrait? 30.w : 60.w,"Create New Room", "Create", (){},);
                              });
                            },
                            child: RoomTile(
                              onTapEnterRoomAdminMode:(){
                                selectedDate=null;
                                _generalController.updateDateForHome("");
                                _roomController.updateDateAfterFiltering('');
                                _roomController.roomIndexForSelectedRoom.value = index;
                                Get.back();
                                print("Enter room in admin mode");
                                _authController.updateIsAdminView(true);
                                // set room index to select the highlight the color of room tile if staff view implemented and restarted the app
                                _authPreference.setRoomIndex(index.toString());

                                _roomController.updateRoomIndex(index);
                                // _authPreference.setRoomId(_roomController.roomsList[index].id.toString());
                                // _authPreference.setStaffView('1');
                                _authPreference.setRoomName(_roomController.roomsList[index].name.toString());
                                _authPreference.setRoomId(_roomController.roomsList[index].id.toString());
                                _roomController.updateRoomId(_roomController.roomsList[index].id.toString());
                                print(_roomController.roomsList[index].id.toString());
                                Get.offAll(() => ShowCaseRoom(initialTitle: _roomController.roomsList[index].name.toString(),
                                  isNewCreated: false, isEditRoom: true,roomId: _roomController.roomsList[index].id.toString(),));

                              },
                              onTapEnterRoom: (){
                                selectedDate=null;

                                _generalController.updateDateForHome("");
                                _roomController.updateDateAfterFiltering('');
                                Get.back();
                                print("Enter room");
                                  _roomController.roomIndexForSelectedRoom.value = index;
                                _authController.updateIsAdminView(false);
                            _authPreference.setRoomId(_roomController.roomsList[index].id.toString());
                            // set room index to select the highlight the color of room tile if staff view implemented and restarted the app
                            _authPreference.setRoomIndex(index.toString());
                            _authPreference.setStaffView('1');

                                _authPreference.setRoomName(_roomController.roomsList[index].name.toString());
                                _roomController.updateRoomId(_roomController.roomsList[index].id.toString());
                                print(_roomController.roomsList[index].id.toString());
                                Get.offAll(() => ShowCaseRoom(initialTitle: _roomController.roomsList[index].name.toString(),
                                  isNewCreated: false, isEditRoom: true,roomId: _roomController.roomsList[index].id.toString(),));
                                // Get.offAll(()=> RoomScreen(initialTitle: "Room 1", isEditRoom: false,), transition: Transition.rightToLeft);
                              },
                              onTapEditRoom: (){

                                Get.back();
                                print("Edit room");
                                roomNameController.text= _roomController.roomsList[index].name;
                                customDialogTextField(context,"Edit Room Name", "Save", "Enter Room Name", (){
                                  if(_roomController.roomKey.currentState!.validate()){
                                    _roomController.editRoom(roomNameController.text.toString(), _roomController.roomsList[index].id.toString()).whenComplete((){
                                      setState(() {
                                        _roomController.roomsList[index].name=roomNameController.text;
                                      });
                                    });
                                  }
                                    // if(roomNameController.text.toString().isEmpty){
                                    //   CustomDialog.showErrorDialog(description: "Please Enter Room name");
                                    //
                                    // }else{
                                    //   _roomController.editRoom(roomNameController.text.toString(), _roomController.roomsList[index].id.toString()).whenComplete((){
                                    //     setState(() {
                                    //       _roomController.roomsList[index].name=roomNameController.text;
                                    //     });
                                    //   });
                                    // }


                                }, roomNameController,FocusNode());

                                // Get.to(()=> RoomScreen(initialTitle: "Room 1", isEditRoom: true,), transition: Transition.rightToLeft);
                              },
                              onTapDeleteRoom: (){
                                Get.back();
                                showCustomDialog(context, "assets/images/popup/ask.png", "Are You Sure?", "Are you sure that you want to remove this room from the list?", "Yes, Remove", (){
                                  // _roomController.deleteRoom("10");
                                  selectedDate=null;
                                  _generalController.updateDateForHome("");

                                  _roomController.deleteRoom(_roomController.roomsList[index].id.toString()).whenComplete((){
                                    _roomController.roomsList.removeAt(index);
                                    setState(() {
                                      if(_roomController.roomIndexForSelectedRoom.value == index){
                                        selectedDate=null;
                                        _generalController.updateDateForHome("");
                                        _roomController.updateDateAfterFiltering('');
                                        _roomController.roomIndexForSelectedRoom.value = 0;
                                        _roomController.updateRoomId(_roomController.roomsList[0].id.toString());
                                        _roomController.getRoomData(_roomController.roomsList[0].id.toString(),'Haider');
                                        print(_roomController.roomIndexForSelectedRoom.value);
                                        print(index);
                                      }
                                    });
                                  });


                                  // Get.back();
                                }, null);
                              },


                              roomName: _roomController.roomsList[index].name.toString(),
                              isSelected: _roomController.roomIndexForSelectedRoom.value == index,
                            ),
                          );
                        },
                      ):Center(
                        child: Text("No Rooms Created")
                      ),
                    ),

                  ),
                  isPortrait? SizedBox.shrink() : Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 30),
                    child: SizedBox(
                      height: 65,
                      child: CustomButton(
                        onTap: () {
                          roomNameController.clear();
                          customDialogTextField(context,"Create New Room", "Create", "Enter Room Name", (){

                            if(_roomController.roomKey.currentState!.validate()){
                              _roomController.createRoom(roomNameController.text.toString());
                            }
                            // Get.to(()=> RoomScreen(initialTitle: "Room Title", isNewCreated: true,));
                          }, roomNameController,FocusNode());
                        },
                        buttonText: "Create New Room",
                      ),
                    ),
                  )
                ],
              ),


        );

  }
  Future<void> showConfirmationDialogForPendingTask(bool newValue,String taskId,String taskStatus) async {
    final GlobalKey<FormState> _changeStatusKeyHome = GlobalKey<FormState>();
    TextEditingController memberController=TextEditingController();
    FocusNode focusNode=FocusNode();
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
                  key: _changeStatusKeyHome,
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
                              if(_changeStatusKeyHome.currentState!.validate()){
                                _roomController.changeTaskStatus(taskId, taskStatus=='0'?'1':'0', memberController.text.toString());
                                Get.back();
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
  Future<void> showConfirmationDialog(bool newValue,String taskId,String taskStatus,String member) async {
    TextEditingController memberController=TextEditingController();
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
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
                            if(memberController.text.toString().isEmpty){
                              // _roomController.changeTaskStatus(taskId, taskStatus=='0'?'1':'0', memberController.text.toString());
                              Get.back();
                            }
                            if(memberController.text.toString()!=member && memberController.text.toString().isNotEmpty){
                              Get.back();
                              // Future.delayed(Duration(seconds: 1), () {
                              //   Get.snackbar(
                              //     'Completed Task',
                              //     'Task status can not be changed by you.',
                              //     snackPosition: SnackPosition.TOP,
                              //     backgroundColor: Color(0xffF7941D), // Background color
                              //     colorText: Colors.black, // Text color for better visibility
                              //   );
                              // });
                            }
                            else{
                              _roomController.changeTaskStatus(taskId, taskStatus=='0'?'1':'0', memberController.text.toString());
                              Get.back();
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
        );
      },
    );
  }
  Future<void> showConfirmationDialogDeleteNotification(String notificationId) async {
    TextEditingController memberController=TextEditingController();
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
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
        );
      },
    );
  }


}



// Padding(
// padding: EdgeInsets.symmetric(horizontal: isPortrait ? 8.0 : 10),
// child: SizedBox(
// height: 65,
// child: CustomButton(
// onTap: () {
//
// customDialogTextField(context,"Create New Room", "Create", "Enter Room Name", (){
// if(_roomController.roomKey.currentState!.validate()){
// _roomController.createRoom(roomNameController.text.toString());
// }
// // Get.to(()=> RoomScreen(initialTitle: "Room Title", isNewCreated: true,));
// }, roomNameController,FocusNode());
// },
// buttonText: "Create New Room",
// ),
// ),
// )