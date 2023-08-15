import 'package:famnet_1_0/BadiBaby/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const BadiApp());
}

class BadiApp extends StatelessWidget {
  const BadiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.banafScents,
      ),
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppColors.banafScents,
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
        body: MyApp(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            /*database
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
            );*/
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
          /*child: SizedBox(
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
          ),*/
        ),
      ),
    );
  }
}
