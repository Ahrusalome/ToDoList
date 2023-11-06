import 'package:flutter/material.dart';
import 'package:todo_app_sqlite_freezed/models/todo_model.dart';
import 'pages/add_task.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final mytheme = ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Color.fromARGB(255, 82, 185, 159),
            brightness: Brightness.dark),
        textTheme: const TextTheme(
            displayMedium: TextStyle(
                fontSize: 18, color: Color.fromARGB(215, 234, 244, 197))));
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => ListTodo(),
        '/addTask': (context) => AddTask(),
      },
      onGenerateRoute: (settings) {
        return null;
      },
      title: 'Flutter Demo',
      theme: mytheme,
    );
  }
}

class ListTodo extends StatefulWidget {
  @override
  _listState createState() => _listState();
}

class _listState extends State<ListTodo> {
  void reload() {
    setState(() {});
  }

  final DatabaseHelper dbHelper = DatabaseHelper.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: FutureBuilder<List<Todo>>(
        future: dbHelper.getAllTodos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text('Erreur : ${snapshot.error}');
          }
          tasks = snapshot.data!;
          return Container(
            child: Column(children: [
              Flexible(
                  child: ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        return ToDoList(
                            id: index, aTask: tasks[index], reload: reload);
                      })),
              FloatingActionButton(
                reload: reload,
              )
            ]),
          );
        },
      )),
    );
  }
}

class ToDoList extends StatelessWidget {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;
  final int id;
  final Todo aTask;
  final Function reload;
  ToDoList(
      {super.key, required this.id, required this.aTask, required this.reload});
  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: Key(aTask.id.toString()),
        onDismissed: (direction) async {
          await dbHelper.delete(aTask.id!);
                  reload();
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListTile(
              leading: Icon(aTask.isCompleted == 1
                  ? Icons.check_box
                  : Icons.check_box_outline_blank),
              onTap: () async {
                await dbHelper.update(aTask.copyWith(
                    isCompleted: aTask.isCompleted == 1 ? 0 : 1));
                reload();
              },
              title: Text(
                aTask.task,
                style: Theme.of(context).textTheme.displayMedium,
              ),),
        ));
  }
}

class FloatingActionButton extends StatelessWidget {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;
  final Function reload;
  FloatingActionButton({super.key, required this.reload});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
          child: Text('Add a task'),
          onPressed: () async {
            Todo taskToAdd =
                await Navigator.of(context).pushNamed("/addTask") as Todo;
            await dbHelper.insert(taskToAdd);
            reload();
          }),
    );
  }
}

List<Todo> tasks = [];
