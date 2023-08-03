import 'package:flutter/material.dart';

class ContainerTextField extends StatelessWidget {
  final String labelName;
  final TextEditingController? controller;

  const ContainerTextField({
    Key? key,
    required this.labelName, 
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
          labelText: labelName,
        ),
      ),
    );
  }
}
