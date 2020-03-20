import 'package:built_collection/built_collection.dart';

class Attendence {
  String courseName;
  int time;
  int id;
  BuiltList<int> presentId = new BuiltList();
  Attendence(this.courseName, this.time);
  addStudentId(int id) {
    this.presentId = (this.presentId.toBuilder()..add(id)).build();
  }

  removeStudentId(int id) {
    this.presentId = (this.presentId.toBuilder()..remove(id)).build();
  }

  editTime(int time) {
    this.time = time;
  }

  editId(int id) {
    this.id = id;
  }

  Attendence.fromJson(Map<String, dynamic> json)
      : courseName = json['courseName'],
        id = json['id'],
        time = json['time'],
        presentId = json['presentId'];

  Map<String, dynamic> toJson() => {
        'courseName': courseName,
        'time': time,
        'id': id,
        //'students': jsonEncode(students.toBuilder()),
        'presentId': presentId,
      };
}
