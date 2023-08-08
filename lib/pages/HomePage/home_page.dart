import 'package:flutter/material.dart';
import 'package:flutter_x_database/pages/HomePage/homepage%20components/EditUserPage.dart';
import 'package:flutter_x_database/pages/HomePage/homepage%20components/UserRoleAdd.dart';
import 'package:flutter_x_database/pages/login.dart';

import 'admin folder/admin features/add_users_container.dart';
import 'admin folder/admin features/edit_users_container.dart';
import 'admin folder/admin features/show_table.dart';

class HomePage extends StatelessWidget {
  final String userRole; // Dodaj pole userRole w konstruktorze

  const HomePage({required this.userRole, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        centerTitle: true,
        automaticallyImplyLeading: false,
       actions: [
          IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const Login()),
                (Route<dynamic> route) => false,
              );
            },
            icon: Icon(Icons.logout), // Ikona przycisku "Wyloguj"
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (userRole == "Administrator") // sprawdza role
              GestureDetector(
                 onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UserRoleAdd()),
                ),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only( left: 8,right: 8),
                      child: AddUsersContainer(),
                    ),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditUserPage()),
                ),
                child: const Padding(
                  padding: EdgeInsets.only(top:20.0, left: 8,right: 8),
                  child: EditUsersContainer(),
                ),
                
              ),
                  ],
                ),
              ),
             
              if(userRole != "Administrator") // = zwykly uzytkownik
              const Center(child: Text("Ten tekst jest widoczny dla zwyklych uzytkownikow"),),


              GestureDetector(
                 onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  TableListPage()),
                ),
                child: const Column(
                  children: [
                     Padding(
                      padding: EdgeInsets.only(top:20.0, left: 8,right: 8),
                      child: ShowTable(),
                    ),
            
          ],
        ),
      ),],
        ),
      ));
  }
}




