import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo_app/pages/create_page.dart';
import 'package:todo_app/pages/todo_page.dart';
import 'package:todo_app/todo.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<Box<List>> future;

  @override
  void initState() {
    super.initState();
    future = Hive.openBox('todosObject');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        List<Todo> todos = snapshot.data!.get(
          'incomplete',
          defaultValue: [],
        )!.cast<Todo>();

        return Scaffold(
          appBar: AppBar(
            title: const Text('Todo List'),
            centerTitle: true,
          ),
          body: todos.isEmpty
              ? const Center(
                  child: Text('Nothing to show!'),
                )
              : ListView.builder(
                  itemCount: todos.length,
                  itemBuilder: (context, index) => ListTile(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return TodoPage(todo: todos[index]);
                          },
                        ),
                      );
                    },
                    title: Text(
                      todos[index].title,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        setState(() {
                          todos.removeAt(index);
                          snapshot.data!.put('incomplete', todos);
                        });
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  ),
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final res = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const CreatePage();
                  },
                ),
              );
              if (res != null) {
                if (res is Todo) {
                  setState(
                    () {
                      todos.add(res);
                      snapshot.data!.put('incomplete', todos);
                    },
                  );
                }
              }
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
