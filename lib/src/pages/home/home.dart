import 'package:attendencemeter/src/models/attendence.dart';
import 'package:attendencemeter/src/models/course.dart';
import 'package:attendencemeter/src/models/profile.dart';
import 'package:attendencemeter/src/models/student.dart';
import 'package:attendencemeter/src/pages/attendence/attendencepage.dart';
import 'package:attendencemeter/src/pages/course/coursepage.dart';
import 'package:attendencemeter/src/pages/help/help.dart';
import 'package:attendencemeter/src/pages/statistics/statisticspage.dart';
import 'package:attendencemeter/src/pages/student/studentpage.dart';
import 'package:flutter/material.dart';
import '../../database/database.dart';

class Home extends StatefulWidget {
  Profile pro;
  Home(this.pro);
  @override
  State<StatefulWidget> createState() {
    return HomeState(pro);
  }
}

class HomeState extends State<Home> {
  Profile pro;
  HomeState(this.pro);
  DatabaseClass dc = DatabaseClass();
  String totalcourse = "";
  String coursenames = "";
  List<Widget> attendences = List();
  List<Course> courses = List();
  int totalclass = 0;
  int totalstudents;
  Future<bool> course() async {
    final crc = await dc.getcourses();
    attendences.clear();
    totalclass = 0;
    totalcourse = "";
    coursenames = "";
    courses = crc;
    totalstudents = 0;
    totalcourse = courses.length.toString();
    final stndts = await dc.getstudents();
    List<Student> students = stndts;
    totalstudents = students.length;
    for (int i = 0; i < courses.length; i++) {
      final attns = await dc.getattendencesbyCourseName(courses[i].courseName);
      List<Attendence> attendence = attns;
      totalclass = totalclass + attendence.length;
      attendences.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(courses[i].courseName,
              style: TextStyle(
                  fontFamily: "ProximaNova",
                  fontSize: 15,
                  fontWeight: FontWeight.bold)),
          Text(attendence.length.toString(),
              style: TextStyle(
                  fontFamily: "ProximaNova",
                  fontSize: 15,
                  fontWeight: FontWeight.bold)),
        ],
      ));
      attendences.add(SizedBox(height: 5));
      coursenames = coursenames + courses[i].courseName;
      if (i != courses.length - 1) {
        coursenames = coursenames + ", ";
      }
      if ((i + 1) % 3 == 0 && i != courses.length - 1) {
        coursenames = coursenames + "\n";
      }
    }
    attendences.add(Divider(
      color: Colors.black87,
    ));
    attendences.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text("Total Classes",
              style: TextStyle(
                  fontFamily: "ProximaNova",
                  fontSize: 15,
                  fontWeight: FontWeight.bold)),
          Text(totalclass.toString(),
              style: TextStyle(
                  fontFamily: "ProximaNova",
                  fontSize: 15,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
    attendences.add(
      SizedBox(height: 5),
    );
    return true;
  }

  @override
  void initState() {
    setState(() {
      super.initState();
    });
  }

  Future<List<Course>> getcourses() async {
    return dc.getcourses();
  }

  TextEditingController instititute = new TextEditingController();
  TextEditingController name = new TextEditingController();
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
                title: Text('Edit Profile'),
                content: SizedBox(
                  height: 150,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TextField(
                        controller: name,
                        decoration: new InputDecoration(
                            labelText: 'User Name',
                            hintText: 'eg. Shusmoy Chowdhury'),
                      ),
                      TextField(
                        controller: instititute,
                        decoration: new InputDecoration(
                            labelText: 'Institution Name',
                            hintText: 'eg. Southern University Bangladesh'),
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  // usually buttons at the bottom of the dialog
                  new FlatButton(
                    child: new Text("Submit"),
                    onPressed: () async {
                      await dc.updateProfile(
                          pro.id, name.text, instititute.text);
                      name.clear();
                      instititute.clear();
                      pro = await dc.getprofile();
                      Navigator.of(context).pop();
                      var router = new MaterialPageRoute(
                          builder: (BuildContext context) => new Home(pro));
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

  @override
  Widget build(BuildContext context) {
    return new SafeArea(
        child: FutureBuilder(
            future: course(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData == false) {
                return Container(
                    color: Colors.white, child: CircularProgressIndicator());
              } else {
                return Scaffold(
                    appBar: AppBar(
                        centerTitle: true,
                        backgroundColor: Colors.lightGreen,
                        title: Text("Class Attendant")),
                    drawer: Drawer(
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: ListView(
                              children: <Widget>[
                                DrawerHeader(
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.account_circle,
                                      size: 80,
                                    ),
                                    title: Text(pro.name,
                                        style: TextStyle(
                                            fontFamily: "ProximaNova",
                                            fontSize: 24,
                                            fontWeight: FontWeight.w600)),
                                    subtitle: Text(pro.institution,
                                        style: TextStyle(
                                            fontFamily: "ProximaNova",
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500)),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blueGrey,
                                  ),
                                ),
                                ListTile(
                                  leading: Icon(Icons.library_books),
                                  title: Text(
                                    'Courses',
                                    style: TextStyle(
                                        fontFamily: "ProximaNova",
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  onTap: () {
                                    var router = new MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            new CoursePage(""));
                                    Navigator.of(context).push(router);
                                  },
                                ),
                                ListTile(
                                  leading: Icon(Icons.assignment_turned_in),
                                  title: Text(
                                    'Attendence',
                                    style: TextStyle(
                                        fontFamily: "ProximaNova",
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  onTap: () async {
                                    final crc = await dc.getcourses();
                                    List<Course> courses = crc;
                                    var router = new MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            new AttendencePage(courses));
                                    Navigator.of(context).push(router);
                                  },
                                ),
                                ListTile(
                                  leading: Icon(Icons.group),
                                  title: Text(
                                    'Students',
                                    style: TextStyle(
                                        fontFamily: "ProximaNova",
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  onTap: () {
                                    var router = new MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            new StudentPage(-1));
                                    Navigator.of(context).push(router);
                                  },
                                ),
                                ListTile(
                                  leading: Icon(Icons.insert_chart),
                                  title: Text(
                                    'Statistics',
                                    style: TextStyle(
                                        fontFamily: "ProximaNova",
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  onTap: () {
                                    var router = new MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            new StatisticPage(pro));
                                    Navigator.of(context).push(router);
                                  },
                                ),
                              ],
                            ),
                          ),
                          Container(
                              // This align moves the children to the bottom
                              child: Align(
                                  alignment: FractionalOffset.bottomCenter,
                                  // This container holds all the children that will be aligned
                                  // on the bottom and should not scroll with the above ListView
                                  child: Container(
                                      child: Column(
                                    children: <Widget>[
                                      Divider(),
                                      ListTile(
                                        leading: Icon(Icons.help),
                                        title: Text('Help and Feedback',
                                            style: TextStyle(
                                                fontFamily: "ProximaNova",
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500)),
                                        onTap: () {
                                          var router = new MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  new HelpPage(""));
                                          Navigator.of(context).push(router);
                                        },
                                      ),
                                      ListTile(
                                          leading: Icon(Icons.work),
                                          title: Text('About Us',
                                              style: TextStyle(
                                                  fontFamily: "ProximaNova",
                                                  fontSize: 18,
                                                  fontWeight:
                                                      FontWeight.w500))),
                                    ],
                                  ))))
                        ],
                      ),
                    ),
                    body: Container(
                        color: Color.fromRGBO(234, 239, 241, 1.0),
                        child: ListView(
                          children: <Widget>[
                            Icon(
                              Icons.account_circle,
                              size: 100,
                            ),
                            Divider(
                                color: Colors.blueGrey,
                                thickness: 1,
                                indent: 5),
                            SizedBox(height: 2),
                            Center(
                              child: Text(pro.name,
                                  style: TextStyle(
                                      fontFamily: "ProximaNova",
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Center(
                              child: Text(pro.institution,
                                  style: TextStyle(
                                      fontFamily: "ProximaNova",
                                      fontSize: 18,
                                      fontStyle: FontStyle.italic)),
                            ),
                            SizedBox(height: 2),
                            Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: Text("Courses",
                                  style: TextStyle(
                                      fontFamily: "ProximaNova",
                                      fontSize: 15,
                                      fontStyle: FontStyle.italic)),
                            ),
                            Divider(),
                            Card(
                                margin: EdgeInsets.all(10),
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text("Total Courses",
                                              style: TextStyle(
                                                  fontFamily: "ProximaNova",
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold)),
                                          Text(totalcourse,
                                              style: TextStyle(
                                                  fontFamily: "ProximaNova",
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                      SizedBox(height: 5),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text("Course Names",
                                              style: TextStyle(
                                                  fontFamily: "ProximaNova",
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold)),
                                          Text(coursenames,
                                              style: TextStyle(
                                                  fontFamily: "ProximaNova",
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                      SizedBox(height: 5),
                                    ],
                                  ),
                                )),
                            SizedBox(height: 2),
                            Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: Text("Classes",
                                  style: TextStyle(
                                      fontFamily: "ProximaNova",
                                      fontSize: 15,
                                      fontStyle: FontStyle.italic)),
                            ),
                            Divider(),
                            Card(
                                margin: EdgeInsets.all(10),
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Column(children: attendences),
                                )),
                            SizedBox(height: 2),
                            Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: Text("Students",
                                  style: TextStyle(
                                      fontFamily: "ProximaNova",
                                      fontSize: 15,
                                      fontStyle: FontStyle.italic)),
                            ),
                            Divider(),
                            Card(
                                margin: EdgeInsets.all(10),
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text("Total Students",
                                              style: TextStyle(
                                                  fontFamily: "ProximaNova",
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold)),
                                          Text(totalstudents.toString(),
                                              style: TextStyle(
                                                  fontFamily: "ProximaNova",
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                      SizedBox(height: 5),
                                    ],
                                  ),
                                ))
                          ],
                        )),
                    floatingActionButton: FloatingActionButton.extended(
                      heroTag: "addStudent",
                      onPressed: () {
                        name = new TextEditingController(text: pro.name);
                        instititute =
                            new TextEditingController(text: pro.institution);
                        _showDialog(context);
                      },
                      label: Text(
                        'Edit Profile',
                      ),
                      icon: Icon(Icons.edit),
                      backgroundColor: Color.fromRGBO(80, 200, 10, 0.7),
                    ));
              }
            }));
  }
}
