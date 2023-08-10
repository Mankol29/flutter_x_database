
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
      selectedColumnType = null; // Zresetuj wyb�r typu kolumny
    }
  });
}
  void createTable() {
  String tableName = tableNameController.text;
  int numColumns = columns.length;

  if (tableName.isNotEmpty && numColumns > 0) {
    createTableInDatabase(tableName, numColumns, columns);

    // Reset controllers and columns list after creating the table
    tableNameController.clear();
    columns.clear();
  }
}

Future<void> createTableInDatabase(
    String tableName, int numColumns, List<TableColumn> columns) async {
  final url = Uri.parse("http://10.0.2.2/rest_api/create_table.php");
  final headers = {"Content-Type": "application/x-www-form-urlencoded"};

  final Map<String, String> data = {
    "table_name": tableName,
    "column_count": numColumns.toString(),
  };

  for (int i = 0; i < numColumns; i++) {
    data["column_name_$i"] = columns[i].name;
    data["column_type_$i"] = columns[i].type;
  }

  final response = await http.post(url, headers: headers, body: data);

  if (response.statusCode == 200) {
    print("Table created successfully!");
  } else {
    print("Error creating table: ${response.statusCode}");
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