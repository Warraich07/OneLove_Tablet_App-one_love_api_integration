import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:one_love/constants/global_variables.dart';
import 'package:sizer/sizer.dart';

import '../views/home/room_screen.dart';
import 'custom_dialog.dart';

class RoomTile extends StatelessWidget {
  final String roomName;
  final bool isSelected;

  void Function()? onTapEditRoom;
  void Function()? onTapEnterRoom;
  void Function()? onTapEnterRoomAdminMode;
  void Function()? onTapDeleteRoom;

  RoomTile({required this.roomName, required this.isSelected,this.onTapEnterRoom,this.onTapDeleteRoom,this.onTapEditRoom,this.onTapEnterRoomAdminMode});

  @override
  Widget build(BuildContext context) {
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: isPortrait?5:10, vertical: 5),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primaryColor : Colors.transparent,
        border: Border.all(color: isSelected ? AppColors.primaryColor : Colors.black26, width: 1.3),
        borderRadius: BorderRadius.circular(10)
      ),
      child: ListTile(
        contentPadding: EdgeInsets.only(left: 18,top:isPortrait?3: 3,bottom: 3),
        title: Text(roomName, style: bodyMedium.copyWith(fontSize: 17),maxLines: 2,),
        trailing: PopupMenuButton<String>(
          // style: ButtonStyle(
          //   backgroundColor: WidgetStatePr
          // ),
          constraints: BoxConstraints(
            maxWidth: 250
          ),
          iconColor: Colors.black,

          // position:PopupMenuPosition.,
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
          onSelected: (value) {
            switch (value) {
              case 'enter':
                break;
              case 'enterAdmin':
                break;
              case 'edit':
                break;
              case 'remove':
                break;
            }
          },
          offset: Offset(isPortrait?0: -130,40),
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(
                value: 'enter',
                child: GestureDetector(
                    onTap: onTapEnterRoom,
                    child: Text('Enter the Room (Staff Mode)', style: bodyMedium.copyWith(fontSize: 15),)),
              ),
              PopupMenuItem(
                // onTap: onTap(),
                value: 'enterAdmin',
                child: GestureDetector(
                    onTap: onTapEnterRoomAdminMode,
                    child: Text('Edit Room (Admin Mode)', style: bodyMedium.copyWith(fontSize: 15),)),
              ),
              PopupMenuItem(
                onTap: onTapDeleteRoom,
                value: 'remove',
                child: Text('Remove Room', style: bodyMedium.copyWith(fontSize: 15),),
              ),
              PopupMenuItem(
                // onTap: onTap(),
                value: 'edit',
                child: GestureDetector(
                    onTap: onTapEditRoom,
                    child: Text('Rename Room', style: bodyMedium.copyWith(fontSize: 15),)),
              ),

            ];
          },
        ),
      ),
    );
  }
}
