import 'package:flutter/material.dart';
import 'shared_preferences_helper.dart';

class ShoppingListPage extends StatefulWidget {
  @override
  _ShoppingListPageState createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  List<Map<String, String>> items = [];

  @override
  void initState() {
    super.initState();
    _loadItems(); // 启动时加载数据
  }

  // 🚀 从 SharedPreferences 加载数据
  void _loadItems() async {
    List<Map<String, String>> loadedItems = await SharedPreferencesHelper.loadShoppingList();
    setState(() {
      items = loadedItems;
    });
  }

  // 🚀 添加新项目
  void _addItem() {
    if (_itemController.text.isNotEmpty && _quantityController.text.isNotEmpty) {
      setState(() {
        items.add({
          'name': _itemController.text,
          'quantity': _quantityController.text,
        });
        _itemController.clear();
        _quantityController.clear();
      });
      SharedPreferencesHelper.saveShoppingList(items); // 存入本地存储
    }
  }

  // 🚀 删除项目
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
                SharedPreferencesHelper.saveShoppingList(items); // 更新存储
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
        title: Text("Flutter Shopping List"),
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
                  child: Text("Add"),
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
                  ? Center(child: Text("No items in the list"))
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
