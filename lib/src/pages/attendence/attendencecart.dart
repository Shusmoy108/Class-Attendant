import 'package:attendencemeter/src/database/database.dart';
import 'package:attendencemeter/src/models/attendence.dart';
import 'package:attendencemeter/src/models/course.dart';
import 'package:attendencemeter/src/models/student.dart';
import 'package:attendencemeter/src/pages/attendence/attendencepage.dart';
import 'package:attendencemeter/src/pages/attendence/studentpage.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AttendenceCart extends StatelessWidget {
  List<Attendence> attendences;
  List<Course> courses;
  AttendenceCart(this.attendences, this.courses);
  DatabaseClass dc = new DatabaseClass();
  void _showAlert(index, context) {
    String text = "Are you sure you want to delete this attendence of " +
        attendences[index].courseName +
        " course "
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
                      await dc.deleteAttendence(attendences[index].id);
                      Navigator.of(context).pop();
                      var router = new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              new AttendencePage(courses));
                      Navigator.of(context).pushReplacement(router);
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

  DateTime time;
  TextEditingController namecontroller = new TextEditingController();
  TextEditingController idcontroller = new TextEditingController();
  void _showDialog(context, index) {
    final formKey = GlobalKey<FormState>();
    final format = DateFormat("dd-MM-yyyy hh:mm aaa");
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
                title: Text('Edit Attendence'),
                content: SizedBox(
                    height: 150,
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Course Name",
                              style: TextStyle(
                                fontFamily: "ProximaNova",
                                fontSize: 20,
                                //fontWeight: FontWeight.w600
                              )),
                          Text(attendences[index].courseName,
                              style: TextStyle(
                                  fontFamily: "ProximaNova",
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600)),
                          SizedBox(height: 5),
                          Text("Select Date",
                              style: TextStyle(
                                fontFamily: "ProximaNova",
                                fontSize: 20,
                                //fontWeight: FontWeight.w600
                              )),
                          DateTimeField(
                            format: format,
                            initialValue: DateTime.fromMillisecondsSinceEpoch(
                                attendences[index].time),
                            onSaved: (value) {
                              attendences[index]
                                  .editTime(value.millisecondsSinceEpoch);
                            },
                            onShowPicker: (context, currentValue) async {
                              final date = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime(1900),
                                  initialDate: currentValue ?? DateTime.now(),
                                  lastDate: DateTime(2100));
                              if (date != null) {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.fromDateTime(
                                      currentValue ?? DateTime.now()),
                                );
                                return DateTimeField.combine(date, time);
                              } else {
                                return currentValue;
                              }
                            },
                          ),
                        ],
                      ),
                    )),
                actions: <Widget>[
                  // usually buttons at the bottom of the dialog
                  new FlatButton(
                    child: new Text("Submit"),
                    onPressed: () async {
                      formKey.currentState.save();
                      await dc.updateAttendence(attendences[index]);
                      Navigator.of(context).pop();
                      var router = new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              new AttendencePage(courses));
                      Navigator.of(context).pushReplacement(router);
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

  Widget buildProductItem(BuildContext context, int index) {
    DateTime d =
        new DateTime.fromMillisecondsSinceEpoch(attendences[index].time);
    final format = DateFormat("dd-MM-yyyy\nhh:mm aaa");
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
            child: Text(
                attendences[index].courseName.substring(0, 1).toUpperCase(),
                style: TextStyle(fontSize: 24, fontFamily: "ProximaNova")),
          ),
          title: Text(format.format(d),
              style: TextStyle(
                fontFamily: "ProximaNova",
                fontSize: 20,
                //fontWeight: FontWeight.w600
              )),
          subtitle: Text(attendences[index].courseName,
              style: TextStyle(
                  fontFamily: "ProximaNova",
                  fontSize: 20,
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
                      _showDialog(context, index);
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
            final stndts =
                await dc.findCourseStudents(attendences[index].courseName);
            List<Student> students = stndts;
            var router = new MaterialPageRoute(
                builder: (BuildContext context) => new AttendenceStudentPage(
                    "", students, attendences[index]));
            Navigator.of(context).push(router);
          },
        ));
  }

  // Widget buildProductItem(BuildContext context, int index) {
  //   DateTime d =
  //       new DateTime.fromMillisecondsSinceEpoch(attendences[index].time);
  //   final format = DateFormat("dd-MM-yyyy\nhh:mm aaa");
  //   return Card(
  //       color: Colors.grey,
  //       shape: RoundedRectangleBorder(
  //         //side: BorderSide(color: Colors.white70, width: 1),
  //         borderRadius: BorderRadius.circular(10),
  //       ),
  //       elevation: 5,
  //       child: ListTile(
  //         leading: Container(
  //           padding: EdgeInsets.all(10),
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             shape: BoxShape.circle,
  //           ),
  //           child: Text(
  //               attendences[index].courseName.substring(0, 1).toUpperCase(),
  //               style: TextStyle(fontSize: 24, fontFamily: "ProximaNova")),
  //         ),
  //         title: Text(format.format(d),
  //             style: TextStyle(
  //                 fontFamily: "ProximaNova",
  //                 fontSize: 20,
  //                 fontWeight: FontWeight.w600)),
  //         subtitle: Text(attendences[index].courseName,
  //             style: TextStyle(
  //                 fontFamily: "ProximaNova",
  //                 fontSize: 20,
  //                 fontWeight: FontWeight.w600)),
  //         trailing: Wrap(
  //           spacing: 10, // space between two icons
  //           children: <Widget>[
  //             CircleAvatar(
  //               backgroundColor: Colors.white,
  //               child: IconButton(
  //                   color: Colors.green,
  //                   icon: Icon(Icons.edit),
  //                   onPressed: () {
  //                     _showDialog(context, index);
  //                   }),
  //             ),
  //             // SizedBox(
  //             //   width: 5,
  //             // ),
  //             CircleAvatar(
  //               backgroundColor: Colors.white,
  //               child: IconButton(
  //                   color: Colors.red,
  //                   icon: Icon(Icons.delete),
  //                   onPressed: () {
  //                     _showAlert(index, context);
  //                   }),
  //             ),
  //             // icon-2
  //           ],
  //         ),
  //         onTap: () async {
  //           final stndts =
  //               await dc.findCourseStudents(attendences[index].courseName);
  //           List<Student> students = stndts;
  //           var router = new MaterialPageRoute(
  //               builder: (BuildContext context) => new AttendenceStudentPage(
  //                   "", students, attendences[index]));
  //           Navigator.of(context).push(router);
  //         },
  //       ));
  // }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: buildProductItem,
      itemCount: attendences.length,
    );
  }
}
