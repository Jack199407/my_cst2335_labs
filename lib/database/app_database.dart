import 'dart:async';
import 'package:floor/floor.dart';
import '../models/todo_item.dart';
import '../dao/todo_dao.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'app_database.g.dart';

@Database(version: 1, entities: [ToDoItem])
abstract class AppDatabase extends FloorDatabase {
  ToDoDao get toDoDao;
}
