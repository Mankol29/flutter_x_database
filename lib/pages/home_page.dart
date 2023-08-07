import 'package:flutter/material.dart';
import 'package:flutter_x_database/pages/admin%20folder/EditUserPage.dart';
import 'package:flutter_x_database/pages/admin%20folder/UserRoleAdd.dart';
import 'package:flutter_x_database/pages/login.dart';

class HomePage extends StatelessWidget {
  final String userRole; // Dodaj pole userRole w konstruktorze

  const HomePage({required this.userRole, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: []),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (userRole == "Administrator") // Sprawdzamy rol?
              GestureDetector(
                child: const Text("Ten tekst jest widoczny tylko dla adminow"),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserRoleAdd()),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                child: const Text("Kliknij aby zmienic uprawnienia uzytkownikow"),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditUserPage()),
                ),
              ),
              if(userRole != "Administrator")
              Center(child: const Text("Ten tekst jest widoczny dla zwyklych uzytkownikow"))
          ],
        ),
      ),
    );
  }
}
