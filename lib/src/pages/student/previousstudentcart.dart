import 'package:attendencemeter/src/database/database.dart';
import 'package:attendencemeter/src/models/course.dart';
import 'package:attendencemeter/src/models/student.dart';
import 'package:flutter/material.dart';

class PreviousStudentPage extends StatefulWidget {
  String m;
  List<Student> students;
  Course c;
  PreviousStudentPage(this.m, this.students, this.c);
  @override
  State<StatefulWidget> createState() {
    return PreviousStudentPageState(m, students, c);
  }
}

class PreviousStudentPageState extends State<PreviousStudentPage> {
  String m;
  Course c;
  List<Student> students;
  PreviousStudentPageState(this.m, this.students, this.c);
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
    List<Widget> childrens = List.generate(students.length, (index) {
      return Card(
          shape: RoundedRectangleBorder(
            //side: BorderSide(color: Colors.white70, width: 1),
            borderRadius: BorderRadius.circular(15),
          ),
          margin: EdgeInsets.all(10),
          elevation: 5,
          color: Colors.grey,
          child: CheckboxListTile(
            title: Text(
              "Student ID/Roll : " + students[index].studentId,
              style: TextStyle(
                  fontFamily: "ProximaNova",
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              "Student Name : " + students[index].name,
              style: TextStyle(
                  fontFamily: "ProximaNova",
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            ),
            value: selectedId.contains(students[index].id),
            onChanged: (bool val) {
              setState(() {
                if (val && !selectedId.contains(students[index].id)) {
                  selectedId.add(students[index].id);
                } else if (!val) {
                  selectedId.remove(students[index].id);
                }
              });
            },
          ));
    });

    return Container(
        child: ListView(
      children: childrens,
    ));
  }

  void selectall() {
    setState(() {
      if (selectedId.length != students.length) {
        selectedId.clear();
        for (int i = 0; i < students.length; i++) {
          selectedId.add(students[i].id);
        }
      } else {
        selectedId.clear();
      }
    });
  }

  Widget floating() {
    if (selectedId.length == students.length) {
      return FloatingActionButton.extended(
        onPressed: () {
          selectall();
        },
        label: Text(
          'DeSelect All Student',
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
          'Select All Student',
        ),
        icon: Icon(Icons.check),
        backgroundColor: Color.fromRGBO(80, 200, 10, 0.7),
      );
    }
  }

  void addStudent() {
    for (int i = 0; i < selectedId.length; i++) {
      if (!c.studentId.contains(selectedId[i])) {
        c.addStudentId(selectedId[i]);
      }
    }
    dc.updateCourse(c);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightGreen,
          title: Text(
            'Previous Students',
            style: TextStyle(
                fontFamily: "ProximaNova",
                fontSize: 24,
                fontWeight: FontWeight.w600),
          ),
          //actions: <Widget>[floating()],
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
                'Save',
              ),
              icon: Icon(Icons.save),
              backgroundColor: Color.fromRGBO(80, 200, 10, 0.7),
            )
          ],
        ));
  }
}
