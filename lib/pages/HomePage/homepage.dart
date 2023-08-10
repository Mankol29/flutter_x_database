import 'package:flutter/material.dart';

<<<<<<< HEAD
import '../components/EditUserPage.dart';
import '../components/UserRoleAdd.dart';
import '../login.dart';
import 'adminFolder/adminFeatures/add_users_container.dart';
import 'adminFolder/adminFeatures/edit_users_container.dart';
import 'adminFolder/adminFeatures/show_table.dart';
import 'adminFolder/tables_page_list.dart';
=======
import '../admin folder/EditUserPage.dart';
import '../admin folder/UserRoleAdd.dart';
import '../login.dart';
import 'admin folder/admin features/add_users_container.dart';
import 'admin folder/admin features/edit_users_container.dart';
import 'admin folder/admin features/show_table.dart';
import 'admin folder/tables_page_list.dart';
>>>>>>> a5b91d9ee5115846dc149f10e06d36d56be8e482

class HomePage extends StatelessWidget {

   final String userRole; // Dodaj pole userRole w konstruktorze

  const HomePage({super.key, required this.userRole});

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

              if(userRole == "Administrator")
              GestureDetector(
                 onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  TableListPage()),
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


