import 'package:attendencemeter/src/database/database.dart';
import 'package:attendencemeter/src/models/course.dart';
import 'package:flutter/material.dart';

class PreviousCoursePage extends StatefulWidget {
  String m;
  List<Course> courses;
  Course c;
  PreviousCoursePage(this.m, this.courses, this.c);
  @override
  State<StatefulWidget> createState() {
    return PreviousCoursePageState(m, courses, c);
  }
}

class PreviousCoursePageState extends State<PreviousCoursePage> {
  String m;
  Course c;
  List<Course> courses;
  PreviousCoursePageState(this.m, this.courses, this.c);
  List<int> selectedId = List();
  List<Widget> studentTiles = List();
  DatabaseClass dc = new DatabaseClass();
  List<bool> isChecked = List(1000000);
  @override
  void initState() {
    setState(() {
      super.initState();
    });
  }

  Widget _buildCheckboxGroups(BuildContext context) {
    List<Widget> childrens = List.generate(courses.length, (index) {
      return Card(
          shape: RoundedRectangleBorder(
            //side: BorderSide(color: Colors.white70, width: 1),
            borderRadius: BorderRadius.circular(15),
          ),
          color: Colors.grey,
          elevation: 5,
          margin: EdgeInsets.all(10),
          child: CheckboxListTile(
            title: Text(
              courses[index].courseName,
              style: TextStyle(
                  fontFamily: "ProximaNova",
                  fontSize: 24,
                  fontWeight: FontWeight.w600),
            ),
            value: selectedId.contains(courses[index].id),
            onChanged: (bool val) {
              setState(() {
                if (val && !selectedId.contains(courses[index].id)) {
                  selectedId.add(courses[index].id);
                } else if (!val) {
                  selectedId.remove(courses[index].id);
                }
              });
            },
          ));
    });

    return Container(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: childrens,
    ));
  }

  void selectall() {
    setState(() {
      if (selectedId.length != courses.length) {
        selectedId.clear();
        for (int i = 0; i < courses.length; i++) {
          selectedId.add(courses[i].id);
        }
      } else {
        selectedId.clear();
      }
    });
  }

  Widget floating() {
    if (selectedId.length == courses.length) {
      return FloatingActionButton.extended(
        onPressed: () {
          selectall();
        },
        label: Text(
          'DeSelect All Course',
        ),
        icon: Icon(Icons.close),
        backgroundColor: Color.fromRGBO(220, 20, 60, 0.8),
      );
      ;
    } else {
      return FloatingActionButton.extended(
        onPressed: () {
          selectall();
        },
        label: Text(
          'Select All Course',
        ),
        icon: Icon(Icons.check),
        backgroundColor: Color.fromRGBO(80, 200, 10, 0.7),
      );
    }
  }

  void addStudent() {
    for (int i = 0; i < courses.length; i++) {
      if (selectedId.contains(courses[i].id)) {
        for (int j = 0; j < courses[i].studentId.toBuilder().length; j++) {
          if (!c.studentId.contains(courses[i].studentId.toBuilder()[j])) {
            c.addStudentId(courses[i].studentId.toBuilder()[j]);
          }
        }
      }
    }
    dc.updateCourse(c);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.lightGreen,
          title: Text(
            'Import Students',
            style: TextStyle(
                fontFamily: "ProximaNova",
                fontSize: 24,
                fontWeight: FontWeight.w600),
          ),
          //ctions: <Widget>[floating()],
        ),

        //backgroundColor: Colors.transparent,
        body: _buildCheckboxGroups(context),
        floatingActionButton: Wrap(
          spacing: 10,
          children: <Widget>[
            floating(),
            FloatingActionButton.extended(
              heroTag: "addStudent",
              onPressed: () {
                addStudent();
                Navigator.of(context).pop();
              },
              label: Text(
                'Import',
              ),
              icon: Icon(Icons.file_download),
              backgroundColor: Color.fromRGBO(80, 200, 10, 0.7),
            )
          ],
        ));
  }
}
