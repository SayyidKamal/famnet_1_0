import 'package:flutter/material.dart';

class CommonWidgets {
  static Widget title(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
    );
  }

  static Widget subTitle(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
    );
  }

  static Widget bodyText(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
    );
  }

  static Widget primaryButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }

  static Widget secondaryButton(String text, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }

  static Widget textField(String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
