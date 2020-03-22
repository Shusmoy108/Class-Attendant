import 'package:attendencemeter/src/database/database.dart';
import 'package:attendencemeter/src/models/attendence.dart';
import 'package:attendencemeter/src/models/course.dart';
import 'package:attendencemeter/src/models/profile.dart';
import 'package:attendencemeter/src/models/student.dart';
import 'package:attendencemeter/src/pages/pdf/createpdf.dart';
import 'package:attendencemeter/src/pages/statistics/statstudent.dart';
import 'package:flutter/material.dart';

class StatisticCart extends StatelessWidget {
  Profile m;
  List<Course> courses;
  StatisticCart(this.courses, this.m);
  DatabaseClass dc = new DatabaseClass();
  double classrate = 0;
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
                style: TextStyle(fontSize: 30, fontFamily: "ProximaNova")),
          ),
          title: Text(
              '${courses[index].courseName[0].toUpperCase()}${courses[index].courseName.substring(1)}',
              style: TextStyle(fontSize: 20, fontFamily: "ProximaNova")),
          subtitle: Text(
              courses[index].studentId.toBuilder().length.toString() + st,
              style: TextStyle(
                  fontFamily: "ProximaNova",
                  fontSize: 15,
                  fontWeight: FontWeight.w600)),
          onTap: () async {
            final stndts =
                await dc.findCourseStudents(courses[index].courseName);
            final attns =
                await dc.getattendencesbyCourseName(courses[index].courseName);
            List<Attendence> attendences = attns;
            List<Student> students = stndts;
            List<List<String>> rows = List<List<String>>();
            List<String> row = List();
            row.add("ID/Roll");
            row.add("Class-> \nName ");
            for (int k = 0; k < attendences.length; k++) {
              row.add((k + 1).toString());
            }
            rows.add(row);
            classrate = 0;
            for (int i = 0; i < students.length; i++) {
              List<String> row = List();
              row.add(students[i].studentId.toString());
              row.add(students[i].name);
              students[i].totalattendence = 0;
              students[i].attendences.clear();
              for (int j = 0; j < attendences.length; j++) {
                if (attendences[j].presentId.contains(students[i].id)) {
                  row.add("P");
                  students[i].totalattendence =
                      (students[i].totalattendence + 1);
                } else {
                  row.add("A");
                }
                students[i]
                    .attendences
                    .add(students[i].totalattendence / (j + 1) * 100);
              }
              rows.add(row);
              classrate = classrate +
                  students[i].attendences[students[i].attendences.length - 1];
              //print(students[i].attendences);
            }
            if (students.length != 0) {
              classrate = classrate / students.length;
            }
            String app = courses[index].courseName +
                " total\nclassrate is " +
                classrate.round().toString() +
                "%";

            var router = new MaterialPageRoute(
                builder: (BuildContext context) => new StatStudentCart(
                    students, rows, app, m, courses[index].courseName));
            Navigator.of(context).push(router);
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: buildProductItem,
      itemCount: courses.length,
    );
  }
}
