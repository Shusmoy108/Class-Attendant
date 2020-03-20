import 'package:attendencemeter/src/models/attendence.dart';
import 'package:built_collection/built_collection.dart';
import 'package:attendencemeter/src/models/course.dart';
import 'package:attendencemeter/src/models/student.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseClass {
  String dbPath = 'sample.db';
  DatabaseFactory dbFactory = databaseFactoryIo;
  Database db;
  Future<bool> saveCourse(String name) async {
    var dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    var dbPath = join(dir.path, 'attendencemeter.db');
    var db = await databaseFactoryIo.openDatabase(dbPath);
    var store = intMapStoreFactory.store('courses');
    var finder = Finder(
      filter: Filter.equals('courseName', name),
    );
    var records = await store.find(db, finder: finder);
    if (records.length == 0) {
      Course course = new Course(name);
      await db.transaction((txn) async {
        //course.editId(txn);
        await store.add(txn, course.toJson());
        return true;
        //await store.add(txn, {'name': 'cat'});
      });
    } else {
      return false;
    }
  }

  Future<bool> saveAttendence(Attendence attendence) async {
    var dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    var dbPath = join(dir.path, 'attendencemeter.db');
    var db = await databaseFactoryIo.openDatabase(dbPath);
    var store = intMapStoreFactory.store('attendences');
    var finder = Finder(
      filter: Filter.and([
        Filter.equals('courseName', attendence.courseName),
        Filter.equals('time', attendence.time)
      ]),
    );
    var records = await store.find(db, finder: finder);
    if (records.length == 0) {
      await db.transaction((txn) async {
        //course.editId(txn);
        await store.add(txn, attendence.toJson());
        //await store.add(txn, {'name': 'cat'});
        return true;
      });
    } else {
      return false;
    }
  }

  Future<bool> saveStudent(Student student) async {
    var dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    var dbPath = join(dir.path, 'attendencemeter.db');
    var db = await databaseFactoryIo.openDatabase(dbPath);
    var store = intMapStoreFactory.store('students');
    var finder = Finder(
        filter: Filter.and([
      Filter.equals('studentId', student.studentId),
      Filter.equals("name", student.name)
    ]));
    var records = await store.find(db, finder: finder);
    if (records.length == 0) {
      await db.transaction((txn) async {
        //course.editId(txn);
        await store.add(txn, student.toJson());
        return true;
        //await store.add(txn, {'name': 'cat'});
      });
    } else {
      return false;
    }
  }

  Future<bool> saveuser(String name, String institution) async {
    var dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    var dbPath = join(dir.path, 'attendencemeter.db');
    var db = await databaseFactoryIo.openDatabase(dbPath);
    var store = intMapStoreFactory.store('profile');
    await db.transaction((txn) async {
      await store.add(txn, {'name': name, 'institution': institution});
    });
    return true;
  }

  void updateCourse(Course course) async {
    // finder is used to filter the object out for update
    var dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    var dbPath = join(dir.path, 'attendencemeter.db');
    var db = await databaseFactoryIo.openDatabase(dbPath);
    var store = intMapStoreFactory.store('courses');
    final finder = Finder(filter: Filter.byKey(course.id));
    await store.update(db, course.toJson(), finder: finder);
  }

  void updateAttendence(Attendence attendence) async {
    // finder is used to filter the object out for update
    var dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    var dbPath = join(dir.path, 'attendencemeter.db');
    var db = await databaseFactoryIo.openDatabase(dbPath);
    var store = intMapStoreFactory.store('attendences');
    final finder = Finder(filter: Filter.byKey(attendence.id));
    await store.update(db, attendence.toJson(), finder: finder);
  }

  void updateCourseafterStudentAdd(Course course, Student student) async {
    // finder is used to filter the object out for updat
    var dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    var dbPath = join(dir.path, 'attendencemeter.db');
    var db = await databaseFactoryIo.openDatabase(dbPath);
    var store = intMapStoreFactory.store('students');
    var finder = Finder(
        filter: Filter.and([
      Filter.equals('studentId', student.studentId),
      Filter.equals("name", student.name)
    ]));
    var records = await store.find(db, finder: finder);
    course.addStudentId(records[0].key);
    var store2 = intMapStoreFactory.store('courses');
    var finder2 = Finder(filter: Filter.byKey(course.id));
    await store2.update(db, course.toJson(), finder: finder2);
  }

  void updateCourseafterStudentDelete(int courseId, int studentId) async {
    // finder is used to filter the object out for update
    var dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    var dbPath = join(dir.path, 'attendencemeter.db');
    var db = await databaseFactoryIo.openDatabase(dbPath);
    var store = intMapStoreFactory.store('courses');
    final finder = Finder(filter: Filter.byKey(courseId));
    var records = await store.find(db, finder: finder);
    Course course = new Course(records[0]['courseName']);
    course.studentId = new BuiltList<int>(records[0].value['studentId']);
    course.removeStudentId(studentId);
    course.editId(courseId);
    final finder2 = Finder(filter: Filter.byKey(course.id));
    await store.update(db, course.toJson(), finder: finder2);
  }

  void updateStudent(Student student) async {
    // finder is used to filter the object out for update
    var dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    var dbPath = join(dir.path, 'attendencemeter.db');
    var db = await databaseFactoryIo.openDatabase(dbPath);
    var store = intMapStoreFactory.store('students');
    final finder = Finder(filter: Filter.byKey(student.id));

    await store.update(db, student.toJson(), finder: finder);
  }

  void updateProfile(int id, String name, String institution) async {
    // finder is used to filter the object out for update
    var dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    var dbPath = join(dir.path, 'attendencemeter.db');
    var db = await databaseFactoryIo.openDatabase(dbPath);
    var store = intMapStoreFactory.store('profile');
    final finder = Finder(filter: Filter.byKey(id));
    await store.update(db, {'name': name, 'institution': institution},
        finder: finder);
  }

  void deleteCourse(int id) async {
    //get refence to object to be deleted using the finder method of sembast,
    //specifying it's id
    var dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    var dbPath = join(dir.path, 'attendencemeter.db');
    var db = await databaseFactoryIo.openDatabase(dbPath);
    var store = intMapStoreFactory.store('courses');
    final finder = Finder(filter: Filter.byKey(id));
    await store.delete(db, finder: finder);
  }

  void deleteAttendence(int id) async {
    //get refence to object to be deleted using the finder method of sembast,
    //specifying it's id
    var dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    var dbPath = join(dir.path, 'attendencemeter.db');
    var db = await databaseFactoryIo.openDatabase(dbPath);
    var store = intMapStoreFactory.store('attendences');
    final finder = Finder(filter: Filter.byKey(id));
    await store.delete(db, finder: finder);
  }

  void deleteStudent(Student student) async {
    //get refence to object to be deleted using the finder method of sembast,
    //specifying it's id
    var dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    var dbPath = join(dir.path, 'attendencemeter.db');
    var db = await databaseFactoryIo.openDatabase(dbPath);
    var store = intMapStoreFactory.store('students');
    for (int i = 0; i < student.courses.length; i++) {
      updateCourseafterStudentDelete(student.courses[i], student.id);
    }
    final finder = Finder(filter: Filter.byKey(student.id));
    await store.delete(db, finder: finder);
  }

  Future<bool> hasuser() async {
    var dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    var dbPath = join(dir.path, 'attendencemeter.db');
    var db = await databaseFactoryIo.openDatabase(dbPath);
    var store = intMapStoreFactory.store('profile');
    //store.delete(db);
    var records = await store.find(db);
    if (records.length == 0) {
      return false;
    } else {
      return true;
    }
  }

  Future getprofile() async {
    var dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    var dbPath = join(dir.path, 'attendencemeter.db');
    var db = await databaseFactoryIo.openDatabase(dbPath);
    var store = intMapStoreFactory.store('profile');
    var records = await store.find(db);
    if (records.length == 0) {
      return false;
    } else {
      return {
        "name": records[0]['name'],
        "institution": records[0]['institution'],
        "id": records[0].key
      };
    }
  }

  Future<List<Student>> findCourseStudents(String courseName) async {
    List<Student> students;
    // finder is used to filter the object out for update
    var dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    var dbPath = join(dir.path, 'attendencemeter.db');
    var db = await databaseFactoryIo.openDatabase(dbPath);
    var store = intMapStoreFactory.store('courses');
    final finder = Finder(filter: Filter.equals("courseName", courseName));
    var record = await store.find(db, finder: finder);
    Course c = Course(record[0]['courseName']);
    c.studentId = new BuiltList<int>(record[0].value['studentId']);
    final stndts = await getstudents();
    students = stndts;
    List<Student> coursestudents = new List();
    for (int i = 0; i < students.length; i++) {
      if (c.studentId.contains(students[i].id)) {
        coursestudents.add(students[i]);
      }
    }
    return coursestudents;
  }

  Future<List<Course>> getcourses() async {
    List<Course> courses = List();
    var dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    var dbPath = join(dir.path, 'attendencemeter.db');
    var db = await databaseFactoryIo.openDatabase(dbPath);
    var store = intMapStoreFactory.store('courses');
    var records = await store.find(db);
    //store.delete(db);
    for (var i = 0; i < records.length; i++) {
      Course c = Course(records[i]['courseName']);
      c.studentId = new BuiltList<int>(records[i].value['studentId']);
      c.editId(records[i].key);
      courses.add(c);
    }

    return courses;
  }

  Future<List<Attendence>> getattendences() async {
    List<Attendence> attendences = List();
    var dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    var dbPath = join(dir.path, 'attendencemeter.db');
    var db = await databaseFactoryIo.openDatabase(dbPath);
    var store = intMapStoreFactory.store('attendences');
    var finder = Finder(sortOrders: [SortOrder('time')]);
    var records = await store.find(db, finder: finder);
    //store.delete(db);
    for (var i = 0; i < records.length; i++) {
      Attendence a =
          new Attendence(records[i]['courseName'], records[i]['time']);
      a.editId(records[i].key);
      a.presentId = new BuiltList<int>(records[i].value['presentId']);
      attendences.add(a);
    }

    return attendences;
  }

  Future<List<Attendence>> getattendencesbyCourseName(String courseName) async {
    List<Attendence> attendences = List();
    var dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    var dbPath = join(dir.path, 'attendencemeter.db');
    var db = await databaseFactoryIo.openDatabase(dbPath);
    var store = intMapStoreFactory.store('attendences');
    final finder = Finder(
        filter: Filter.equals("courseName", courseName),
        sortOrders: [SortOrder("time")]);
    var records = await store.find(db, finder: finder);
    //store.delete(db);
    for (var i = 0; i < records.length; i++) {
      Attendence a =
          new Attendence(records[i]['courseName'], records[i]['time']);
      a.editId(records[i].key);
      a.presentId = new BuiltList<int>(records[i].value['presentId']);
      attendences.add(a);
    }

    return attendences;
  }
  //delete _todo item

  Future<List<Student>> getstudents() async {
    List<Student> students = List();
    var dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    var dbPath = join(dir.path, 'attendencemeter.db');
    var db = await databaseFactoryIo.openDatabase(dbPath);
    var store = intMapStoreFactory.store('students');
    var finder = Finder(sortOrders: [SortOrder('studentId')]);
    var records = await store.find(db, finder: finder);
    //store.delete(db);
    for (var i = 0; i < records.length; i++) {
      Student s = Student(records[i]['studentId'], records[i]['name']);
      s.courses = new BuiltList<int>(records[i]['courses']);
      s.editId(records[i].key);
      students.add(s);
    }
    return students;
  }

  Future<List<Student>> getcoursestudents(Course c) async {
    List<Student> students = List();
    var dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    var dbPath = join(dir.path, 'attendencemeter.db');
    var db = await databaseFactoryIo.openDatabase(dbPath);
    var store = intMapStoreFactory.store('students');
    var finder = Finder(sortOrders: [SortOrder('studentId')]);
    var records = await store.find(db, finder: finder);
    for (var i = 0; i < records.length; i++) {
      if (c.studentId.contains(records[i].key)) {
        Student s = Student(records[i]['studentId'], records[i]['name']);
        s.courses = new BuiltList<int>(records[i]['courses']);
        s.editId(records[i].key);
        students.add(s);
      }
    }
    return students;
  }

  void init() async {
    db = await dbFactory.openDatabase(dbPath);
    var store = StoreRef.main();
// Easy to put/get simple values or map
// A key can be of type int or String and the value can be anything as long is it can
// be properly JSON encoded/decoded

    await store.record('title').put(db, 'Simple application');
    await store.record('version').put(db, 10);
    await store.record('settings').put(db, {'offline': true});

// read values
    var title = await store.record('title').get(db) as String;
    var version = await store.record('version').get(db) as int;
    var settings = await store.record('settings').get(db) as Map;

// ...and delete
    await store.record('courses').delete(db);
  }

  void store() async {
    var dir = await getApplicationDocumentsDirectory();
// make sure it exists
    await dir.create(recursive: true);
// build the database path
    var dbPath = join(dir.path, 'my_database.db');
// open the database
    var db = await databaseFactoryIo.openDatabase(dbPath);
    var store = intMapStoreFactory.store('animals');
//await store.record(10).put({'name': 'dog'});
// Store some objects
    await db.transaction((txn) async {
      await store.add(txn, {'name': 'fish', 'lopa': 'kola'});
      await store.add(txn, {'name': 'cat'});

      // You can specify a key
    });
    var finder = Finder(
        filter: Filter.greaterThan('name', 'cat'),
        sortOrders: [SortOrder('name')]);
    var records = await store.find(db, finder: finder);
  }
}
