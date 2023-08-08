import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DatabaseReference database = FirebaseDatabase.instance.ref('SalesTracker');
  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat.yMMMM('en_US');
  final PageController pageController = PageController(initialPage: 0);
  late int _selectedIndex = 0;

  static Future<List<dynamic>> write() async {
    List<dynamic> users = [];

    try {
      DatabaseReference _databaseReference =
          FirebaseDatabase.instance.ref("SalesTracker");
      final snapshot = await _databaseReference.get();
      if (snapshot.exists) {
        Map<String, dynamic> _snapshotValue =
            Map<String, dynamic>.from(snapshot.value as Map);
        _snapshotValue.forEach((key, value) {
          users.add(key);
          stdout.writeln('$key : $value');
        });

        stdout.writeln(users.length);
      } else {
        stdout.writeln('No data available.');
      }
    } on Exception catch (e) {
      stdout.writeln(e.toString());
    }
    return users;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("To-Do List"),
          actions: [
            IconButton(
              onPressed: () {
                // Add your onPressed logic here
              },
              icon: const Icon(CupertinoIcons.calendar),
            ),
          ],
        ),

        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            database
                .set(formatter.format(now))
                .then(
                  (_) => Fluttertoast.showToast(
                      msg: formatter.format(now),
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.SNACKBAR,
                      backgroundColor: Colors.black54,
                      textColor: Colors.white,
                      fontSize: 14.0),
                )
                .catchError(
                  (error) => Fluttertoast.showToast(
                      msg: "Failed: $error",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.SNACKBAR,
                      backgroundColor: Colors.black54,
                      textColor: Colors.white,
                      fontSize: 14.0),
                );
            /*showDialog(
              context: context,
              builder: (BuildContext context) {
                return const AddTaskAlertDialog();
              },
            );*/
          },
          child: const Icon(Icons.add),
        ),
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 6.0,
          clipBehavior: Clip.antiAlias,
          child: SizedBox(
            height: kBottomNavigationBarHeight,
            child: BottomNavigationBar(
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.brown,
              unselectedItemColor: Colors.black,
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                  pageController.jumpToPage(index);
                });
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.square_list),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.tag),
                  label: '',
                ),
              ],
            ),
          ),
        ),
        // The body of your Scaffold goes here
      ),
    );
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
