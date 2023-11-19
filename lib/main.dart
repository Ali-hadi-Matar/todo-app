import 'package:flutter/material.dart';
import 'AddTask.dart';
import 'Task.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TaskList(),
    );
  }
}

class TaskList extends StatefulWidget {
  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  List<Task> tasks = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do List'),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(tasks[index].description),
            subtitle: Text(
              'Date: ${tasks[index].date?.toLocal().toString() ?? 'Not set'}\n'
                  'Time: ${tasks[index].time?.format(context) ?? 'Not set'}',
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to AddTask and wait for a result
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTask(tasks),
            ),
          );

          // Check the result and trigger a rebuild if needed
          if (result == true) {
            setState(() {
              // Trigger a rebuild of the TaskList widget
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
