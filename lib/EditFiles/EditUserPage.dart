// ignore_for_file: file_names, use_key_in_widget_constructors, library_private_types_in_public_api, avoid_print, use_build_context_synchronously, prefer_const_constructors

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../pages/components/user_data.dart';

class EditUserPage extends StatefulWidget {
  @override
  _EditUserPageState createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  List<UserData> userDataList = []; // List to store user data
  late ValueNotifier<String> selectedRoleNotifier; // Add this line

  @override
  void initState() {
    super.initState();
    fetchUserData();
    selectedRoleNotifier = ValueNotifier<String>("Uzytkownik"); // Initialize the notifier
  }

  Future<void> fetchUserData() async {
    try {
      final response =
          await http.get(Uri.parse("http://10.0.2.2/rest_api/fetch_users.php"));

      if (response.statusCode == 200) {
        // Parse response and update user data list
        final List<dynamic> responseData = json.decode(response.body);
        setState(() {
          userDataList = responseData
              .map((userData) => UserData.fromJson(userData))
              .toList();
        });
      }
    } catch (e) {
      print("An error occurred: $e");
    }
  }

   @override
  void dispose() {
    selectedRoleNotifier.dispose(); // Dispose the notifier
    super.dispose();
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text("Edit Users")),
      body: ListView.builder(
        itemCount: userDataList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(userDataList[index].login),
            subtitle: Text(userDataList[index].role),
            trailing: ElevatedButton(
              onPressed: () {
                // Open edit dialog when button is pressed
                _showEditDialog(userDataList[index]);
              },
              child: const Text("Edit"),
            ),
          );
        },
      ),
    );
  }

  Future<void> _showEditDialog(UserData userData) async {
    final newPasswordController = TextEditingController(text: userData.pass);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit User: ${userData.login}"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: newPasswordController),
              ValueListenableBuilder<String>(
                valueListenable: selectedRoleNotifier,
                builder: (context, value, child) {
                  return DropdownButton<String>(
                    value: value,
                    onChanged: (newValue) {
                      selectedRoleNotifier.value = newValue!;
                    },
                    items: <String>["Administrator", "Uzytkownik"].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                // Update user data on button press
                final updatedUserData = UserData(
                  id: userData.id,
                  login: userData.login,
                  pass: newPasswordController.text,
                  role: selectedRoleNotifier.value,
                );
                await _updateUserData(updatedUserData);
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

 Future<void> _updateUserData(UserData userData) async {
  try {
    final response = await http.post(
      Uri.parse("http://10.0.2.2/rest_api/update_user.php"),
      body: {
        "id": userData.id.toString(), // Konwertuj id na String
        "pass": userData.pass,
        "role": userData.role,
      },
    );

      if (response.statusCode == 200) {
        print("User data updated successfully");
        fetchUserData(); // Refresh user data after update
      } else {
        print("Error updating user data");
      }
    } catch (e) {
      print("An error occurred: $e");
    }
  }
}

