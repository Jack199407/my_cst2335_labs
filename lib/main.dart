import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: ShoppingListPage(),
  ));
}

class ShoppingListPage extends StatefulWidget {
  @override
  _ShoppingListPageState createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  List<Map<String, String>> items = [];

  void _addItem() {
    setState(() {
      if (_itemController.text.isNotEmpty && _quantityController.text.isNotEmpty) {
        items.add({
          'name': _itemController.text,
          'quantity': _quantityController.text,
        });
        _itemController.clear();
        _quantityController.clear();
      }
    });
  }

  void _removeItem(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Delete Item"),
          content: Text("Are you sure you want to delete ${items[index]['name']}?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("No"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  items.removeAt(index);
                });
                Navigator.of(context).pop();
              },
              child: Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Demo Home Page"),
        backgroundColor: Colors.purple[200],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _itemController,
                    decoration: InputDecoration(
                      hintText: "Type the item here",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _quantityController,
                    decoration: InputDecoration(
                      hintText: "Type the quantity here",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addItem,
                  child: Text("Click here"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: items.isEmpty
                  ? Center(child: Text("There are no items in the list"))
                  : ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onLongPress: () => _removeItem(index),
                    child: Card(
                      child: ListTile(
                        title: Text("${index + 1}: ${items[index]['name']}",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        trailing: Text("Quantity: ${items[index]['quantity']}",
                            style: TextStyle(color: Colors.grey[600])),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}