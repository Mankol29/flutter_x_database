// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'package:flutter/material.dart';

import 'package:flutter_x_database/pages/components/table_column.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class TableListPage extends StatefulWidget {
  const TableListPage({super.key});

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
        backgroundColor: Colors.purple,
        title: const Text("Table List"),
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
              padding: const EdgeInsets.all(8),
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
                  builder: (context) =>const CreateTableScreen(),),);
        },
        child: const Stack(
          children: [
        Icon(Icons.pivot_table_chart_sharp),
        ],
        )
        ),);
}
  }

 
  class TableDetailsPage extends StatefulWidget {
  final String tableName;

  const TableDetailsPage({required this.tableName, Key? key, }) : super(key: key);

  @override
  _TableDetailsPageState createState() => _TableDetailsPageState();
}

class _TableDetailsPageState extends State<TableDetailsPage> {

  String selectedRole = "Administrator";
  String selectedGender = "Mezczyzna"; // Dodaj deklaracje selectedGender
  List<String> columns = [];
  List<Map<String, dynamic>> tableData = [];
   List<String> columnTypes = ["INT", "VARCHAR(40)"];
  
  String newColumnName = ""; // Dodaj pole na now? nazw? kolumny
  String newColumnType = ""; // Dodaj pole na nowy typ kolumny


  @override
  void initState() {
    super.initState();
    fetchTableData();
  }



Future<void> _addColumn() async {
  try {
    final response = await http.post(
  Uri.parse("http://10.0.2.2/rest_api/add_column.php"),
  body: {
    "table_name": widget.tableName,
    "column_name": newColumnName,
    "column_type": newColumnType, // Na przyk?ad "INT" lub "VARCHAR(40)"
  },
);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData.containsKey("message")) {
        // Wyswietl komunikat o sukcesie
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Column added successfully")),
        );
        // Od?wie? dane
        fetchTableData();
      } else if (responseData.containsKey("error")) {
        // Wyswietl komunikat o b??dzie
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData["error"])),
        );
      }
    }
  } catch (e) {
    print("An error occurred: $e");
  }
}

  Future<void> _insertData() async {
  final Map<String, dynamic> newData = {}; // Inicjalizuj map? dla nowych danych
    for (final col in columns) {
      if (col != "id") {
        dynamic enteredValue;

        if (col == "role") {
  // Wybór roli z rozwijanej listy
  enteredValue = await showDialog(
    context: context,
    builder: (BuildContext context) {
      String tempSelectedRole = selectedRole; // Przypisz obecn? warto?? selectedRole

      return AlertDialog(
        title: Text("Select $col"),
        content: StatefulBuilder(
          builder: (context, setState) {
            return DropdownButton<String>(
              value: tempSelectedRole,
              onChanged: (newValue) {
                setState(() {
                  tempSelectedRole = newValue!;
                });
              },
              items: ["Administrator", "Uzytkownik"].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(null),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(tempSelectedRole),
            child: const Text("Add"),
          ),
        ],
      );
    },
  );
   } else if (col == "plec") {
        // Wybór p?ci z rozwijanej listy
        enteredValue = await showDialog(
          context: context,
          builder: (BuildContext context) {
            String tempSelectedGender = selectedGender; // Przypisz obecn? warto?? selectedGender

            return AlertDialog(
              title: Text("Select $col"),
              content: StatefulBuilder(
                builder: (context, setState) {
                  return DropdownButton<String>(
                    value: tempSelectedGender,
                    onChanged: (newValue) {
                      setState(() {
                        tempSelectedGender = newValue!;
                      });
                    },
                    items: ["Mezczyzna", "Kobieta"].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  );
                },
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(null),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(tempSelectedGender),
                  child: const Text("Add"),
                ),
              ],
            );
          },
        );
        } else {
  // Wyswietl dialog z polem tekstowym do wprowadzenia nowych danych
  final TextEditingController controller = TextEditingController();
  String errorText = ""; // Tekst b??du

  enteredValue = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text("Enter $col"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controller,
                ),
                const SizedBox(height: 8), // Dodaj odst?p
                Text(
                  errorText,
                  style: const TextStyle(color: Colors.red),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(null),
                child: const Text("Cancel"),
              ),
              TextButton(
                child: const Text("Add"),
                onPressed: () {
                  enteredValue = controller.text;
                  if (enteredValue.isNotEmpty) {
                    Navigator.of(context).pop(enteredValue);
                  } else {
                    setState(() {
                      errorText = 'Please complete data!'; // Ustaw tekst b??du
                    });
                  }
                },
              ),
            ],
          );
        },
      );
    },
  );
}



        if (enteredValue != null && enteredValue != "") {
          newData[col] = enteredValue;
        } else {
          return;
        }
      }
    }

    try {
      final response = await http.post(
        Uri.parse("http://10.0.2.2/rest_api/insert_data_into_table.php"),
        body: {
          "table_name": widget.tableName,
          "data": json.encode(newData),
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData.containsKey("message")) {
          // Wyswietl komunikat o sukcesie
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Data inserted successfully")),
          );
          // Od?wie? dane
          fetchTableData();
        } else if (responseData.containsKey("error")) {
          // Wyswietl komunikat o b??dzie
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseData["error"])),
          );
        }
      }
    } catch (e) {
      print("An error occurred: $e");
    }
  }
  
