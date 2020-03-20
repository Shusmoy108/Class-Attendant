import 'package:attendencemeter/src/database/database.dart';
import 'package:attendencemeter/src/models/course.dart';
import 'package:attendencemeter/src/pages/course/coursecart.dart';
import 'package:attendencemeter/src/pages/statistics/statisticcart.dart';
import 'package:flutter/material.dart';

class StatisticPage extends StatefulWidget {
  String m;
  StatisticPage(this.m);
  @override
  State<StatefulWidget> createState() {
    return StatisticPageState(m);
  }
}

class StatisticPageState extends State<StatisticPage> {
  String m;
  StatisticPageState(this.m);
  Future<List<Course>> courses;
  DatabaseClass dc = new DatabaseClass();
  @override
  void initState() {
    setState(() {
      super.initState();
    });
  }

  Future<List<Course>> getcourses() async {
    return dc.getcourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.lightGreen,
        title: Text(
          'Statistics',
          style: TextStyle(
              fontFamily: "ProximaNova",
              fontSize: 24,
              fontWeight: FontWeight.w600),
        ),
      ),
      //backgroundColor: Colors.transparent,
      body: Container(
          //color: Color.fromRGBO(234, 239, 241, 1.0),
          //margin: EdgeInsets.all(10.0),
          child: FutureBuilder(
        future: getcourses(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Container(
              child: Center(
                child: Text("You have not added any Course"),
              ),
            );
          } else {
            return StatisticCart(snapshot.data);
          }
        },
      )),
    );
  }
}
