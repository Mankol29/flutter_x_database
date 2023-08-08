import 'package:flutter/material.dart';

class EditUsersContainer extends StatelessWidget {
  const EditUsersContainer({
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
          "Kliknij, aby zmienic uprawnienia uzytkownikow.",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          ),
      )
      );
  }
}
