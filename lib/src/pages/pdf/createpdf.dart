import 'dart:io';
import 'package:attendencemeter/src/models/profile.dart';
import 'package:attendencemeter/src/pages/pdf/pdfviewerpage.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

class PdfGeneratorDemo extends StatelessWidget {
  List<List<String>> row;
  Profile p;
  PdfGeneratorDemo(this.row, this.p, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pdf - generate and view'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.picture_as_pdf),
            onPressed: () => _generatePdfAndView(context),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: Container(),
    );
  }

  _generatePdfAndView(context) async {
    final pdfLib.Document pdf = pdfLib.Document(deflate: zlib.encode);

    pdf.addPage(
      pdfLib.MultiPage(
        pageFormat: PdfPageFormat.a3,
        margin: pdfLib.EdgeInsets.all(5),

        //footer: pdfLib.Paragraph(text: "Class Attendant"),
        build: (context) => [
          pdfLib.Center(child: pdfLib.Paragraph(text: p.institution)),
          pdfLib.Table.fromTextArray(context: context, data: row)
        ],
      ),
    );

    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String path = '$dir/baseball_teams.pdf';
    final File file = File(path);
    await file.writeAsBytes(pdf.save());
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (_) => PdfViewerPage(path: path),
    //   ),
    // );
  }
}
