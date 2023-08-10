import 'package:flutter/material.dart';

class AddUsersContainer extends StatelessWidget {
  const AddUsersContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.purple,
        ),
      height: 70,
      child: const Center(
        child: Text(
          "Dodawanie uzytkownikow przez adminow.",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          ),
      )
      );
  }
}