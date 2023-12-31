// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

class alertLogin extends StatelessWidget {

  final String errorName;
  final String errorTitle;


  const alertLogin({
    super.key, 
    required this.errorName, 
    required this.errorTitle});
  

  @override
  Widget build(BuildContext context) {
    return  AlertDialog(
    actions: [
      TextButton(
        onPressed: () {
          Navigator.of(context).pop(); //Zamknij okno dialogowe
        },
        child: const Text("Close"),
      ),
    ],
    title:  Text(
      errorTitle,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
      ),
    ),
    content: Text(errorName,
      style: const TextStyle(
        fontSize: 20,
      ),
    ),
);
  }
}