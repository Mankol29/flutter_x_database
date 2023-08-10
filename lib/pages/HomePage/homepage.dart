import 'package:flutter/material.dart';

import '../../EditFiles/EditUserPage.dart';
import '../../addFiles/UserRoleAdd.dart';
import '../login.dart';
import '../../addFiles/add_users_container.dart';
import '../../EditFiles/edit_users_container.dart';
import 'show_table.dart';
import 'adminFolder/tables_page_list.dart';

class HomePage extends StatelessWidget {

   final String userRole; // Dodaj pole userRole w konstruktorze

  const HomePage({super.key, required this.userRole});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
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
            icon: const Icon(Icons.logout), // Ikona przycisku "Wyloguj"
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

              if(userRole == "Administrator")
              GestureDetector(
                 onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  const TableListPage()),
                ),
                child:
                const Padding(
                 padding: EdgeInsets.only(top:20.0, left: 8,right: 8),
                 child: ShowTable(),
                    ),
      ),],
        ),
      ));
  }
}