Future<void> _deleteRecord(String recordId) async {
  try {
    final response = await http.post(
      Uri.parse("http://10.0.2.2/rest_api/delete_record.php"),
      body: {
        "table_name": widget.tableName,
        "record_id": recordId.toString(),
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData.containsKey("message")) {
        // Wyswietl komunikat o sukcesie
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Record deleted successfully")),
        );
        // Od?wie? dane
        fetchTableData();
      } else if (responseData.containsKey("error")) {
        // Wyswietl komunikat o b??dzie
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData["error"])),
        );
      }
    }
  } catch (e) {
    print("An error occurred: $e");
  }
}

  Future<void> fetchTableData() async {
    try {
      final response = await http.post(
        Uri.parse("http://10.0.2.2/rest_api/fetch_data_from_table.php"),
        body: {"table_name": widget.tableName},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        setState(() {
          columns = List<String>.from(responseData["columns"]);
          tableData = List<Map<String, dynamic>>.from(responseData["data"]);
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
        title: Text(widget.tableName),
      ),
      body:ListView.builder(
  itemCount: tableData.length,
  itemBuilder: (context, index) {
    final row = tableData[index];
    return ListTile(
      title: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: columns.map((col) {
                return Text("$col: ${row[col]}");
              }).toList(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _deleteRecord(row["id"]); // Wywo?aj funkcj? usuwania rekordu
            },
          ),
        ],
      ),
    );
  },
),
      floatingActionButton: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: _insertData,
          child: const Text("Add Data"),
        ),
        const SizedBox(height: 10),

ElevatedButton(
  onPressed: () {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add Column"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  setState(() {
                    newColumnName = value;
                  });
                },
                decoration: const InputDecoration(labelText: "Column Name"),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: newColumnType.isNotEmpty ? newColumnType : columnTypes[0], // Ustaw domy?ln? warto?? z listy
                onChanged: (newValue) {
                  setState(() {
                    newColumnType = newValue!;
                  });
                },
                items: columnTypes.map<DropdownMenuItem<String>>(
                  (String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  },
                ).toList(),
                decoration: const InputDecoration(labelText: "Column Type"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                _addColumn(); // Dodaj now? kolumn?
              },
              child: const Text("Add Column"),
            ),
          ],
        );
      },
    );
  },
  child: const Text("Add Column"),
        ),
      ],
    ),
  );
}}

  class CreateTableScreen extends StatefulWidget {
  const CreateTableScreen({super.key});

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
        title: const Text("Create Table"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: tableNameController,
              decoration: const InputDecoration(labelText: "Table Name"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: columnNameController,
              decoration: const InputDecoration(labelText: "Column Name"),
            ),
            const SizedBox(height: 10),
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
              decoration: const InputDecoration(labelText: "Column Type"),
            ),
            ElevatedButton(
              onPressed: addColumn,
              child: const Text("Add Column"),
            ),
            const SizedBox(height: 20),
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
        child: const Icon(Icons.check),
      ),
    );
  }
}