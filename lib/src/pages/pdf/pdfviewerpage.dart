import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'dart:io';
import 'package:attendencemeter/src/models/profile.dart';
import 'package:attendencemeter/src/pages/pdf/pdfviewerpage.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

class PdfViewerPage extends StatelessWidget {
  String path;
  String courseName;
  List<List<String>> row;
  Profile p;
  PdfViewerPage(this.p, this.row, this.courseName);

  Future<bool> _generatePdfAndView(context) async {
    final pdfLib.Document pdf = pdfLib.Document(deflate: zlib.encode);

    pdf.addPage(
      pdfLib.MultiPage(
        pageFormat: PdfPageFormat.a3,
        margin: pdfLib.EdgeInsets.all(5),

        //footer: pdfLib.Paragraph(text: "Class Attendant"),
        build: (context) => [
          pdfLib.Center(child: pdfLib.Paragraph(text: p.institution)),
          pdfLib.Center(
              child: pdfLib.Paragraph(text: "Course Name: " + courseName)),
          pdfLib.Center(
              child:
                  pdfLib.Paragraph(text: "Instructor/Teacher Name: " + p.name)),
          pdfLib.Table.fromTextArray(context: context, data: row)
        ],
      ),
    );

    final String dir = (await getExternalStorageDirectory()).path;
    path = '$dir/' + courseName + ".pdf";
    final File file = File(path);
    print(path);
    await file.writeAsBytes(pdf.save());
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: FutureBuilder(
      future: _generatePdfAndView(context),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData == false) {
          return Container(
            child: Center(
              child: Text("You have not added any Course"),
            ),
          );
        } else {
          return PDFViewerScaffold(
            path: path,
          );
        }
      },
    ));
  }
}
