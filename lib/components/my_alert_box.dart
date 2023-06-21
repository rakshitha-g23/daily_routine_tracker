// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

class MyAlertBox extends StatelessWidget {
  final controller;
  final String hintText;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const MyAlertBox({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[300],
      content: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[600]),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
      actions: [
        MaterialButton(
          onPressed: onSave,
          color: Theme.of(context).primaryColor,
          child: const Text(
            "Save",
            style: TextStyle(color: Colors.white),
          ),
        ),
        MaterialButton(
          onPressed: onCancel,
          color: Theme.of(context).primaryColor,
          child: const Text(
            "Cancel",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
