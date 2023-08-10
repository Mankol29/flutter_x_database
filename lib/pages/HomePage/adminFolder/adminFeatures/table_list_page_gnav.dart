<<<<<<< HEAD:lib/pages/HomePage/adminFolder/adminFeatures/table_list_page_gnav.dart
<<<<<<<< HEAD:lib/pages/HomePage/adminFolder/adminFeatures/table_list_page_gnav.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../tables_details_page.dart';
========
import 'package:flutter/material.dart';
import 'package:flutter_x_database/pages/HomePage/admin%20folder/tables_details_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'admin features/add_table.dart';
import 'admin features/table_column.dart';
>>>>>>>> a5b91d9ee5115846dc149f10e06d36d56be8e482:lib/pages/HomePage/admin folder/tables_page_list.dart
=======
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_x_database/pages/HomePage/admin%20folder/tables_details_page.dart';
import 'package:http/http.dart' as http;
>>>>>>> a5b91d9ee5115846dc149f10e06d36d56be8e482:lib/pages/HomePage/admin folder/admin features/table_list_page_gnav.dart

class TableListPageGnav extends StatefulWidget {
  @override
  _TableListPageGnavState createState() => _TableListPageGnavState();
}

class _TableListPageGnavState extends State<TableListPageGnav> {
  List<String> tableNames = [];
<<<<<<< HEAD:lib/pages/HomePage/adminFolder/adminFeatures/table_list_page_gnav.dart
  List<TableColumn> newColumns = [];
  List<TableColumn> newTableColumns = [];

  Future<void> _refreshTableNames() async {
    await fetchTableNames(); // Od?wie? list? tabel
  }
=======
>>>>>>> a5b91d9ee5115846dc149f10e06d36d56be8e482:lib/pages/HomePage/admin folder/admin features/table_list_page_gnav.dart

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

<<<<<<< HEAD:lib/pages/HomePage/adminFolder/adminFeatures/table_list_page_gnav.dart

=======
>>>>>>> a5b91d9ee5115846dc149f10e06d36d56be8e482:lib/pages/HomePage/admin folder/admin features/table_list_page_gnav.dart
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Table List"),
        centerTitle: true,
      ),
<<<<<<< HEAD:lib/pages/HomePage/adminFolder/adminFeatures/table_list_page_gnav.dart
<<<<<<<< HEAD:lib/pages/HomePage/adminFolder/adminFeatures/table_list_page_gnav.dart
=======
>>>>>>> a5b91d9ee5115846dc149f10e06d36d56be8e482:lib/pages/HomePage/admin folder/admin features/table_list_page_gnav.dart
      body: ListView.builder(
        itemCount: tableNames.length,
        itemBuilder: (context, index) {
          return ListTile(
<<<<<<< HEAD:lib/pages/HomePage/adminFolder/adminFeatures/table_list_page_gnav.dart
========
       body: RefreshIndicator(
        onRefresh: _refreshTableNames, // Funkcja do od?wie?ania
        child: ListView.builder(
          itemCount: tableNames.length,
          itemBuilder: (context, index) {
            return ListTile(
>>>>>>>> a5b91d9ee5115846dc149f10e06d36d56be8e482:lib/pages/HomePage/admin folder/tables_page_list.dart
=======
>>>>>>> a5b91d9ee5115846dc149f10e06d36d56be8e482:lib/pages/HomePage/admin folder/admin features/table_list_page_gnav.dart
            title: Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.all(8),
<<<<<<< HEAD:lib/pages/HomePage/adminFolder/adminFeatures/table_list_page_gnav.dart
<<<<<<<< HEAD:lib/pages/HomePage/adminFolder/adminFeatures/table_list_page_gnav.dart
              child: Center(
                child: Text(tableNames[index]),
              ),
========
              child: Center(child: Text(tableNames[index])),
>>>>>>>> a5b91d9ee5115846dc149f10e06d36d56be8e482:lib/pages/HomePage/admin folder/tables_page_list.dart
=======
              child: Center(
                child: Text(tableNames[index]),
              ),
>>>>>>> a5b91d9ee5115846dc149f10e06d36d56be8e482:lib/pages/HomePage/admin folder/admin features/table_list_page_gnav.dart
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
<<<<<<< HEAD:lib/pages/HomePage/adminFolder/adminFeatures/table_list_page_gnav.dart
<<<<<<<< HEAD:lib/pages/HomePage/adminFolder/adminFeatures/table_list_page_gnav.dart
                  builder: (context) =>
                      TableDetailsPage(tableName: tableNames[index]),
========
                  builder: (context) => TableDetailsPage(tableName: tableNames[index]),
>>>>>>>> a5b91d9ee5115846dc149f10e06d36d56be8e482:lib/pages/HomePage/admin folder/tables_page_list.dart
=======
                  builder: (context) =>
                      TableDetailsPage(tableName: tableNames[index]),
>>>>>>> a5b91d9ee5115846dc149f10e06d36d56be8e482:lib/pages/HomePage/admin folder/admin features/table_list_page_gnav.dart
                ),
              );
            },
          );
        },
      ),
<<<<<<< HEAD:lib/pages/HomePage/adminFolder/adminFeatures/table_list_page_gnav.dart
<<<<<<<< HEAD:lib/pages/HomePage/adminFolder/adminFeatures/table_list_page_gnav.dart
    );
  }
}
========
      
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:(){
           Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>CreateTableScreen(),),);
        },
        child: const Stack(
          children: [
        Icon(Icons.pivot_table_chart_sharp),
        ],
        )
        ),
        );
}
  }
>>>>>>>> a5b91d9ee5115846dc149f10e06d36d56be8e482:lib/pages/HomePage/admin folder/tables_page_list.dart
=======
    );
  }
}
>>>>>>> a5b91d9ee5115846dc149f10e06d36d56be8e482:lib/pages/HomePage/admin folder/admin features/table_list_page_gnav.dart
