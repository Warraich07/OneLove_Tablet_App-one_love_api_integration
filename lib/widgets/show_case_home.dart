import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import '../views/home/home_screen.dart';

class ShowCaseHome extends StatefulWidget {

  const ShowCaseHome({Key? key}) : super(key: key);

  @override
  State<ShowCaseHome> createState() => _ShowCaseHomeState();
}

class _ShowCaseHomeState extends State<ShowCaseHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ShowCaseWidget(
            builder: (context) => HomeScreen()));
  }
}