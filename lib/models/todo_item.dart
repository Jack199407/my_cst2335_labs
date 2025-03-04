import 'package:floor/floor.dart';

@entity
class ToDoItem {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String title;

  ToDoItem({this.id, required this.title});
}
