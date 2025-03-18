import 'package:flutter/material.dart';
import 'shared_preferences_helper.dart';
import 'details_page.dart';

class ShoppingListPage extends StatefulWidget {
  @override
  _ShoppingListPageState createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  List<Map<String, String>> items = [];
  int? selectedIndex; // 用于响应式布局的当前选中项

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    List<Map<String, String>> loadedItems = await SharedPreferencesHelper.loadShoppingList();
    setState(() {
      items = loadedItems;
    });
  }

  void _addItem() {
    if (_itemController.text.isNotEmpty && _quantityController.text.isNotEmpty) {
      setState(() {
        items.add({
          'name': _itemController.text,
          'quantity': _quantityController.text,
          'id': DateTime.now().millisecondsSinceEpoch.toString(), // 唯一ID
        });
        _itemController.clear();
        _quantityController.clear();
      });
      SharedPreferencesHelper.saveShoppingList(items);
    }
  }

  void _deleteItem(int index) {
    setState(() {
      items.removeAt(index);
      selectedIndex = null;
    });
    SharedPreferencesHelper.saveShoppingList(items);
  }

  void _selectItem(int index, bool isWideScreen) {
    if (isWideScreen) {
      setState(() {
        selectedIndex = index;
      });
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DetailsPage(
            item: items[index],
            onDelete: () {
              _deleteItem(index);
              Navigator.pop(context);
            },
            onClose: () => Navigator.pop(context),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Responsive Shopping List"),
        backgroundColor: Colors.purple[200],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isWideScreen = constraints.maxWidth > 600; // 判断是否宽屏设备
          return Row(
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _itemController,
                              decoration: InputDecoration(
                                hintText: "Item name",
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _quantityController,
                              decoration: InputDecoration(
                                hintText: "Quantity",
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
                              onTap: () => _selectItem(index, isWideScreen),
                              child: Card(
                                child: ListTile(
                                  title: Text("${index + 1}: ${items[index]['name']}"),
                                  trailing: Text("Qty: ${items[index]['quantity']}"),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (isWideScreen && selectedIndex != null)
                Expanded(
                  flex: 3,
                  child: DetailsPage(
                    item: items[selectedIndex!],
                    onDelete: () => _deleteItem(selectedIndex!),
                    onClose: () {
                      setState(() {
                        selectedIndex = null;
                      });
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
