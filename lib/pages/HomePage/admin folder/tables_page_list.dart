import 'dart:convert';
import 'package:flutter_x_database/pages/HomePage/admin%20folder/tables_details_page.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';


class TableListPage extends StatefulWidget {
  @override
  _TableListPageState createState() => _TableListPageState();
}

class _TableListPageState extends State<TableListPage> {
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
      ),
      body: ListView.builder(
        itemCount: tableNames.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(tableNames[index]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        TableDetailsPage(tableName: tableNames[index])),
              );
            },
          );
        },
      ),
    );
  }
}