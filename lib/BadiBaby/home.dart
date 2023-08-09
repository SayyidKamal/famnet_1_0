import 'dart:io';
import 'dart:math' as math;

import 'package:famnet_1_0/utils/colors.dart';
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
  DatabaseReference database = FirebaseDatabase.instance.ref('SalesTracker/');
  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat.yMMMM('en_US');
  final PageController pageController = PageController(initialPage: 0);
  late int _selectedIndex = 0;
  List<dynamic> _mTracker = [];

  @override
  void initState() {
    super.initState();
    _setupMTrackers();
  }

  _setupMTrackers() async {
    List<dynamic> mTracker = await write();
    setState(() {
      _mTracker = mTracker;
    });
  }

  static Future<List<dynamic>> write() async {
    List<dynamic> mTracker = [];

    try {
      DatabaseReference _databaseReference =
          FirebaseDatabase.instance.ref("SalesTracker/");
      final snapshot = await _databaseReference.get();
      if (snapshot.exists) {
        Map<String, dynamic> _snapshotValue =
            Map<String, dynamic>.from(snapshot.value as Map);
        _snapshotValue.forEach((key, value) {
          mTracker.add(key);
          stdout.writeln('$key : $value');
        });

        stdout.writeln(mTracker.length);
      } else {
        stdout.writeln('No data available.');
      }
    } on Exception catch (e) {
      stdout.writeln(e.toString());
    }
    return mTracker;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Sales Tracker"),
          actions: [
            IconButton(
              onPressed: () {
                // Add your onPressed logic here
              },
              icon: const Icon(CupertinoIcons.calendar),
            ),
          ],
        ),
        body: RefreshIndicator(
            onRefresh: () => _setupMTrackers(),
            child: ListView.builder(
                itemCount: _mTracker.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      height: 70,
                      margin: const EdgeInsets.only(bottom: 15.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: AppColors.shadowColor,
                            blurRadius: 5.0,
                            offset:
                                Offset(0, 5), // shadow direction: bottom right
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: Container(
                          width: 20,
                          height: 20,
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          alignment: Alignment.center,
                          child: CircleAvatar(
                            backgroundColor: Color(
                                    (math.Random().nextDouble() * 0xFFFFFF)
                                        .toInt())
                                .withOpacity(0.5),
                          ),
                        ),
                        title: Text(_mTracker[index]),
                        /*subtitle: Text(_mTracker[index]['email']),*/
                        trailing: PopupMenuButton(
                          itemBuilder: (BuildContext context) {
                            return [
                              PopupMenuItem(
                                value: 'edit',
                                child: const Text(
                                  'Edit',
                                  style: TextStyle(fontSize: 13.0),
                                ),
                                onTap: () {
                                  /*String userId = (_users[index]['id']);
                                  String userName = (_users[index]['name']);
                                  String userEmail = (_users[index]['email']);
                                  String userProfilePhoto =
                                  (_users[index]['profilePhoto']);
                                  Future.delayed(
                                    const Duration(seconds: 0),
                                        () => showDialog(
                                      context: context,
                                      builder: (context) =>
                                          UpdateUserAlertDialog(
                                            userId: userId,
                                            userName: userName,
                                            userEmail: userEmail,
                                            userProfilePhoto: userProfilePhoto,
                                          ),
                                    ),
                                  );*/
                                },
                              ),
                              PopupMenuItem(
                                value: 'delete',
                                child: const Text(
                                  'Delete',
                                  style: TextStyle(fontSize: 13.0),
                                ),
                                onTap: () {
                                  /* String userId = (_users[index]['id']);
                                  String userName = (_users[index]['name']);
                                  Future.delayed(
                                    const Duration(seconds: 0),
                                        () => showDialog(
                                      context: context,
                                      builder: (context) => DeleteUserDialog(
                                          userId: userId, userName: userName),
                                    ),
                                  );*/
                                },
                              ),
                            ];
                          },
                        ),
                      ));
                })),
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
