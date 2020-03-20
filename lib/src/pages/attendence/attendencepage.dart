import 'package:attendencemeter/src/database/database.dart';
import 'package:attendencemeter/src/models/attendence.dart';
import 'package:attendencemeter/src/models/course.dart';
import 'package:attendencemeter/src/pages/attendence/attendencecart.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';

class AttendencePage extends StatefulWidget {
  String m;
  List<Course> courses;
  AttendencePage(this.courses);
  //AllTutionPage(this.u);
  @override
  State<StatefulWidget> createState() {
    return AttendencePageState(this.courses);
  }
}

class AttendencePageState extends State<AttendencePage> {
  String m;
  AttendencePageState(this.courses);
  List<Course> courses;
  List<String> search = List();
  DatabaseClass dc = new DatabaseClass();
  @override
  void initState() {
    setState(() {
      super.initState();
      search.add("All");
      for (int i = 0; i < courses.length; i++) {
        search.add(courses[i].courseName);
      }
      if (courses.length != 0) {
        courseName = courses[0].courseName;
      } else {
        courseName = "";
      }
      searchValue = "All";
    });
  }

  String courseName;
  Widget dropdown() {
    //courseName = courses[0].courseName;
    return DropdownButton<String>(
      value: courseName,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      //style: TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.black,
      ),
      onChanged: (String newValue) {
        setState(() {
          courseName = newValue;
        });
      },
      items: courses.map<DropdownMenuItem<String>>((Course value) {
        return DropdownMenuItem<String>(
          value: value.courseName,
          child: Text(value.courseName,
              style: TextStyle(
                fontFamily: "ProximaNova",
                fontSize: 20,
                //fontWeight: FontWeight.w600
              )),
        );
      }).toList(),
    );
  }

  Widget searchdropdown() {
    //courseName = courses[0].courseName;
    return DropdownButton<String>(
      value: searchValue,
      icon: Icon(Icons.arrow_downward),
      iconSize: 20,
      elevation: 16,
      //style: TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.black87,
      ),
      onChanged: (String newValue) {
        setState(() {
          searchValue = newValue;
        });
      },
      items: search.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value,
              style: TextStyle(
                  color: Colors.black87,
                  fontFamily: "ProximaNova",
                  fontSize: 20,
                  fontWeight: FontWeight.w600)),
        );
      }).toList(),
    );
  }

  Future<List<Attendence>> getattendences() async {
    if (searchValue == "All") {
      return dc.getattendences();
    } else {
      return dc.getattendencesbyCourseName(searchValue);
    }
  }

  String searchValue;
  DateTime time;
  TextEditingController namecontroller = new TextEditingController();
  TextEditingController idcontroller = new TextEditingController();
  void _showDialog(context) {
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
                title: Text('Add New Attendence'),
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
                          dropdown(),
                          Text("Select Date",
                              style: TextStyle(
                                fontFamily: "ProximaNova",
                                fontSize: 20,
                                //fontWeight: FontWeight.w600
                              )),
                          DateTimeField(
                            format: format,
                            initialValue: DateTime.now(),
                            onSaved: (value) {
                              time = value;
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
                      Attendence attendence = new Attendence(
                          courseName, time.millisecondsSinceEpoch);
                      dc.saveAttendence(attendence);
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

  void _showAlert(context) {
    String text =
        "Sorry!!! Currently you do not have any course to take attendence.";
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              shape:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
              title: new Text('Warning!!!!!'),
              content: new Text(
                text,
                style: new TextStyle(
                  fontFamily: "ProximaNova",
                  fontSize: 18,
                ),
              ),
              actions: <Widget>[
                new FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      //_dialogueResult(MyDialogueAction.no);
                    },
                    child: new Text('Close')),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.lightGreen,
        title: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text("Course Name : ",
                style: TextStyle(
                    color: Colors.black87,
                    fontFamily: "ProximaNova",
                    fontSize: 20,
                    fontWeight: FontWeight.w600)),
            //SizedBox(),
            searchdropdown()
          ],
        ),
      ),
      //backgroundColor: Colors.transparent,
      body: Container(
          //color: Color.fromRGBO(234, 239, 241, 1.0),
          //margin: EdgeInsets.all(10.0),
          child: FutureBuilder(
        future: getattendences(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Container(
              child: Center(
                child: Text("You have not taken any classes"),
              ),
            );
          } else {
            return AttendenceCart(snapshot.data, courses);
          }
        },
      )),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "asasa",
        onPressed: () {
          if (courseName == "") {
            _showAlert(context);
          } else {
            _showDialog(context);
          }
        },
        label: Text(
          'Add Attendence',
        ),
        icon: Icon(Icons.add),
        backgroundColor: Color.fromRGBO(80, 200, 10, 0.7),
      ),
    );
  }
}
