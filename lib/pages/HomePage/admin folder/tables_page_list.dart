import 'package:flutter/material.dart';
import 'package:flutter_x_database/pages/HomePage/admin%20folder/tables_details_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'admin features/add_table.dart';
import 'admin features/table_column.dart';

class TableListPage extends StatefulWidget {
  @override
  _TableListPageState createState() => _TableListPageState();
}

class _TableListPageState extends State<TableListPage> {
  List<String> tableNames = [];
  List<TableColumn> newColumns = [];
  List<TableColumn> newTableColumns = [];

  Future<void> _refreshTableNames() async {
    await fetchTableNames(); // Od?wie? list? tabel
  }

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
       body: RefreshIndicator(
        onRefresh: _refreshTableNames, // Funkcja do od?wie?ania
        child: ListView.builder(
          itemCount: tableNames.length,
          itemBuilder: (context, index) {
            return ListTile(
            title: Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.all(8),
              child: Center(child: Text(tableNames[index])),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TableDetailsPage(tableName: tableNames[index]),
                ),
              );
            },
          );
        },
      ),
      
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
        ),);
}
  }