import 'dart:io';
import 'package:attendencemeter/src/database/database.dart';
import 'package:attendencemeter/src/models/attendence.dart';
import 'package:attendencemeter/src/models/course.dart';
import 'package:attendencemeter/src/models/student.dart';
import 'package:attendencemeter/src/pages/statistics/statstudent.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class StatisticCart extends StatelessWidget {
  List<Course> courses;
  StatisticCart(this.courses);
  DatabaseClass dc = new DatabaseClass();
  double classrate = 0;
  getCsv(index, context) async {
    //create an element rows of type list of list. All the above data set are stored in associate list
//Let associate be a model class with attributes name,gender and age and associateList be a list of associate model class.

    List<List<dynamic>> rows = List<List<dynamic>>();
    final stndts = await dc.findCourseStudents(courses[index].courseName);
    final attns =
        await dc.getattendencesbyCourseName(courses[index].courseName);
    List<Attendence> attendences = attns;
    List<Student> students = stndts;
    List<dynamic> row = List();
    row.add("");
    row.add("");
    for (int k = 0; k < attendences.length; k++) {
      row.add(k + 1);
    }
    rows.add(row);

    for (int i = 0; i < students.length; i++) {
      List<dynamic> row = List();
      row.add(students[i].studentId);
      row.add(students[i].name);
      for (int j = 0; j < attendences.length; j++) {
        if (attendences[j].presentId.contains(students[i].id)) {
          row.add("1");
          students[i].totalattendence = (students[i].totalattendence + 1);
        } else {
          row.add("0");
        }
        students[i]
            .attendences
            .add(students[i].totalattendence / (j + 1) * 100);
      }
      print(row);
      rows.add(row);
      print(rows);
      //print(students[i].attendences);
    }
    print(rows);
//     for (int i = 0; i < associateList.length; i++) {
// //row refer to each column of a row in csv file and rows refer to each row in a file
//       List<dynamic> row = List();
//       row.add(associateList[i].name);
//       row.add(associateList[i].gender);
//       row.add(associateList[i].age);
//       rows.add(row);
//     }

    // await SimplePermissions.requestPermission(Permission.WriteExternalStorage);
    // bool checkPermission = await SimplePermissions.checkPermission(
    //     Permission.WriteExternalStorage);
    // if (checkPermission) {
//store file in documents folder

//     String dir =
//         (await getExternalStorageDirectory()).absolute.path + "/documents";
//     var file = "$dir";
//     //print(LOGTAG + " FILE " + file);
//     File f = new File(file + "filename.csv");

// // convert rows to String and write as csv file

    String csv = const ListToCsvConverter().convert(rows);
//     f.writeAsString(csv);
    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String path = '$dir/' + courses[index].courseName + ".csv";

    // create file
    final bo = await File(path).exists();
    bool con = bo;
    if (con) {
      File(path).deleteSync(recursive: true);
    }
    final File file = File(path);
    // Save csv string using default configuration
    // , as field separator
    // " as text delimiter and
    // \r\n as eol.
    await file.writeAsString(csv);

    // await print(file1
    //     .transform(utf8.decoder)
    //     .transform(new CsvToListConverter())
    //     .toList()
    //     .toString());
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (_) => LoadAndViewCsvPage(path: path),
    //   ),
    // );
    // }
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
            child: Text(courses[index].courseName.substring(0, 1).toUpperCase(),
                style: TextStyle(fontSize: 30, fontFamily: "ProximaNova")),
          ),
          title: Text(courses[index].courseName,
              style: TextStyle(fontSize: 20, fontFamily: "ProximaNova")),
          subtitle: Text(
              courses[index].studentId.toBuilder().length.toString() +
                  " students",
              style: TextStyle(
                  fontFamily: "ProximaNova",
                  fontSize: 15,
                  fontWeight: FontWeight.w600)),
          onTap: () async {
            getCsv(index, context);
            final stndts =
                await dc.findCourseStudents(courses[index].courseName);
            final attns =
                await dc.getattendencesbyCourseName(courses[index].courseName);
            List<Attendence> attendences = attns;
            List<Student> students = stndts;
            print("q");

            classrate = 0;
            for (int i = 0; i < students.length; i++) {
              students[i].totalattendence = 0;
              students[i].attendences.clear();
              for (int j = 0; j < attendences.length; j++) {
                if (attendences[j].presentId.contains(students[i].id)) {
                  students[i].totalattendence =
                      (students[i].totalattendence + 1);
                }
                students[i]
                    .attendences
                    .add(students[i].totalattendence / (j + 1) * 100);
              }
              classrate = classrate +
                  students[i].attendences[students[i].attendences.length - 1];
              //print(students[i].attendences);
            }
            if (students.length != 0) {
              classrate = classrate / students.length;
            }

            final String dir = (await getApplicationDocumentsDirectory()).path;
            final String path =
                '/class_attendent/' + courses[index].courseName + ".csv";
            print(path);
            String app = courses[index].courseName +
                " total\nclassrate is " +
                classrate.toString() +
                "%";
            var router = new MaterialPageRoute(
                builder: (BuildContext context) =>
                    new StatStudentCart(students, path, app));
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
