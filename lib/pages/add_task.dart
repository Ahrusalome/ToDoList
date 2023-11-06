import 'package:flutter/material.dart';
import 'package:todo_app_sqlite_freezed/models/todo_model.dart';

class AddTask extends StatelessWidget {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
            child:TextField(
            decoration: const InputDecoration(hintText: "Enter text..."),
            controller: controller,
            )), ElevatedButton(child: const Text("Add task"), onPressed: () {Navigator.pop(context, Todo(task: controller.text, isCompleted: 0));})
          ]),
        ),
      );
    }
  }