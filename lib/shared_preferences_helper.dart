import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPreferencesHelper {
  static const String _keyShoppingList = "shopping_list";

  // 存储购物清单数据
  static Future<void> saveShoppingList(List<Map<String, String>> items) async {
    final prefs = await SharedPreferences.getInstance();
    String encodedData = jsonEncode(items);
    await prefs.setString(_keyShoppingList, encodedData);
  }

  // 读取购物清单数据
  static Future<List<Map<String, String>>> loadShoppingList() async {
    final prefs = await SharedPreferences.getInstance();
    String? encodedData = prefs.getString(_keyShoppingList);
    if (encodedData == null) {
      return [];
    }
    List<dynamic> decodedData = jsonDecode(encodedData);
    return decodedData.map((e) => Map<String, String>.from(e)).toList();
  }
}
