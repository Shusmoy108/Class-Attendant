import 'package:built_collection/built_collection.dart';

class Student {
  String name;
  int id;
  String studentId;
  double totalattendence = 0;
  List<double> attendences = new List();
  BuiltList<int> courses = new BuiltList();
  Student(this.studentId, this.name);
  addcourse(int course) {
    this.courses = (this.courses.toBuilder()..add(course)).build();
  }

  removecourse(int course) {
    this.courses = (this.courses.toBuilder()..remove(course)).build();
  }

  editStudentId(String studentId) {
    this.studentId = studentId;
  }

  editStudentName(String studentName) {
    this.name = studentName;
  }

  editId(int id) {
    this.id = id;
  }

  Student.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        id = json['id'],
        courses = json['courses'],
        studentId = json['studentId'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
        'courses': courses,
        'studentId': studentId,
      };
}
