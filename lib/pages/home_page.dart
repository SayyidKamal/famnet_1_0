import 'dart:io';

import 'package:famnet_1_0/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final User? user = Auth().currentuser;
  FirebaseDatabase database = FirebaseDatabase.instance;
  List<dynamic> children = <dynamic>[];

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Future<void> _write() async {
    try {
      DatabaseReference _databaseReference =
          FirebaseDatabase.instance.ref("Users");
      final snapshot = await _databaseReference.get();
      if (snapshot.exists) {
        Map<String, dynamic> _snapshotValue =
            Map<String, dynamic>.from(snapshot.value as Map);
        _snapshotValue.forEach((key, value) {
          children.add(value);

          stdout.writeln('$key : $value');
        });
      } else {
        stdout.writeln('No data available.');
      }
    } on Exception catch (e) {
      stdout.writeln(e.toString());
    }
  }

  Widget _title() {
    return const Text('Firebase Auth');
  }

  Widget _userUid() {
    return Text(user?.email ?? 'User email');
  }

  Widget _signOutBotton() {
    return ElevatedButton(onPressed: signOut, child: const Text('Sign Out'));
  }

  Widget _writeButton() {
    return ElevatedButton(onPressed: _write, child: const Text('Write Out'));
  }

  Widget _myList() {
    final List<String> entries = <String>['A', 'B', 'C', 'D', 'E', 'F', 'G'];
    final List<int> colorCodes = <int>[800, 700, 600, 500, 400, 300, 200];
    _write;

    return Container(
        height: 150,
        alignment: Alignment.center,
        child: ListView.separated(
          itemCount: entries.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
                height: 50,
                color: Colors.amber[colorCodes[index]],
                child: Center(
                  child: Text(children[index]['email']),
                ));
          },
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
        )); /*return ListView.builder(
      itemCount: children.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(children[index]
              ['email']), // adjust this according to your data structure
          subtitle: Text(children[index]
              ['name']), // adjust this according to your data structure
        );
      },
    );*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _userUid(),
            _writeButton(),
            _signOutBotton(),
            _myList()
          ],
        ),
      ),
    );
  }
}
