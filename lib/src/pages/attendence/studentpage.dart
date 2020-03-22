import 'package:attendencemeter/src/database/database.dart';
import 'package:attendencemeter/src/models/attendence.dart';
import 'package:attendencemeter/src/models/student.dart';
import 'package:flutter/material.dart';

class AttendenceStudentPage extends StatefulWidget {
  String m;
  List<Student> students;
  Attendence a;
  AttendenceStudentPage(this.m, this.students, this.a);
  @override
  State<StatefulWidget> createState() {
    return AttendenceStudentPageState(m, students, a);
  }
}

class AttendenceStudentPageState extends State<AttendenceStudentPage> {
  String m;
  Attendence a;
  List<Student> students;
  AttendenceStudentPageState(this.m, this.students, this.a);
  List<int> selectedId = List();
  List<Widget> studentTiles = List();
  DatabaseClass dc = new DatabaseClass();
  List<bool> isChecked = List(1000000);
  @override
  void initState() {
    setState(() {
      super.initState();
      selectedId = a.presentId.toList();
    });
  }

  Widget _buildCheckboxGroups(BuildContext context) {
    List<Widget> childrens = List.generate(students.length, (index) {
      return Card(
          shape: RoundedRectangleBorder(
            //side: BorderSide(width: 1),
            borderRadius: BorderRadius.circular(15),
          ),
          color: Colors.grey,
          elevation: 5,
          margin: EdgeInsets.all(10),
          child: CheckboxListTile(
            title: Text(
              "Student ID/Roll : " + students[index].studentId.toString(),
              style: TextStyle(
                  fontFamily: "ProximaNova",
                  fontSize: 20,
                  //color: Colors.amberAccent,
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
    var l = a.presentId.toBuilder()..clear();
    a.presentId = l.build();
    for (int i = 0; i < selectedId.length; i++) {
      if (!a.presentId.contains(selectedId[i])) {
        a.addStudentId(selectedId[i]);
      }
    }
    dc.updateAttendence(a);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.lightGreen,
              title: Text(
                'Attendence Sheet',
                style: TextStyle(
                    fontFamily: "ProximaNova",
                    fontSize: 20,
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
            )));
  }
}
