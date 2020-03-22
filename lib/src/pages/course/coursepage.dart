import 'package:attendencemeter/src/database/database.dart';
import 'package:attendencemeter/src/models/course.dart';
import 'package:attendencemeter/src/pages/course/coursecart.dart';
import 'package:flutter/material.dart';

class CoursePage extends StatefulWidget {
  String m;
  CoursePage(this.m);
  @override
  State<StatefulWidget> createState() {
    return CoursePageState(m);
  }
}

class CoursePageState extends State<CoursePage> {
  String m;
  CoursePageState(this.m);
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
                title: Text('Add Course'),
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
                        String cname =
                            '${controller.text[0].toUpperCase()}${controller.text.substring(1)}';
                        await dc.saveCourse(cname);
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.lightGreen,
        title: Text(
          'Courses',
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
          child: FutureBuilder(
        future: getcourses(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Container(
              child: Center(
                child: Text("You have not added any Course"),
              ),
            );
          } else {
            return CourseCart(snapshot.data);
          }
        },
      )),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: "asasa",
        onPressed: () {
          _showDialog(context);
        },
        label: Text(
          'Add Course',
        ),
        icon: Icon(Icons.add),
        backgroundColor: Color.fromRGBO(80, 200, 10, 0.7),
      ),
    ));
  }
}
