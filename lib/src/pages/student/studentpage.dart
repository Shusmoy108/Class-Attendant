import 'package:attendencemeter/src/database/database.dart';
import 'package:attendencemeter/src/models/course.dart';
import 'package:attendencemeter/src/models/student.dart';
import 'package:attendencemeter/src/pages/student/studentaddbutton.dart';
import 'package:attendencemeter/src/pages/student/studentcart.dart';
import 'package:flutter/material.dart';

class StudentPage extends StatefulWidget {
  int courseId;
  Course c;
  StudentPage(this.courseId);
  StudentPage.course(this.c, this.courseId);
  @override
  State<StatefulWidget> createState() {
    if (courseId == -1) {
      return StudentPageState(courseId);
    } else {
      return StudentPageState.course(c, courseId);
    }
  }
}

class StudentPageState extends State<StudentPage> {
  int courseId;
  Course c;
  StudentPageState(this.courseId);
  StudentPageState.course(this.c, this.courseId);
  Future<List<Course>> courses;
  DatabaseClass dc = new DatabaseClass();
  @override
  void initState() {
    setState(() {
      super.initState();
    });
  }

  Future<List<Student>> getstudents() async {
    if (courseId == -1) {
      return dc.getstudents();
    } else {
      return dc.getcoursestudents(c);
    }
  }

  TextEditingController namecontroller = new TextEditingController();
  TextEditingController idcontroller = new TextEditingController();
  void _showDialog(context) {
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
          return Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                title: Text('Add Student'),
                content: SizedBox(
                  height: 150,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TextField(
                        controller: idcontroller,
                        decoration:
                            new InputDecoration(labelText: 'Student ID'),
                      ),
                      TextField(
                        controller: namecontroller,
                        decoration: new InputDecoration(
                            labelText: 'Student Name',
                            hintText: 'eg. John Smith'),
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  // usually buttons at the bottom of the dialog
                  new FlatButton(
                    child: new Text("Submit"),
                    onPressed: () async {
                      DatabaseClass dc = new DatabaseClass();
                      Student student =
                          new Student(idcontroller.text, namecontroller.text);
                      if (courseId != -1) {
                        await dc.saveStudent(student);
                        await dc.updateCourseafterStudentAdd(c, student);
                        namecontroller.clear();
                        idcontroller.clear();
                        var router = new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                new StudentPage.course(c, courseId));
                        Navigator.of(context).pushReplacement(router);
                      } else {
                        await dc.saveStudent(student);
                        namecontroller.clear();
                        idcontroller.clear();
                        Navigator.of(context).pop();
                        var router = new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                new StudentPage(courseId));
                        Navigator.of(context).pushReplacement(router);
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {});
  }

  Widget floating() {
    if (courseId != -1) {
      return CustomFAButton(courseId, c);
    } else {
      return FloatingActionButton.extended(
        onPressed: () {
          _showDialog(context);
        },
        label: Text(
          'Add Student',
        ),
        icon: Icon(Icons.add),
        backgroundColor: Color.fromRGBO(80, 200, 10, 0.7),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.lightGreen,
          title: Text(
            'Students',
            style: TextStyle(
                fontFamily: "ProximaNova",
                fontSize: 24,
                fontWeight: FontWeight.w600),
          ),
        ),
        //backgroundColor: Colors.transparent,
        body: Container(
            //color: Color.fromRGBO(66, 58, 18, 1),
            //color: Colors.black54,
            //color: Color.fromRGBO(234, 239, 241, 1.0),
            //margin: EdgeInsets.all(10.0),
            child: FutureBuilder(
          future: getstudents(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(
                child: Center(
                  child: Text("You have not added any students"),
                ),
              );
            } else {
              return StudentCart(snapshot.data, c, courseId);
            }
          },
        )),
        floatingActionButton: floating());
  }
}
