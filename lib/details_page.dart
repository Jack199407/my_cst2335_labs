import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  final Map<String, String> item;
  final VoidCallback onDelete;
  final VoidCallback onClose;

  DetailsPage({
    required this.item,
    required this.onDelete,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Item Details"),
        backgroundColor: Colors.purple[100],
        automaticallyImplyLeading: false, // 防止多余返回按钮
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name: ${item['name']}", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text("Quantity: ${item['quantity']}", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text("Database ID: ${item['id']}", style: TextStyle(fontSize: 16, color: Colors.grey)),
            SizedBox(height: 30),
            Row(
              children: [
                ElevatedButton(
                  onPressed: onDelete,
                  child: Text("Delete"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: onClose,
                  child: Text("Close"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
