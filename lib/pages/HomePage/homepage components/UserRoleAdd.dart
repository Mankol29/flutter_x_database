// ignore_for_file: file_names, avoid_print, use_build_context_synchronously, prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_x_database/pages/HomePage/admin%20folder/admin%20features/alert_login_exists.dart';
import 'package:http/http.dart' as http;
import '../admin folder/admin features/admin_text_field.dart';

class UserRoleAdd extends StatefulWidget {
  const UserRoleAdd({super.key});

  @override
  State<UserRoleAdd> createState() => _UserRoleAddState();
}

class _UserRoleAddState extends State<UserRoleAdd> {

  TextEditingController login = TextEditingController();
  TextEditingController pass = TextEditingController();
  String selectedRole = "Uzytkownik"; // Default role
  


Future<void> saveAddRole() async {
  String loginValue = login.text;
  String passwordValue = pass.text;

  if (loginValue.isEmpty || passwordValue.isEmpty) {
    print("Please fill in both fields");
    return;
  }

  // Prepare the data to send in the POST request
  Map<String, String> data = {
    "login": loginValue,
    "password": passwordValue,
    "role": selectedRole,
  };

  try {
    String uri = "http://10.0.2.2/rest_api/save_user_role.php"; // Replace with your PHP script URL
    var res = await http.post(Uri.parse(uri), body: data);

    if (res.statusCode == 200) {
      var response = jsonDecode(res.body);
      if (response["success"] != null) {

        showDialog(
          context: context,
            builder: (context) => alertLogin(
              errorTitle: "Done!",
              errorName: "Nice! You've add a new user",
            ));

        print("User role added successfully");

      } else if (response["error"] != null) {
        
        if (response["error"] == "User with the same login already exists") {

          showDialog(
          context: context,
            builder: (context) => alertLogin(
              errorTitle: "You encountered a problem",
              errorName: "Your login is already existing.",
            ));

          print("User with the same login already exists");

        } else {

          showDialog(
          context: context,
            builder: (context) => alertLogin(
              errorTitle: "You encountered a problem",
              errorName: "You have error with adding user role",
            ));

          print("Error adding user role");
        
        }
      }
    } 
  } catch (e) {

    print("An error occurred: $e");

  }
}

  

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Add user account as Admin"),
      ),
      body: Column(
       children:[ 
        AdminTextField(
          labelName: "Enter new login",
          controller: login,
        ),
        AdminTextField(
          labelName: "Enter the password for new login",
          controller: pass,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: (screenHeight),
        padding: const EdgeInsets.all(10.0),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          color: Colors.white,
        ),
            child: Center(
              child: DropdownButton<String>(
                  
                    value: selectedRole,
                    onChanged: (newValue) {
                      setState(() {
                        selectedRole = newValue!;
                      });
                    },
                    items: <String>["Administrator", "Uzytkownik"].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
            ),
          ),
        ),
        ElevatedButton(
        child: Text("Save user"),
        onPressed: () {
          saveAddRole();
          pass.clear();
          login.clear();
        },
        )
       ],
       ));
  }
}