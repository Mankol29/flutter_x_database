import 'package:flutter/material.dart';
import 'package:flutter_x_database/pages/sign.dart';

import 'components/container_text_field.dart';

class Login extends StatefulWidget {
  const Login({
    super.key,
  });

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController login=TextEditingController();
  TextEditingController pass=TextEditingController();

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
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ContainerTextField(
                    labelName: "Password",
                    isPassword: true,
                  )
                ),

                ElevatedButton(
                  onPressed: (){}, 
                  child: Text("Log In")
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
                      // Przejd? do ekranu SignIn po klikni?ciu w CircleAvatar
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
              onTap: () =>  Navigator.push(
                context, MaterialPageRoute(builder: (context )=> SignUp())),
                     child: const Text(
                      "Log In", 
                      style: TextStyle(
                        fontSize: 50, 
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),
                                     ),
                   ),
                  Text("Tap the circle to Sign up")
                ],
              ),
             ),
          ],
        ),
      ),
    );
  }
}

