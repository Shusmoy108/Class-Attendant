import 'package:attendencemeter/src/models/course.dart';
import 'package:attendencemeter/src/models/student.dart';
import 'package:attendencemeter/src/pages/course/coursepage.dart';
import 'package:attendencemeter/src/pages/student/studentpage.dart';
import 'package:flutter/material.dart';
import 'package:attendencemeter/src/database/database.dart';
import 'package:flutter/services.dart';

class StudentCart extends StatelessWidget {
  List<Student> students;
  Course c;
  int courseId;
  StudentCart(this.students, this.c, this.courseId);
  DatabaseClass dc = new DatabaseClass();
  void _showAlert(index, context) {
    String text =
        "Are you sure you want to delete this student whose name is " +
            students[index].name +
            " and id is " +
            students[index].studentId.toString() +
            " ?";
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              shape:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
              title: new Text('Delete!'),
              content: new Text(
                text,
                style: new TextStyle(
                  fontFamily: "ProximaNova",
                  fontSize: 18,
                ),
              ),
              actions: <Widget>[
                new FlatButton(
                    onPressed: () async {
                      if (courseId == -1) {
                        await dc.deleteStudent(students[index]);
                        Navigator.of(context).pop();
                        var router = new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                new StudentPage(courseId));
                        Navigator.of(context).pushReplacement(router);
                      } else {
                        await dc.updateCourseafterStudentDelete(
                            courseId, students[index].id);
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        var router = new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                new CoursePage("m"));
                        Navigator.of(context).pushReplacement(router);
                      }

                      // _dialogueResult(MyDialogueAction.yes);
                    },
                    child: new Text('Yes')),
                new FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      //_dialogueResult(MyDialogueAction.no);
                    },
                    child: new Text('No')),
              ],
            ));
  }

  Widget buildProductItem(BuildContext context, int index) {
    return Card(
        shape: RoundedRectangleBorder(
          //side: BorderSide(color: Colors.white70, width: 1),
          borderRadius: BorderRadius.circular(15),
        ),
        color: Colors.grey,
        elevation: 5,
        margin: EdgeInsets.all(10),
        child: ListTile(
          leading: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Text(students[index].name.substring(0, 1).toUpperCase(),
                style: TextStyle(fontSize: 24, fontFamily: "ProximaNova")),
          ),
          title: Text(
              "Student Name: " +
                  '${students[index].name[0].toUpperCase()}${students[index].name.substring(1)}',
              style: TextStyle(
                fontFamily: "ProximaNova",
                fontSize: 20,
                //fontWeight: FontWeight.w600
              )),
          subtitle: Text("Student ID: " + students[index].studentId.toString(),
              style: TextStyle(
                  fontFamily: "ProximaNova",
                  fontSize: 20,
                  color: Colors.amber,
                  fontWeight: FontWeight.w600)),
          trailing: Wrap(
            spacing: 10, // space between two icons
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                    color: Colors.green,
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      namecontroller =
                          new TextEditingController(text: students[index].name);
                      idcontroller = new TextEditingController(
                          text: students[index].studentId.toString());
                      _showDialog(context, index, true);
                    }),
              ),
              // SizedBox(
              //   width: 5,
              // ),
              CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                    color: Colors.red,
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _showAlert(index, context);
                    }),
              ),
              // icon-2
            ],
          ),
          onTap: () async {
            namecontroller =
                new TextEditingController(text: students[index].name);
            idcontroller = new TextEditingController(
                text: students[index].studentId.toString());
            _showDialog(context, index, false);
          },
        ));
  }

  // Widget buildProductItem(BuildContext context, int index) {
  //   return Card(
  //     shape: RoundedRectangleBorder(
  //       // side: BorderSide(color: Colors.white70, width: 1),
  //       borderRadius: BorderRadius.circular(15),
  //     ),
  //     margin: EdgeInsets.all(10),
  //     color: Colors.grey,
  //     //color: Color.fromRGBO(66, 58, 18, 1),
  //     //color: Color.fromRGBO(255, 79, 0, 0.9),
  //     elevation: 5,
  //     child: Padding(
  //       padding: EdgeInsets.all(7),
  //       child: Stack(children: <Widget>[
  //         Align(
  //           alignment: Alignment.centerRight,
  //           child: Stack(
  //             children: <Widget>[
  //               Padding(
  //                   padding: const EdgeInsets.only(left: 10, top: 5),
  //                   child: Column(
  //                     children: <Widget>[
  //                       Row(
  //                         children: <Widget>[
  //                           studentsIcon(index),
  //                           SizedBox(
  //                             width: 10,
  //                           ),
  //                           studentDetails(index),
  //                           Spacer(),
  //                           //SizedBox(width: 15,),
  //                           editIcon(context, index),
  //                           SizedBox(
  //                             width: 10,
  //                           ),
  //                           deleteIcon(context, index),
  //                           //SizedBox(width: 10,),
  //                         ],
  //                       ),
  //                     ],
  //                   ))
  //             ],
  //           ),
  //         )
  //       ]),
  //     ),
  //   );
  // }

  // Widget studentsIcon(index) {
  //   return Container(
  //     padding: EdgeInsets.all(10),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       shape: BoxShape.circle,
  //     ),
  //     child: Text(students[index].name.substring(0, 1).toUpperCase(),
  //         //Text(students[index].name.substring(0, 1).toUpperCase(),
  //         style: TextStyle(
  //           fontSize: 40,
  //           fontFamily: "ProximaNova",
  //           fontStyle: FontStyle.italic,
  //           //color: Color.fromRGBO(231, 25, 137, 0.6)
  //         )),
  //   );
  // }

  // Widget studentDetails(index) {
  //   return Align(
  //     alignment: Alignment.centerLeft,
  //     child: RichText(
  //       text: TextSpan(
  //         text:
  //             '${students[index].name[0].toUpperCase()}${students[index].name.substring(1)}',
  //         style: TextStyle(
  //             fontWeight: FontWeight.bold,
  //             fontFamily: "ProximaNova",
  //             color: Colors.white,
  //             fontSize: 20),
  //         children: <TextSpan>[
  //           TextSpan(
  //               text: "\n" + students[index].studentId,
  //               style: TextStyle(
  //                   fontFamily: "ProximaNova",
  //                   color: Colors.amberAccent,
  //                   fontSize: 20,
  //                   fontWeight: FontWeight.bold)),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget deleteIcon(context, i) {
    return CircleAvatar(
        backgroundColor: Colors.white,
        child: Align(
            alignment: Alignment.topRight,
            child: IconButton(
                tooltip: "Delete",
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                  size: 25,
                ),
                onPressed: () {
                  _showAlert(i, context);
                })));
  }

  TextEditingController namecontroller;
  TextEditingController idcontroller = new TextEditingController();
  void _showDialog(context, index, editable) {
    String title = "";
    if (editable) {
      title = "Edit Student Profile";
    } else {
      title = "Student Profile";
    }
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
                title: Text(title),
                content: Form(
                  key: _formKey,
                  child: Wrap(
                    direction: Axis.horizontal,
                    children: <Widget>[
                      TextFormField(
                        enabled: editable,
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
                        enabled: editable,
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
                  Visibility(
                      visible: editable,
                      child: new FlatButton(
                        child: new Text("Submit"),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            DatabaseClass dc = new DatabaseClass();
                            students[index]
                                .editStudentId(int.parse(idcontroller.text));
                            students[index]
                                .editStudentName(namecontroller.text);
                            await dc.updateStudent(students[index]);
                            if (courseId == -1) {
                              Navigator.of(context).pop();
                              var router = new MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      new StudentPage(courseId));
                              Navigator.of(context).pushReplacement(router);
                            } else {
                              Navigator.of(context).pop();
                              var router = new MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      new StudentPage.course(c, courseId));
                              Navigator.of(context).pushReplacement(router);
                            }
                          }
                        },
                      )),
                  new FlatButton(
                      child: new Text("Close"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      })
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

  Widget editIcon(context, index) {
    return CircleAvatar(
        backgroundColor: Colors.white,
        child: Align(
            alignment: Alignment.centerRight,
            child: IconButton(
                tooltip: "Edit",
                icon: Icon(
                  Icons.edit,
                  color: Colors.green,
                  size: 25,
                ),
                onPressed: () {
                  namecontroller =
                      new TextEditingController(text: students[index].name);
                  idcontroller = new TextEditingController(
                      text: students[index].studentId.toString());
                  _showDialog(context, index, true);
                })));
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: buildProductItem,
      itemCount: students.length,
    );
  }
}
