import 'package:hive_flutter/adapters.dart';

part 'todo.g.dart';

@HiveType(typeId: 0)
class Todo {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String description;

  const Todo({
    required this.title,
    required this.description,
  });
}
