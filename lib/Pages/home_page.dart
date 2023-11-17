import 'package:daytask/Mpdels/Task.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HomePage extends StatefulWidget {
  HomePage();
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  late double deviceHeight, deviceWidth;
  String? inputcontent;
  Box? box;
  HomePageState();
  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    print("new task : $inputcontent");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 166, 64),
        toolbarHeight: deviceHeight * 0.1,
        title: const Text(
          "Today Task",
          style: TextStyle(
            fontSize: 25,
          ),
        ),
      ),
      body: taskView(),
      floatingActionButton: addNewTaskButton(),
    );
  }

  Widget taskView() {
    return FutureBuilder(
      future: Hive.openBox('task'),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          box = snapshot.data;
          return listTask();
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget listTask() {
    List tasks = box!.values.toList();

    return ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (BuildContext context, int index) {
          var task = Task.fromMap(tasks[index]);
          return ListTile(
            title: Text(task.content,
                style: TextStyle(
                    decoration: task.done ? TextDecoration.lineThrough : null)),
            subtitle: Text(DateTime.now().toString()),
            trailing: Icon(
              task.done
                  ? Icons.check_box_outlined
                  : Icons.check_box_outline_blank_outlined,
              color: Colors.blue,
            ),
            onTap: () {
              task.done = !task.done;
              box!.putAt(index, task.toMap());
            },
          );
        });
  }

  Widget addNewTaskButton() {
    return FloatingActionButton(
      onPressed: displayTaskPopup,
      child: const Icon(Icons.add),
    );
  }

  void displayTaskPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add new task"),
          content: TextField(
            onSubmitted: (value) {
              if (inputcontent != null) {
                var task = Task(
                  content: inputcontent!,
                  timestamp: DateTime.now(),
                  done: false,
                );
                box!.add(task.toMap());
                setState(() {
                  inputcontent = null;
                  Navigator.pop(context);
                });
              }
            },
            onChanged: (value) {
              setState(() {
                inputcontent = value;
              });
            },
          ),
        );
      },
    );
  }
}
