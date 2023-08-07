
// ignore_for_file: use_build_context_synchronously, avoid_print, prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_x_database/pages/components/container_text_field.dart';
import 'package:flutter_x_database/pages/login.dart';
import 'package:http/http.dart' as http;

import 'admin folder/admin features/alert_login_exists.dart';


class SignUp extends StatefulWidget {
  const SignUp({
    super.key,
  });

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  TextEditingController login = TextEditingController();
  TextEditingController pass = TextEditingController();

  Future<void> insertLoginData() async {
  if (login.text != "" || pass.text != "") {
    try {
      String uri = "http://10.0.2.2/rest_api/signup.php";
      var res = await http.post(Uri.parse(uri), body: {
        "login": login.text,
        "password": pass.text, 
      });

      print("Response Body: ${res.body}");

      var response = jsonDecode(res.body);
      if (response["success"] == "true") {
          showDialog(
  context: context,
  builder: (context) => AlertDialog(
    actions: [
      TextButton(
        onPressed: () {
          Navigator.of(context).pop(); //Zamknij okno dialogowe
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Login()), // przejdz do ekranu logowania
          );
        },
        child: const Text("Close"),
      ),
    ],
    title: const Text(
      "You have successfully signed up",
      style: TextStyle(
        fontWeight: FontWeight.bold,
      ),
    ),
    content: const Text(
      "Now you can Log in",
      style: TextStyle(
        fontSize: 20,
      ),
    ),
  ),
);

        print("You are Signed Up");
      } else {
        
        showDialog(
          context: context,
            builder: (context) => alertLogin(
              errorTitle: " Login already exists.",
              errorName: "Please type a different login.",
            ));

        print(response["message"]);
      }
    } catch (e) {
      print(e);
    }
  } else {
    print("Please fill all fields");
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
                  padding:  EdgeInsets.all(10.0),
                  child: ContainerTextField(
                    isPassword: false,
                    labelName: "Login",
                    controller: login,
                  ),
                ),
                 Padding(
                  padding:  EdgeInsets.all(10.0),
                  child: ContainerTextField(
                    isPassword: true,
                    labelName: "Password",
                    controller: pass,
                  ),
                ),
                ElevatedButton(
                  onPressed: (){
                      insertLoginData();

                  }, 
                  child: const Text("Sign In")
                  ),
              ],
            ),
             Stack(
              children:[ 
                Positioned(
                top: (screenHeight / 1.4),// Ustaw pozycje CircleAvatar
                left: 5 ,
                  child: GestureDetector(
                    onTap: () {
                      // Przejd? do ekranu SignIn po klikni?ciu w CircleAvatar
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Login(),
                        ),
                      );
                    },
                    child: const CircleAvatar(
                      backgroundColor: Colors.deepPurple,
                      maxRadius: 200,
                      ),
                  ),
                ),            
              ],
            ),
             Positioned(
              top: (screenHeight/ 1.2),
              child: Column(
                children: [
                   InkWell(
              onTap: () =>  Navigator.push(
                context, MaterialPageRoute(builder: (context )=> Login())),
                     child: const Text(
                      "Sign Up", 
                      style: TextStyle(
                        fontSize: 50, 
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),
                                     ),
                   ),
                  Text("Tap the circle to Log in")
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}