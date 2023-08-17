import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text("Settings", 
        style: TextStyle(
          fontWeight: FontWeight.bold
          ),
        ),
        backgroundColor: Colors.purple,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: const Column(
        children: [
          ListTile(
            leading: Icon(Icons.person),
            title: Text("User settings"),
          ),
          ListTile(
            title: Text("Settings vol. 1"),
          ),
          ListTile(
            title: Text("Settings vol. 2"),
          ),
          ListTile(
            title: Text("Settings vol. 3"),
          ),
          ListTile(
            title: Text("Settings vol. 4"),
          ),
        ]),
    );
  }
}