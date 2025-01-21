// import 'package:one_love/widgets/status_tag.dart';
// import 'package:flutter/material.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'package:zoom_tap_animation/zoom_tap_animation.dart';
//
// import '../constants/global_variables.dart';
// import '../models/calender_model.dart';
//
// class CalenderWidget extends StatefulWidget {
//   DateTime selectedDayDate;
//   List<EventModel> events = [];
//   Function(DateTime day, DateTime focusedDay) onTheDaySelected;
//   bool? isWeeklyCalender;
//
//   CalenderWidget({
//     Key? key,
//     required this.selectedDayDate,
//     required this.events,
//     required this.onTheDaySelected,
//     this.isWeeklyCalender,
//   }) : super(key: key);
//
//   @override
//   State<CalenderWidget> createState() => _CalenderWidgetState();
// }
//
// class _CalenderWidgetState extends State<CalenderWidget> {
//   DateTime firstDayDate = DateTime.utc(2000, 12, 18);
//   DateTime lastDayDate = DateTime.utc(2090, 12, 18);
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }
//
//   @override
//   void didUpdateWidget(CalenderWidget oldWidget) {
//     setState(() {});
//     super.didUpdateWidget(oldWidget);
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return (widget.isWeeklyCalender ?? false)
//         ? Container(
//       child: TableCalendar(
//         locale: "en_US",
//         rowHeight: 45,
//         headerStyle: HeaderStyle(
//           formatButtonVisible: false,
//           titleCentered: true,
//           titleTextStyle: headingSmall
//         ),
//         availableGestures: AvailableGestures.horizontalSwipe,
//         selectedDayPredicate: (day) {
//           return isSameDay(day, widget.selectedDayDate);
//         },
//         focusedDay: widget.selectedDayDate,
//         firstDay: firstDayDate,
//         lastDay: lastDayDate,
//         onDaySelected: widget.onTheDaySelected,
//         calendarFormat: CalendarFormat.week,
//         calendarStyle: CalendarStyle(
//           // Use `CalendarStyle` to customize the UI
//           outsideDaysVisible: true,
//           isTodayHighlighted: false,
//           selectedDecoration: BoxDecoration(
//             // borderRadius: BorderRadius.circular(100.0),
//             color: AppColors.buttonColor,
//             shape: BoxShape.circle, // You can change the shape if needed
//           ),
//         ),
//         eventLoader: (date) {
//           return widget.events
//               .where((event) => isSameDay(event.date, date))
//               .map((event) => event.title)
//               .toList();
//         },
//         calendarBuilders: CalendarBuilders(
//           markerBuilder: (context, date, events) {
//             // Customize day appearance based on events
//             if (events.isNotEmpty) {
//               // Check for different events and assign border color
//               if (events.contains("upcoming")) {
//                 return ZoomTapAnimation(
//                   child: Container(
//                     margin: EdgeInsets.all(4),
//                     decoration: BoxDecoration(
//                       border: Border.all(
//                           color: AppColors.buttonColor, width: 1.5),
//                       borderRadius: BorderRadius.circular(100.0),
//                     ),
//                     child: Center(
//                       child: Text(
//                         date.day.toString(),
//                         style:bodySmall.copyWith(color: Colors.white)
//                       ),
//                     ),
//                   ),
//                 );
//               } else if (events.contains("completed")) {
//                 return ZoomTapAnimation(
//                   child: Container(
//                     margin: EdgeInsets.all(4),
//                     decoration: BoxDecoration(
//                       border: Border.all(
//                           color: AppColors.primaryColor, width: 1.5),
//                       borderRadius: BorderRadius.circular(100.0),
//                     ),
//                     child: Center(
//                       child: Text(
//                         date.day.toString(),
//                         style: bodySmall.copyWith(color: Colors.white)
//                       ),
//                     ),
//                   ),
//                 );
//               } else if (events.contains("cancelled")) {
//                 return ZoomTapAnimation(
//                   child: Container(
//                     margin: EdgeInsets.all(4),
//                     decoration: BoxDecoration(
//                       color: AppColors.buttonColor,
//                       borderRadius: BorderRadius.circular(100.0),
//                     ),
//                     child: Center(
//                       child: Text(
//                         date.day.toString(),
//                         style: bodySmall.copyWith(color: Colors.white)
//                       ),
//                     ),
//                   ),
//                 );
//               } else {
//                 return Container(
//                   margin: EdgeInsets.all(4),
//                   decoration: BoxDecoration(
//                     color: Colors.transparent,
//                     borderRadius: BorderRadius.circular(100.0),
//                   ),
//                   child: Center(
//                     child: Text(
//                       date.day.toString(),
//                       style: bodySmall.copyWith(color: Colors.black)
//                     ),
//                   ),
//                 );
//               }
//             }
//             return null; // Return null for default day appearance
//           },
//           selectedBuilder: (context, date, events) {
//             return ZoomTapAnimation(
//               child: Container(
//                 margin: EdgeInsets.all(4),
//                 decoration: BoxDecoration(
//                     border: Border.all(
//                         color: AppColors.buttonColor, width: 1.5),
//                     borderRadius: BorderRadius.circular(100.0),
//                     color: AppColors.buttonColor),
//                 child: Center(
//                   child: Text(
//                     date.day.toString(),
//                     style: bodyMedium.copyWith(color: Colors.white)
//                   ),
//                 ),
//               ),
//             ); // Return null for default day appearance
//           },
//         ),
//       ),
//     )
//         : Container(
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: Colors.transparent,
//         // borderRadius: BorderRadius.circular(10.0),
//       ),
//       child: Column(
//         children: <Widget>[
//           Container(
//             child: TableCalendar(
//               locale: "en_US",
//               rowHeight: 45,
//               headerStyle: HeaderStyle(
//                 formatButtonVisible: false,
//                 titleCentered: true,
//                 titleTextStyle: TextStyle(
//                   fontWeight: FontWeight.w600,
//                   fontSize: 16,
//                 ),
//               ),
//               availableGestures: AvailableGestures.horizontalSwipe,
//               selectedDayPredicate: (day) {
//                 return isSameDay(day, widget.selectedDayDate);
//               },
//               focusedDay: widget.selectedDayDate,
//               firstDay: firstDayDate,
//               lastDay: lastDayDate,
//               onDaySelected: widget.onTheDaySelected,
//               calendarStyle: CalendarStyle(
//                 // Use `CalendarStyle` to customize the UI
//                 outsideDaysVisible: true,
//                 isTodayHighlighted: false,
//                 selectedDecoration: BoxDecoration(
//                   // borderRadius: BorderRadius.circular(100.0),
//                   color: AppColors.buttonColor,
//                   shape: BoxShape
//                       .circle, // You can change the shape if needed
//                 ),
//               ),
//               eventLoader: (date) {
//                 return widget.events
//                     .where((event) => isSameDay(event.date, date))
//                     .map((event) => event.title)
//                     .toList();
//               },
//               calendarBuilders: CalendarBuilders(
//                 markerBuilder: (context, date, events) {
//                   // Customize day appearance based on events
//                   if (events.isNotEmpty) {
//                     // Check for different events and assign border color
//                     if (events.contains("upcoming")) {
//                       return ZoomTapAnimation(
//                         child: Container(
//                           margin: EdgeInsets.all(4),
//                           decoration: BoxDecoration(
//                             border: Border.all(
//                                 color: AppColors.buttonColor,
//                                 width: 1.5),
//                             borderRadius: BorderRadius.circular(100.0),
//                           ),
//                           child: Center(
//                             child: Text(
//                               date.day.toString(),
//                               style: TextStyle(
//                                 color: AppColors.buttonColor,
//                               ),
//                             ),
//                           ),
//                         ),
//                       );
//                     } else if (events.contains("completed")) {
//                       return ZoomTapAnimation(
//                         child: Container(
//                           margin: EdgeInsets.all(4),
//                           decoration: BoxDecoration(
//                             border: Border.all(
//                                 color: AppColors.primaryColor,
//                                 width: 1.5),
//                             borderRadius: BorderRadius.circular(100.0),
//                           ),
//                           child: Center(
//                             child: Text(
//                               date.day.toString(),
//                               style: TextStyle(
//                                 color: AppColors.primaryColor,
//                               ),
//                             ),
//                           ),
//                         ),
//                       );
//                     } else if (events.contains("cancelled")) {
//                       return ZoomTapAnimation(
//                         child: Container(
//                           margin: EdgeInsets.all(4),
//                           decoration: BoxDecoration(
//                             color: AppColors.primaryColor,
//                             borderRadius: BorderRadius.circular(100.0),
//                           ),
//                           child: Center(
//                             child: Text(
//                               date.day.toString(),
//                               style: TextStyle(
//                                 color: AppColors.primaryColor,
//                               ),
//                             ),
//                           ),
//                         ),
//                       );
//                     } else {
//                       return Container(
//                         margin: EdgeInsets.all(4),
//                         decoration: BoxDecoration(
//                           color: Colors.transparent,
//                           borderRadius: BorderRadius.circular(100.0),
//                         ),
//                         child: Center(
//                           child: Text(
//                             date.day.toString(),
//                             style: TextStyle(
//                               color: AppColors.primaryColor,
//                             ),
//                           ),
//                         ),
//                       );
//                     }
//                   }
//                   return null; // Return null for default day appearance
//                 },
//                 selectedBuilder: (context, date, events) {
//                   return Container(
//                     margin: EdgeInsets.all(4),
//                     decoration: BoxDecoration(
//                       color: Colors.transparent,
//                       borderRadius: BorderRadius.circular(100.0),
//                     ),
//                     child: Center(
//                       child: Text(
//                         date.day.toString(),
//                         style: TextStyle(
//                           color: AppColors.buttonColor,
//                         ),
//                       ),
//                     ),
//                   ); // Return null for default day appearance
//                 },
//               ),
//             ),
//           ),
//           Container(
//             margin: EdgeInsets.fromLTRB(15, 5, 15, 20),
//             child: Align(
//               alignment: Alignment.centerLeft,
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: <Widget>[
//                   Flexible(
//                     child: StatusTag(
//                       circleColor: AppColors.primaryColor,
//                       title: "Upcoming",
//                     ),
//                   ),
//                   SizedBox(
//                     width: 10,
//                   ),
//                   Flexible(
//                     child: StatusTag(
//                       circleColor: AppColors.primaryColor,
//                       title: "Completed",
//                     ),
//                   ),
//                   SizedBox(
//                     width: 10,
//                   ),
//                   Flexible(
//                     child: StatusTag(
//                       circleColor: AppColors.buttonColor,
//                       title: "Cancelled",
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }