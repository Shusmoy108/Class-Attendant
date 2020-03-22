import 'package:attendencemeter/src/database/database.dart';
import 'package:attendencemeter/src/models/attendence.dart';
import 'package:attendencemeter/src/models/course.dart';
import 'package:attendencemeter/src/pages/course/coursepage.dart';
import 'package:attendencemeter/src/pages/student/studentpage.dart';
import 'package:flutter/material.dart';

class CourseCart extends StatelessWidget {
  List<Course> courses;
  CourseCart(this.courses);
  DatabaseClass dc = new DatabaseClass();
  TextEditingController controller = new TextEditingController();
  void _showDialog(context, index) {
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
                title: Text('Edit Course'),
                content: Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: controller,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a course name';
                        }
                        return null;
                      },
                    )),
                actions: <Widget>[
                  // usually buttons at the bottom of the dialog
                  new FlatButton(
                    child: new Text("Submit"),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        DatabaseClass dc = new DatabaseClass();
                        final attns = await dc.getattendencesbyCourseName(
                            courses[index].courseName);
                        List<Attendence> attendences = attns;
                        String cname =
                            '${controller.text[0].toUpperCase()}${controller.text.substring(1)}';
                        courses[index].editCourseName(cname);
                        await dc.updateCourse(courses[index]);

                        for (int i = 0; i < attendences.length; i++) {
                          attendences[i].courseName = controller.text;
                          await dc.updateAttendence(attendences[i]);
                        }
                        controller.clear();
                        Navigator.of(context).pop();
                        var router = new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                new CoursePage(""));
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

  void _showAlert(index, context) {
    String text = "Are you sure you want to delete " +
        courses[index].courseName +
        " course ?";
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
                      await dc.deleteCourse(courses[index].id);
                      Navigator.of(context).pop();
                      var router = new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              new CoursePage(""));
                      Navigator.of(context).pushReplacement(router);
                    },
                    child: new Text('Yes')),
                new FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: new Text('No')),
              ],
            ));
  }

  Widget buildProductItem(BuildContext context, int index) {
    String st = " student";
    if (courses[index].studentId.length > 1) {
      st = " students";
    }
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
            child: Text(courses[index].courseName.substring(0, 1).toUpperCase(),
                style: TextStyle(fontSize: 24, fontFamily: "ProximaNova")),
          ),
          title: Text(
              '${courses[index].courseName[0].toUpperCase()}${courses[index].courseName.substring(1)}',
              style: TextStyle(
                fontFamily: "ProximaNova",
                fontSize: 20,
                //fontWeight: FontWeight.w600
              )),
          subtitle: Text(courses[index].studentId.length.toString() + st,
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
                      controller = new TextEditingController(
                          text: courses[index].courseName);
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
            var router = new MaterialPageRoute(
                builder: (BuildContext context) =>
                    new StudentPage.course(courses[index], courses[index].id));
            Navigator.of(context).push(router);
          },
        ));
  }

  // Widget buildProductItem(BuildContext context, int index) {
  //   return InkWell(
  //     onTap: () {
  //       var router = new MaterialPageRoute(
  //           builder: (BuildContext context) =>
  //               new StudentPage.course(courses[index], courses[index].id));
  //       Navigator.of(context).push(router);
  //     },
  //     child: Card(
  //       shape: RoundedRectangleBorder(
  //         //side: BorderSide(width: 1),
  //         borderRadius: BorderRadius.circular(15),
  //       ),
  //       color: Colors.grey,
  //       elevation: 5,
  //       margin: EdgeInsets.all(10),
  //       child: Padding(
  //         padding: EdgeInsets.all(7),
  //         child: Stack(children: <Widget>[
  //           Align(
  //             alignment: Alignment.centerRight,
  //             child: Stack(
  //               children: <Widget>[
  //                 Padding(
  //                     padding: const EdgeInsets.only(left: 10, top: 5),
  //                     child: Column(
  //                       children: <Widget>[
  //                         Row(
  //                           children: <Widget>[
  //                             courseIcon(index),
  //                             SizedBox(
  //                               width: 10,
  //                             ),
  //                             courseDetails(index),
  //                             Spacer(),
  //                             editIcon(context, index),
  //                             SizedBox(
  //                               width: 10,
  //                             ),
  //                             deleteIcon(index, context),
  //                           ],
  //                         ),
  //                       ],
  //                     ))
  //               ],
  //             ),
  //           )
  //         ]),
  //       ),
  //     ),
  //   );
  // }

  Widget courseIcon(index) {
    return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Text(courses[index].courseName.substring(0, 1).toUpperCase(),
            style: TextStyle(fontSize: 40, fontFamily: "ProximaNova")));
  }

  Widget courseDetails(index) {
    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          text:
              '${courses[index].courseName[0].toUpperCase()}${courses[index].courseName.substring(1)}',
          style: TextStyle(
              // fontWeight: FontWeight.bold,
              fontFamily: "ProximaNova",
              color: Colors.black,
              fontSize: 20),
          children: <TextSpan>[
            TextSpan(
                text: "\n" +
                    courses[index].studentId.length.toString() +
                    " Students",
                style: TextStyle(
                  fontFamily: "ProximaNova",
                  color: Colors.black,
                  fontSize: 15,
                  //fontWeight: FontWeight.bold
                )),
          ],
        ),
      ),
    );
  }

  Widget deleteIcon(i, context) {
    return CircleAvatar(
        //padding: const EdgeInsets.only(left: 15.0),
        backgroundColor: Colors.white,
        //foregroundColor: Colors.black,
        child: IconButton(
            tooltip: "Delete",
            icon: Icon(
              Icons.delete,
              color: Colors.red,
              size: 25,
            ),
            onPressed: () {
              _showAlert(i, context);
            }));
  }

  Widget editIcon(context, index) {
    return CircleAvatar(
        //padding: const EdgeInsets.only(left: 15.0),
        backgroundColor: Colors.white,
        //foregroundColor: Colors.black,
        child: IconButton(
            tooltip: "Edit",
            icon: Icon(
              Icons.edit,
              color: Colors.green,
              size: 25,
            ),
            onPressed: () {
              controller =
                  new TextEditingController(text: courses[index].courseName);
              _showDialog(context, index);
            }));
  }

  Widget studentsIcon(context, index) {
    return CircleAvatar(
        //padding: const EdgeInsets.only(left: 15.0),
        backgroundColor: Colors.white,
        //foregroundColor: Colors.black,
        child: IconButton(
            tooltip: "Students",
            icon: Icon(
              Icons.group,
              color: Colors.blueAccent,
              size: 20,
            ),
            onPressed: () {
              var router = new MaterialPageRoute(
                  builder: (BuildContext context) => new StudentPage.course(
                      courses[index], courses[index].id));
              Navigator.of(context).push(router);
            }));
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: buildProductItem,
      itemCount: courses.length,
    );
  }
}
