import 'package:flutter/material.dart';
import 'database/app_database.dart';
import 'models/todo_item.dart';
import 'dao/todo_dao.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database =
  await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  final dao = database.toDoDao;

  runApp(MyApp(dao: dao));
}

class MyApp extends StatelessWidget {
  final ToDoDao dao;

  MyApp({required this.dao});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To-Do List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ToDoListScreen(dao: dao),
    );
  }
}

class ToDoListScreen extends StatefulWidget {
  final ToDoDao dao;

  ToDoListScreen({required this.dao});

  @override
  _ToDoListScreenState createState() => _ToDoListScreenState();
}

class _ToDoListScreenState extends State<ToDoListScreen> {
  late Future<List<ToDoItem>> todoItems;

  @override
  void initState() {
    super.initState();
    todoItems = widget.dao.getAllToDos();
  }

  void _addToDo(String title) async {
    if (title.isNotEmpty) {
      await widget.dao.insertToDoItem(ToDoItem(title: title));
      setState(() {
        todoItems = widget.dao.getAllToDos();
      });
    }
  }

  void _deleteToDo(ToDoItem item) async {
    await widget.dao.deleteToDoItem(item);
    setState(() {
      todoItems = widget.dao.getAllToDos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('To-Do List')),
      body: FutureBuilder<List<ToDoItem>>(
        future: todoItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No tasks yet. Add some!'));
          }
          return ListView(
            children: snapshot.data!
                .map((item) => ListTile(
              title: Text(item.title),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deleteToDo(item),
              ),
            ))
                .toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog() {
    final TextEditingController _controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add To-Do'),
          content: TextField(controller: _controller),
          actions: [
            TextButton(
              onPressed: () {
                _addToDo(_controller.text);
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
