import 'dart:io';
import 'dart:math' as math;

import 'package:famnet_1_0/Widgets/common_widgets.dart';
import 'package:famnet_1_0/Widgets/delete_user_dialog.dart';
import 'package:famnet_1_0/Widgets/update_user_dialog.dart';
import 'package:famnet_1_0/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';

class myUsers extends StatefulWidget {
  const myUsers({super.key});
  static final String id = 'users_screen';

  @override
  State<myUsers> createState() => _myUsersState();
}

class _myUsersState extends State<myUsers> {
  List<dynamic> _users = [];
  final User? user = Auth().currentuser;

  @override
  void initState() {
    super.initState();
    _setupUsers();
  }

  static Future<List<dynamic>> write() async {
    List<dynamic> users = [];

    try {
      DatabaseReference _databaseReference =
          FirebaseDatabase.instance.ref("Users");
      final snapshot = await _databaseReference.get();
      if (snapshot.exists) {
        Map<String, dynamic> _snapshotValue =
            Map<String, dynamic>.from(snapshot.value as Map);
        _snapshotValue.forEach((key, value) {
          users.add(value);
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

  _setupUsers() async {
    List<dynamic> users = await write();
    setState(() {
      _users = users;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: CommonWidgets.title('Users ${user!.email}'),
          backgroundColor: Colors.indigo[900],
        ),
        body: RefreshIndicator(
            onRefresh: () => _setupUsers(),
            child: ListView.builder(
                itemCount: _users.length,
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
                        title: Text(_users[index]['name']),
                        subtitle: Text(_users[index]['email']),
                        isThreeLine: true,
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
                                  String userId = (_users[index]['id']);
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
                                  );
                                },
                              ),
                              PopupMenuItem(
                                value: 'delete',
                                child: const Text(
                                  'Delete',
                                  style: TextStyle(fontSize: 13.0),
                                ),
                                onTap: () {
                                  String userId = (_users[index]['id']);
                                  String userName = (_users[index]['name']);
                                  Future.delayed(
                                    const Duration(seconds: 0),
                                    () => showDialog(
                                      context: context,
                                      builder: (context) => DeleteUserDialog(
                                          userId: userId, userName: userName),
                                    ),
                                  );
                                },
                              ),
                            ];
                          },
                        ),
                      ));
                })));
  }
}
