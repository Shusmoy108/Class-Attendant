import 'package:attendencemeter/src/database/database.dart';
import 'package:attendencemeter/src/pages/home/home.dart';
import 'package:flutter/material.dart';

import 'models/profile.dart';

class App extends StatelessWidget {
  Future<Profile> loadUser() async {
    DatabaseClass dc = new DatabaseClass();
    final pro = await dc.hasuser();
    bool condition = pro;
    if (condition == false) {
      final u = await dc.saveuser(
          "John Doe", "Massachusetts Institute of Technology");
      final user = await dc.getprofile();
      Profile p = new Profile(user['name'], user['institution'], user['id']);
      return p;

      // final user = await dc.getprofile();
      // Profile p = new Profile(user['name'], user['institution'], user['id']);
      // return p;
    } else {
      final user = await dc.getprofile();
      Profile p = new Profile(user['name'], user['institution'], user['id']);
      return p;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Class Attendent',
      debugShowCheckedModeBanner: false,
      //home: new Home(),
      home: FutureBuilder(
        future: loadUser(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Home(snapshot.data);
            //return
            //return MapSample(mobile);
            //return demo();
            //return MainPage(mobile);

          } else {
            return Container(
              color: Colors.white,
              child: Center(
                  child: CircularProgressIndicator(
                strokeWidth: 2.0,
                backgroundColor: Colors.green,
              )),
            );
          }
        },
      ),
    );
  }
}
