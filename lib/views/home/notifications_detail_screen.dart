import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../constants/global_variables.dart';

class NotificationDetailScreen extends StatelessWidget {
  const NotificationDetailScreen({
    super.key,
    required this.notificationTitle,
    required this.notificationMessage,
    required this.userName,
  });

  final String notificationTitle;
  final String notificationMessage;
  final String userName;

  @override
  Widget build(BuildContext context) {
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Notification Details",style: headingSmall,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Container(
                    height: 40,
                    width: 40,
                    child: CachedNetworkImage(imageUrl: "_authController.userData.value!.data.userImage.toString()",
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
                SizedBox(width: 10),
              ],
            ),
          ],
        ),

      ),
      body: Center(
        child: Column(
          mainAxisAlignment:MainAxisAlignment.start,
          children: [
            SizedBox(height:isPortrait?30.h:100,),
            Image.asset("assets/icons/report_ico.png",scale: 4,),
            SizedBox(height: 28,),
            SizedBox(
              width: 90.w,
              // height: 600,// Set the width of the card
              child: Card(
                elevation: 4.0, // Adds shadow to the card
                margin: EdgeInsets.all(16.0), // Adds margin around the card
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0), // Rounded corners
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0), // Adds padding inside the card
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Adjust the height to fit content
                    crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Problem Report",
                            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            width: 35,
                            height: 35, // Ensures the circle has a fixed height
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black12,
                            ),
                            child: Center(
                              child: Image.asset(
                                "assets/icons/user_icon.png",
                                scale: 4,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            userName,
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        notificationTitle,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        notificationMessage,
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
