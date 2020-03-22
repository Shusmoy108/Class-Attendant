import 'package:attendencemeter/src/database/database.dart';
import 'package:attendencemeter/src/models/course.dart';
import 'package:attendencemeter/src/models/student.dart';
import 'package:attendencemeter/src/pages/course/importfromcourse.dart';
import 'package:attendencemeter/src/pages/student/previousstudentcart.dart';
import 'package:attendencemeter/src/pages/student/studentpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:unicorndial/unicorndial.dart';

class CustomFAButton extends StatelessWidget {
  int courseId;
  Course c;
  CustomFAButton(this.courseId, this.c);
  TextEditingController namecontroller = new TextEditingController();
  TextEditingController idcontroller = new TextEditingController();
  List<int> selectedId = List();
  void _showDialog(context) {
    final _formKey = GlobalKey<FormState>();
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
                content: Form(
                  key: _formKey,
                  child: Wrap(
                    direction: Axis.horizontal,
                    children: <Widget>[
                      TextFormField(
                        controller: idcontroller,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          WhitelistingTextInputFormatter.digitsOnly
                        ],
                        decoration:
                            new InputDecoration(labelText: 'Student ID'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a student id';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: namecontroller,
                        decoration: new InputDecoration(
                            labelText: 'Student Name',
                            hintText: 'eg. John Smith'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a student name';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  // usually buttons at the bottom of the dialog
                  new FlatButton(
                    child: new Text("Submit"),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        DatabaseClass dc = new DatabaseClass();
                        Student student = new Student(
                            int.parse(idcontroller.text), namecontroller.text);
                        if (courseId != -1) {
                          student.addcourse(c.id);
                          await dc.saveStudent(student);
                          dc.updateCourseafterStudentAdd(c, student);
                        } else {
                          dc.saveStudent(student);
                        }
                        namecontroller.clear();
                        idcontroller.clear();
                        Navigator.of(context).pop();
                        var router = new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                new StudentPage.course(c, courseId));
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

  void _showDialog2(context) async {
    List<Student> students = new List();
    DatabaseClass dc = new DatabaseClass();
    final stuts = await dc.getstudents();
    students = stuts;
    var router = new MaterialPageRoute(
        builder: (BuildContext context) =>
            new PreviousStudentPage("", students, c));
    Navigator.of(context).push(router);
  }

  void _showDialog3(context) async {
    List<Course> courses = new List();
    DatabaseClass dc = new DatabaseClass();
    final stuts = await dc.getcourses();
    courses = stuts;
    var router = new MaterialPageRoute(
        builder: (BuildContext context) =>
            new PreviousCoursePage("", courses, c));
    Navigator.of(context).push(router);
  }

  Widget student(Student student, context) {
    return ListTile(
      title: Text(student.name),
      leading: Text(student.studentId.toString()),
      trailing: Checkbox(
          value: selectedId.contains(student.id),
          onChanged: (bool newValue) {
            if (newValue) {
              Navigator.of(context).pop();
              _showDialog2(context);
              selectedId.add(student.id);
            } else {
              Navigator.of(context).pop();
              _showDialog2(context);
              selectedId.remove(student.id);
            }
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    var childButtons = List<UnicornButton>();

    childButtons.add(
      UnicornButton(
        hasLabel: true,
        labelText: "Add New Student",
        currentButton: FloatingActionButton(
          heroTag: "newStudent",
          backgroundColor: Colors.redAccent,
          mini: true,
          child: Text('N'),
          onPressed: () {
            _showDialog(context);
          },
        ),
      ),
    );

    childButtons.add(
      UnicornButton(
        hasLabel: true,
        labelText: "Add Previous Student",
        currentButton: FloatingActionButton(
          heroTag: "prevStudent",
          backgroundColor: Colors.greenAccent,
          mini: true,
          child: Text('P'),
          onPressed: () {
            _showDialog2(context);
            //fabAction(43.81, 100.41);
          },
        ),
      ),
    );

    childButtons.add(
      UnicornButton(
        hasLabel: true,
        labelText: "Import Students From Course",
        currentButton: FloatingActionButton(
          heroTag: "courseStudent",
          backgroundColor: Colors.blueAccent,
          mini: true,
          child: Text('C'),
          onPressed: () {
            _showDialog3(context);
            // fabAction(10.81, 70.41);
          },
        ),
      ),
    );

    return UnicornDialer(
      //backgroundColor: Color.fromRGBO(255, 255, 255, 0.6),
      parentButtonBackground: Colors.redAccent,
      orientation: UnicornOrientation.VERTICAL,
      parentButton: Icon(
        Icons.add,
      ),
      childButtons: childButtons,
    );
  }
}
