import 'package:floor/floor.dart';
import '../models/todo_item.dart';

@dao
abstract class ToDoDao {
  @Query('SELECT * FROM ToDoItem')
  Future<List<ToDoItem>> getAllToDos();

  @Insert()
  Future<void> insertToDoItem(ToDoItem todoItem);

  @delete
  Future<void> deleteToDoItem(ToDoItem todoItem);
}
