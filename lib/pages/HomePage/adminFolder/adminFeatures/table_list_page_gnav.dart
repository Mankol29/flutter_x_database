import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../tables_details_page.dart';

class TableListPageGnav extends StatefulWidget {
  @override
  _TableListPageGnavState createState() => _TableListPageGnavState();
}

class _TableListPageGnavState extends State<TableListPageGnav> {
  List<String> tableNames = [];

  @override
  void initState() {
    super.initState();
    fetchTableNames();
  }

  Future<void> fetchTableNames() async {
    try {
      final response = await http.get(
        Uri.parse("http://10.0.2.2/rest_api/fetch_table_names.php"),
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        setState(() {
          tableNames = List.from(responseData);
        });
      }
    } catch (e) {
      print("An error occurred: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Table List"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: tableNames.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.all(8),
              child: Center(
                child: Text(tableNames[index]),
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      TableDetailsPage(tableName: tableNames[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
