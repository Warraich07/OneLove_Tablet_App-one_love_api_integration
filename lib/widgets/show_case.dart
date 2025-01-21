import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

import '../views/home/home_screen.dart';
import '../views/home/room_screen.dart';

class ShowCaseRoom extends StatefulWidget {
  final bool isNewCreated;
  final bool isEditRoom;
  final String initialTitle;
  final String? roomId;
  final String? userName;
  const ShowCaseRoom({Key? key, required this.isNewCreated, required this.isEditRoom, required this.initialTitle, this.roomId, this.userName, }) : super(key: key);

  @override
  State<ShowCaseRoom> createState() => _ShowCaseRoomState();
}

class _ShowCaseRoomState extends State<ShowCaseRoom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ShowCaseWidget(
          builder: (context) => RoomScreen(initialTitle: widget.initialTitle, isNewCreated: widget.isNewCreated, isEditRoom: widget.isEditRoom,roomId: widget.roomId,)));
  }
}