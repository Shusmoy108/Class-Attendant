import 'package:attendencemeter/src/models/course.dart';
import 'package:attendencemeter/src/models/profile.dart';
import 'package:attendencemeter/src/models/student.dart';
import 'package:attendencemeter/src/pages/pdf/pdfviewerpage.dart';
import 'package:flutter/material.dart';
import 'package:attendencemeter/src/database/database.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class StatStudentCart extends StatelessWidget {
  List<Student> students;
  Profile m;
  Course c;
  String path;
  String courseId;
  String classrate;
  List<List<String>> rows;
  StatStudentCart(
      this.students, this.rows, this.classrate, this.m, this.courseId);
  DatabaseClass dc = new DatabaseClass();
  List<charts.Series<Corodinate, int>> _seriesLineData = List();

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
          onTap: () async {
            chart(index);
            _showAlert(index, context);
          },
        ));
  }

  // Widget buildProductItem(BuildContext context, int index) {
  //   return Card(
  //     color: Colors.grey,
  //     shape: RoundedRectangleBorder(
  //       //side: BorderSide(color: Colors.white70, width: 1),
  //       borderRadius: BorderRadius.circular(15),
  //     ),
  //     elevation: 5,
  //     margin: EdgeInsets.all(10),
  //     child: InkWell(
  //       onTap: () {
  //         chart(index);
  //         _showAlert(index, context);
  //         print("object");
  //       },
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
  //                             studentsIcon(index),
  //                             SizedBox(
  //                               width: 10,
  //                             ),
  //                             studentDetails(index),
  //                             Spacer(),
  //                             //SizedBox(width: 15,),
  //                             //SizedBox(width: 10,),
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

  void chart(index) {
    var linesalesdata1 = [
      new Corodinate(0, 0),
    ];
    for (int i = 0; i < students[index].attendences.length; i++) {
      linesalesdata1.add(new Corodinate(i + 1, students[index].attendences[i]));
    }
    _seriesLineData.add(
      charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Colors.green),
        id: 'Class Attendence',
        data: linesalesdata1,
        domainFn: (Corodinate sales, _) => sales.x,
        measureFn: (Corodinate sales, _) => sales.y,
      ),
    );
  }

  void _showAlert(index, context) {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              shape:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
              title: new Text('Class Attendence'),
              content: Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Attendence Rate of ' +
                              students[index].name +
                              " after " +
                              students[index].attendences.length.toString() +
                              " classes",
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: charts.LineChart(_seriesLineData,
                              defaultRenderer: new charts.LineRendererConfig(
                                  includeArea: true, stacked: true),
                              animate: true,
                              animationDuration: Duration(seconds: 5),
                              behaviors: [
                                new charts.ChartTitle('Class',
                                    behaviorPosition:
                                        charts.BehaviorPosition.bottom,
                                    titleOutsideJustification: charts
                                        .OutsideJustification.middleDrawArea),
                                new charts.ChartTitle('Attendence Rate',
                                    behaviorPosition:
                                        charts.BehaviorPosition.start,
                                    titleOutsideJustification: charts
                                        .OutsideJustification.middleDrawArea),
                              ]),
                        ),
                        Text(
                          'Final Attendence Rate of ' +
                              students[index].name +
                              " is " +
                              students[index]
                                  .attendences[
                                      students[index].attendences.length - 1]
                                  .round()
                                  .toString() +
                              "%",
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.black12,
                          child: IconButton(
                            color: Colors.red,
                            icon: Icon(Icons.close),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }

  Widget studentsIcon(index) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Text(students[index].name.substring(0, 1).toUpperCase(),
          style: TextStyle(fontSize: 40, fontFamily: "ProximaNova")),
    );
  }

  Widget studentDetails(index) {
    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          text:
              '${students[index].name[0].toUpperCase()}${students[index].name.substring(1)}',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: "ProximaNova",
              color: Colors.black,
              fontSize: 20),
          children: <TextSpan>[
            TextSpan(
                text: "\n" + students[index].studentId.toString(),
                style: TextStyle(
                    fontFamily: "ProximaNova",
                    color: Colors.amber,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.lightGreen,
              centerTitle: true,
              title: Text(
                classrate,
                style: TextStyle(
                    fontFamily: "ProximaNova",
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            //backgroundColor: Colors.transparent,
            body: ListView.builder(
              itemBuilder: buildProductItem,
              itemCount: students.length,
            ),
            floatingActionButton: FloatingActionButton.extended(
              heroTag: "addStudent",
              onPressed: () {
                var router = new MaterialPageRoute(
                    builder: (BuildContext context) =>
                        new PdfViewerPage(m, rows, courseId));
                Navigator.of(context).push(router);
                // name = new TextEditingController(text: pro['name']);
                // instititute = new TextEditingController(text: pro['institution']);
                // _showDialog(context);
              },
              label: Text(
                'Export Attendence Sheet',
              ),
              icon: Icon(Icons.picture_as_pdf),
              backgroundColor: Color.fromRGBO(80, 200, 10, 0.7),
            )));
  }
}

/// Sample linear data type.
class Corodinate {
  final int x;
  final double y;

  Corodinate(this.x, this.y);
}
