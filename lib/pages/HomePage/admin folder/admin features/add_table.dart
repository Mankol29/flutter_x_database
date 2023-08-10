import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_x_database/pages/HomePage/admin%20folder/admin%20features/table_column.dart';

class CreateTableScreen extends StatefulWidget {
  @override
  _CreateTableScreenState createState() => _CreateTableScreenState();
}

class _CreateTableScreenState extends State<CreateTableScreen> {
  List<TableColumn> columns = [];
  TextEditingController tableNameController = TextEditingController();
  TextEditingController columnNameController = TextEditingController();
  TextEditingController columnTypeController = TextEditingController();
  List<String> columnTypes = ["INT", "VARCHAR(40)"];
  String? selectedColumnType; // Domy?lnie przypisz pusty string, je?li newValue jest null

  void addColumn() {
  setState(() {
    String columnName = columnNameController.text;
    String columnType = selectedColumnType ?? ""; // U?yj wybranej warto?ci lub pustego stringa
    if (columnName.isNotEmpty && columnType.isNotEmpty) {
      columns.add(TableColumn(name: columnName, type: columnType));
      columnNameController.clear();
      selectedColumnType = null; // Zresetuj wybór typu kolumny
    }
  });
}
  Future<void> createTableInDatabase(String tableName, List<TableColumn> columns) async {
  final url = Uri.parse("http://10.0.2.2/rest_api/create_table.php"); // Zmie? na w?a?ciwy URL
  final headers = {"Content-Type": "application/json"};
  
  final columnData = columns.map((col) => {"name": col.name, "type": col.type}).toList();

  final data = {
    "table_name": tableName,
    "columns": columnData,
  };

  final response = await http.post(url, headers: headers, body: jsonEncode(data));

  if (response.statusCode == 200) {
    // Tutaj mo?esz obs?u?y? odpowied? serwera po utworzeniu tabeli
    print("Table created successfully!");
  } else {
    // Obs?u? b??d, je?li wyst?pi?
    print("Error creating table: ${response.statusCode}");
  }
}


  void createTable() {
  String tableName = tableNameController.text;
  if (tableName.isNotEmpty && columns.isNotEmpty) {
    createTableInDatabase(tableName, columns);

    // Reset controllers and columns list after creating the table
    tableNameController.clear();
    columns.clear();
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Table"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: tableNameController,
              decoration: InputDecoration(labelText: "Table Name"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: columnNameController,
              decoration: InputDecoration(labelText: "Column Name"),
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedColumnType,
              onChanged: (newValue) {
                setState(() {
                  selectedColumnType = newValue;
                });
              },
              items: columnTypes.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(labelText: "Column Type"),
            ),
            ElevatedButton(
              onPressed: addColumn,
              child: Text("Add Column"),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: columns.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text("${columns[index].name} - ${columns[index].type}"),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createTable,
        child: Icon(Icons.check),
      ),
    );
  }
}
