
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

 Future<String> _getUserRoleFromServer(String login) async {
  try {
    String uri = "http://10.0.2.2/rest_api/get_user_role.php?login=$login";
    var res = await http.get(Uri.parse(uri));

    if (res.statusCode == 200) {
      var response = jsonDecode(res.body);
      return response["role"];
    } else {
      print("Error getting user role");
      return "";
    }
  } catch (e) {
    print("An error occurred: $e");
    return "";
  }
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
          SnackBar(content: Text("Column added successfully")),
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
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(tempSelectedRole),
            child: Text("Add"),
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
                  child: Text("Cancel"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(tempSelectedGender),
                  child: Text("Add"),
                ),
              ],
            );
          },
        );
        } else {
  // Wyswietl dialog z polem tekstowym do wprowadzenia nowych danych
  final TextEditingController _controller = TextEditingController();
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
                  controller: _controller,
                ),
                SizedBox(height: 8), // Dodaj odst?p
                Text(
                  errorText,
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(null),
                child: Text("Cancel"),
              ),
              TextButton(
                child: Text("Add"),
                onPressed: () {
                  enteredValue = _controller.text;
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
            SnackBar(content: Text("Data inserted successfully")),
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
          SnackBar(content: Text("Record deleted successfully")),
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
            icon: Icon(Icons.delete),
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
          child: Text("Add Data"),
        ),
        SizedBox(height: 10),

ElevatedButton(
  onPressed: () {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add Column"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  setState(() {
                    newColumnName = value;
                  });
                },
                decoration: InputDecoration(labelText: "Column Name"),
              ),
              SizedBox(height: 10),
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
                decoration: InputDecoration(labelText: "Column Type"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                _addColumn(); // Dodaj now? kolumn?
              },
              child: Text("Add Column"),
            ),
          ],
        );
      },
    );
  },
  child: Text("Add Column"),
        ),
      ],
    ),
  );
}}