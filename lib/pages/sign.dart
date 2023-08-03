
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_x_database/pages/components/container_text_field.dart';
import 'package:flutter_x_database/pages/login.dart';
import 'package:http/http.dart' as http;

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
        String uri = "http://10.0.2.2/rest_api/login.php";
        var res = await http.post(Uri.parse(uri), body: {
          "login": login.text,
          "password": pass.text, // Warto?? 'password' musi odpowiada? nazwie pola w bazie danych
        });

        print("Response Body: ${res.body}");

        var response = jsonDecode(res.body);
        if (response["success"] == "true") {
          print("You are Signed Up");
        } else {
          print("You have got some issues");
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
                    labelName: "Login",
                    controller: login,
                  ),
                ),
                 Padding(
                  padding:  EdgeInsets.all(10.0),
                  child: ContainerTextField(
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