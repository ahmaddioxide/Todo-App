import 'package:flutter/material.dart';// UI toolkit
import 'package:get/get.dart';//Package for state management
import 'views/pending_tasks_screen.dart';// Project level import

// * Please follow this imports precedence in this whole project

/* ------ Imports precedence from high to low ------
* ------- Followed at our Company Level ------------
*
* Language imports i.e. import 'dart:io';

* Framework/UI toolkit imports i.e. import 'package:flutter/material.dart';

* External Library/Package imports i.e. ';import 'package:get/get.dart';

* Project level imports i.e. import 'package:todo_app/views/pending_tasks_screen.dart';

* Project level sub imports i.e. import 'views/pending_tasks_screen.dart';

* For more info: https://dart.dev/language/libraries#using-libraries
*/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const PendingTasksScreen(),
    );
  }
}
