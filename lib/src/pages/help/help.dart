import 'package:attendencemeter/src/database/database.dart';
import 'package:attendencemeter/src/models/course.dart';
import 'package:attendencemeter/src/pages/course/coursecart.dart';
import 'package:flutter/material.dart';

class HelpPage extends StatefulWidget {
  String m;
  HelpPage(this.m);
  @override
  State<StatefulWidget> createState() {
    return HelpPageState(m);
  }
}

class HelpPageState extends State<HelpPage> {
  String m;
  HelpPageState(this.m);
  Future<List<Course>> courses;
  DatabaseClass dc = new DatabaseClass();
  @override
  void initState() {
    setState(() {
      super.initState();
    });
  }

  Future<List<Course>> getcourses() async {
    return dc.getcourses();
  }

  TextEditingController controller = new TextEditingController();
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
                title: Text('Add Course'),
                content: TextField(controller: controller),
                actions: <Widget>[
                  // usually buttons at the bottom of the dialog
                  new FlatButton(
                    child: new Text("Submit"),
                    onPressed: () async {
                      DatabaseClass dc = new DatabaseClass();
                      await dc.saveCourse(controller.text);
                      controller.clear();
                      Navigator.of(context).pop();
                      var router = new MaterialPageRoute(
                          builder: (BuildContext context) => new HelpPage(""));
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
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.lightGreen,
        title: Text(
          'Help and Feedback',
          style: TextStyle(
              fontFamily: "ProximaNova",
              fontSize: 24,
              fontWeight: FontWeight.w600),
        ),
      ),
      //backgroundColor: Colors.transparent,
      body: Container(
          //color: Color.fromRGBO(234, 239, 241, 1.0),
          //margin: EdgeInsets.all(10.0),
          child: ListView(
        children: <Widget>[
          ExpansionTile(
            backgroundColor: Colors.grey,
            title: Text(
              'Attendence',
              style: TextStyle(
                  fontFamily: "ProximaNova",
                  fontSize: 22,
                  fontWeight: FontWeight.w600),
            ),
            children: <Widget>[
              ExpansionTile(
                title: Text(
                  'Attendence Page',
                  style: TextStyle(
                      fontFamily: "ProximaNova",
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
                children: <Widget>[
                  ClipRect(
                    child: Align(
                      alignment: Alignment.topCenter,
                      //heightFactor: 0.5,
                      child: Image.asset(
                        'images/attndnc.png',
                        // width: 600.0,
                        // height: 240.0,
                      ),
                    ),
                  ),
                ],
              ),
              ExpansionTile(
                title: Text(
                  'Add new Attendence',
                  style: TextStyle(
                      fontFamily: "ProximaNova",
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
                children: <Widget>[
                  ClipRect(
                    child: Align(
                      alignment: Alignment.topCenter,
                      //heightFactor: 0.5,
                      child: Image.asset(
                        'images/attndnce.png',
                        // width: 600.0,
                        // height: 240.0,
                      ),
                    ),
                  ),
                ],
              ),
              ExpansionTile(
                title: Text(
                  'Search Particular Cource Attendence',
                  style: TextStyle(
                      fontFamily: "ProximaNova",
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
                children: <Widget>[
                  ClipRect(
                    child: Align(
                      alignment: Alignment.topCenter,
                      //heightFactor: 0.5,
                      child: Image.asset(
                        'images/attndncprrt.png',
                        // width: 600.0,
                        // height: 240.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      //side: BorderSide(color: Colors.white70, width: 1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    color: Colors.grey,
                    elevation: 5,
                    margin: EdgeInsets.all(10),
                    child: ListTile(
                      title: Text(
                        'Result of the Search',
                        style: TextStyle(
                            fontFamily: "ProximaNova",
                            fontSize: 24,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ClipRect(
                    child: Align(
                      alignment: Alignment.topCenter,
                      //heightFactor: 0.5,
                      child: Image.asset(
                        'images/attndncpart1.png',
                        // width: 600.0,
                        // height: 240.0,
                      ),
                    ),
                  ),
                ],
              ),
              ExpansionTile(
                title: Text(
                  'Attendence Sheet',
                  style: TextStyle(
                      fontFamily: "ProximaNova",
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
                children: <Widget>[
                  ClipRect(
                    child: Align(
                      alignment: Alignment.topCenter,
                      //heightFactor: 0.5,
                      child: Image.asset(
                        'images/attndncsheet.png',
                        // width: 600.0,
                        // height: 240.0,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          ExpansionTile(
            backgroundColor: Colors.grey,
            //trailing: Icon(Icons.trending_down),
            title: Text(
              'Course',
              style: TextStyle(
                  fontFamily: "ProximaNova",
                  fontSize: 22,
                  fontWeight: FontWeight.w600),
            ),
            children: <Widget>[
              ExpansionTile(
                title: Text(
                  'Course Page',
                  style: TextStyle(
                      fontFamily: "ProximaNova",
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
                children: <Widget>[
                  ClipRect(
                    child: Align(
                      alignment: Alignment.topCenter,
                      //heightFactor: 0.5,
                      child: Image.asset(
                        'images/course.png',
                        // width: 600.0,
                        // height: 240.0,
                      ),
                    ),
                  ),
                ],
              ),
              ExpansionTile(
                title: Text(
                  'Add Course',
                  style: TextStyle(
                      fontFamily: "ProximaNova",
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
                children: <Widget>[
                  ClipRect(
                    child: Align(
                      alignment: Alignment.topCenter,
                      //heightFactor: 0.5,
                      child: Image.asset(
                        'images/courseadd.png',
                        // width: 600.0,
                        // height: 240.0,
                      ),
                    ),
                  ),
                ],
              ),
              ExpansionTile(
                title: Text(
                  'Add Students in Cource Options',
                  style: TextStyle(
                      fontFamily: "ProximaNova",
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
                children: <Widget>[
                  ClipRect(
                    child: Align(
                      alignment: Alignment.topCenter,
                      //heightFactor: 0.5,
                      child: Image.asset(
                        'images/addcrcstdnt1.png',
                        // width: 600.0,
                        // height: 240.0,
                      ),
                    ),
                  ),
                ],
              ),
              ExpansionTile(
                title: Text(
                  'Add New Students Option',
                  style: TextStyle(
                      fontFamily: "ProximaNova",
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
                children: <Widget>[
                  ClipRect(
                    child: Align(
                      alignment: Alignment.topCenter,
                      //heightFactor: 0.5,
                      child: Image.asset(
                        'images/studentedit.png',
                        // width: 600.0,
                        // height: 240.0,
                      ),
                    ),
                  ),
                ],
              ),
              ExpansionTile(
                title: Text(
                  'Add Previous Students Option',
                  style: TextStyle(
                      fontFamily: "ProximaNova",
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
                children: <Widget>[
                  ClipRect(
                    child: Align(
                      alignment: Alignment.topCenter,
                      //heightFactor: 0.5,
                      child: Image.asset(
                        'images/prvsstdnt.png',
                        // width: 600.0,
                        // height: 240.0,
                      ),
                    ),
                  ),
                ],
              ),
              ExpansionTile(
                title: Text(
                  'Import Students from cource Option',
                  style: TextStyle(
                      fontFamily: "ProximaNova",
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
                children: <Widget>[
                  ClipRect(
                    child: Align(
                      alignment: Alignment.topCenter,
                      //heightFactor: 0.5,
                      child: Image.asset(
                        'images/importcrc.png',
                        // width: 600.0,
                        // height: 240.0,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          ExpansionTile(
            backgroundColor: Colors.grey,
            title: Text(
              'Statistics',
              style: TextStyle(
                  fontFamily: "ProximaNova",
                  fontSize: 22,
                  fontWeight: FontWeight.w600),
            ),
            children: <Widget>[
              ExpansionTile(
                title: Text(
                  'Statistics Page',
                  style: TextStyle(
                      fontFamily: "ProximaNova",
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
                children: <Widget>[
                  ClipRect(
                    child: Align(
                      alignment: Alignment.topCenter,
                      //heightFactor: 0.5,
                      child: Image.asset(
                        'images/stat.png',
                        // width: 600.0,
                        // height: 240.0,
                      ),
                    ),
                  ),
                ],
              ),
              ExpansionTile(
                title: Text(
                  'Course Class Rate',
                  style: TextStyle(
                      fontFamily: "ProximaNova",
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
                children: <Widget>[
                  ClipRect(
                    child: Align(
                      alignment: Alignment.topCenter,
                      //heightFactor: 0.5,
                      child: Image.asset(
                        'images/statstud.png',
                        // width: 600.0,
                        // height: 240.0,
                      ),
                    ),
                  ),
                ],
              ),
              ExpansionTile(
                title: Text(
                  'Student Class Graph',
                  style: TextStyle(
                      fontFamily: "ProximaNova",
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
                children: <Widget>[
                  ClipRect(
                    child: Align(
                      alignment: Alignment.topCenter,
                      //heightFactor: 0.5,
                      child: Image.asset(
                        'images/statgraph.png',
                        // width: 600.0,
                        // height: 240.0,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
          ExpansionTile(
            backgroundColor: Colors.grey,
            title: Text(
              'Student',
              style: TextStyle(
                  fontFamily: "ProximaNova",
                  fontSize: 22,
                  fontWeight: FontWeight.w600),
            ),
            children: <Widget>[
              ExpansionTile(
                title: Text(
                  'Student Page',
                  style: TextStyle(
                      fontFamily: "ProximaNova",
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
                children: <Widget>[
                  ClipRect(
                    child: Align(
                      alignment: Alignment.topCenter,
                      //heightFactor: 0.5,
                      child: Image.asset(
                        'images/student.png',
                        // width: 600.0,
                        // height: 240.0,
                      ),
                    ),
                  ),
                ],
              ),
              ExpansionTile(
                title: Text(
                  'Student Profile',
                  style: TextStyle(
                      fontFamily: "ProximaNova",
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
                children: <Widget>[
                  ClipRect(
                    child: Align(
                      alignment: Alignment.topCenter,
                      //heightFactor: 0.5,
                      child: Image.asset(
                        'images/stdntprf.png',
                        // width: 600.0,
                        // height: 240.0,
                      ),
                    ),
                  ),
                ],
              ),
              ExpansionTile(
                title: Text(
                  'Add Student',
                  style: TextStyle(
                      fontFamily: "ProximaNova",
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
                children: <Widget>[
                  ClipRect(
                    child: Align(
                      alignment: Alignment.topCenter,
                      //heightFactor: 0.5,
                      child: Image.asset(
                        'images/studentedit.png',
                        // width: 600.0,
                        // height: 240.0,
                      ),
                    ),
                  ),
                ],
              )
            ],
          )
        ],
      )),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "asasa",
        onPressed: () {
          _showDialog(context);
        },
        label: Text(
          'Give feedback',
        ),
        icon: Icon(Icons.feedback),
        backgroundColor: Color.fromRGBO(80, 200, 10, 0.7),
      ),
    ));
  }
}
