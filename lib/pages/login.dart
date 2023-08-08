// ignore_for_file: use_build_context_synchronously, avoid_print, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_x_database/pages/sign.dart';
import 'components/container_text_field.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'HomePage/home_page.dart';

class Login extends StatefulWidget {
  const Login({
    Key? key,
  }) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController login = TextEditingController();
  TextEditingController pass = TextEditingController();

  Future<void> _handleLogin() async {
    String loginValue = login.text;
    String passwordValue = pass.text;

    if (loginValue.isEmpty || passwordValue.isEmpty) {
      print("Please fill in both fields");
      return;
    }

    try {
      String uri = "http://10.0.2.2/rest_api/login.php";
      var res = await http.post(Uri.parse(uri), body: {
        "login": loginValue,
        "password": passwordValue,
      });

      if (res.statusCode == 200) {
        var response = jsonDecode(res.body);
        if (response["success"] == true) {
          String userRole = await _getUserRoleFromServer(loginValue);

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage(userRole: userRole)),
          );
        } else {
          print("Invalid login or password");
          pass.clear();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Invalid login or password"),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
        }
      } else {
        print("Connection error: ${res.statusCode}");
      }
    } catch (e) {
      print("An error occurred: $e");
    }
  }

  Future<String> _getUserRoleFromServer(String login) async {
  try {
    String uri = "http://10.0.2.2/rest_api/get_user_role.php?login=$login";
    var res = await http.get(Uri.parse(uri));

    if (res.statusCode == 200) {
      var response = jsonDecode(res.body);
      return response["role"];
    } else {
      print("Error getting user role");
      return "";
    }
  } catch (e) {
    print("An error occurred: $e");
    return "";
  }
}


  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.deepPurple[200],
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ContainerTextField(
                    labelName: "Login",
                    isPassword: false,
                    controller: login,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ContainerTextField(
                    labelName: "Password",
                    isPassword: true,
                    controller: pass,
                  ),
                ),
                ElevatedButton(
                  onPressed: _handleLogin,
                  child: Text("Log In"),
                ),
              ],
            ),
            Stack(
              children: [
                Positioned(
                  top: -(screenHeight / 5),
                  left: 5,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUp(),
                        ),
                      );
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.deepPurple,
                      maxRadius: 200,
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 55,
              child: Column(
                children: [
                  InkWell(
                    onTap: () => Navigator.push(
                        context, MaterialPageRoute(builder: (context) => SignUp())),
                    child: const Text(
                      "Log In",
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text("Tap the circle to Sign up"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
