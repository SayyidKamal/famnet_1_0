import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DeleteUserDialog extends StatefulWidget {
  final String userId, userName;

  const DeleteUserDialog(
      {Key? key, required this.userId, required this.userName})
      : super(key: key);

  @override
  State<DeleteUserDialog> createState() => _DeleteUserDialogState();
}

class _DeleteUserDialogState extends State<DeleteUserDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: const Text(
        'Delete User',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, color: Colors.brown),
      ),
      content: SizedBox(
        child: Form(
          child: Column(
            children: <Widget>[
              const Text(
                'Are you sure you want to delete this user?',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 15),
              Text(
                widget.userName.toString(),
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.grey,
          ),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            _deleteUsers();
            Navigator.of(context, rootNavigator: true).pop();
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.brown,
          ),
          child: const Text('Delete'),
        ),
      ],
    );
  }

  Future _deleteUsers() async {
    String userId = widget.userId;
    var database = FirebaseDatabase.instance.ref('users/$userId');
    database
        .remove()
        .then(
          (_) => Fluttertoast.showToast(
              msg: "User deleted successfully",
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
  }
}
