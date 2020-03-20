import 'package:attendencemeter/src/models/student.dart';
import 'package:built_collection/built_collection.dart';

class Course {
  String courseName;
  BuiltList<int> studentId = new BuiltList();
  BuiltList<Student> students;
  int id;
  Course(this.courseName);
  addStudentId(int id) {
    this.studentId = (this.studentId.toBuilder()..add(id)).build();
  }

  removeStudentId(int id) {
    this.studentId = (this.studentId.toBuilder()..remove(id)).build();
  }

  addStudent(Student s) {
    this.students = (this.students.toBuilder()..add(s)).build();
  }

  removeStudent(Student s) {
    (this.students.toBuilder()..remove(s)).build();
  }

  editCourseName(String name) {
    this.courseName = name;
  }

  editId(int id) {
    this.id = id;
  }

  Course.fromJson(Map<String, dynamic> json)
      : courseName = json['courseName'],
        id = json['id'],
        students = json['students'],
        studentId = json['studentId'];

  Map<String, dynamic> toJson() => {
        'courseName': courseName,
        'id': id,
        //'students': jsonEncode(students.toBuilder()),
        'studentId': studentId,
      };
}
