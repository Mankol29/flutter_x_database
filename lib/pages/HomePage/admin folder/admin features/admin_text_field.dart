import 'package:flutter/material.dart';

class AdminTextField extends StatelessWidget {
  final String labelName;

  final TextEditingController? controller;
  

  const AdminTextField({
    Key? key,
    this.controller, 
    required this.labelName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(15.0),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          color: Colors.white,
        ),
        height: 70,
        child: TextField(
          controller: controller,
          textAlign: TextAlign.center, // Wy?rodkowanie tekstu wewn?trz TextField
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            labelText: labelName
          ),
        ),
      ),
    );
  }
}
