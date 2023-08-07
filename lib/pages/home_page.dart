import 'package:flutter/material.dart';
import 'package:flutter_x_database/pages/admin%20folder/UserRoleAdd.dart';
import 'package:flutter_x_database/pages/login.dart';

class HomePage extends StatelessWidget {
  final String userRole; // Dodaj pole userRole w konstruktorze

  const HomePage({required this.userRole, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (userRole == "Administrator") // Sprawdzamy rol?
              GestureDetector(
                child: const Text("Dodawanie u?ytkowników i ustawianie im roli."),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserRoleAdd()),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
