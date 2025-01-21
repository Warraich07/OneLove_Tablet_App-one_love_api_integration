import 'package:flutter/material.dart';

import '../constants/global_variables.dart';

class StatusTag extends StatefulWidget {
  final Color circleColor;
  final String title;
  final VoidCallback? onPressed;

  const StatusTag({
    Key? key,
    required this.circleColor,
    required this.title,
    this.onPressed,
  }) : super(key: key);

  @override
  State<StatusTag> createState() => _StatusTagState();
}

class _StatusTagState extends State<StatusTag> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed ?? () {},
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 8,
            width: 8,
            decoration: BoxDecoration(
              color: widget.circleColor,
              borderRadius: BorderRadius.circular(100.0),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Flexible(
            child: Text(
              widget.title,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryColor,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}