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
  bool isDeleteButtonVisible = false;
  void _toggleTaskSelection(int index) {
    setState(() {
      tasks[index].isSelected = !tasks[index].isSelected;
      isDeleteButtonVisible = tasks.any((task) => task.isSelected);
    });
  }
  void _deleteSelectedTasks() {
    setState(() {
      tasks.removeWhere((task) => task.isSelected);
      isDeleteButtonVisible = false;
    });
  }
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
            leading: Checkbox(
              value: tasks[index].isSelected,
              onChanged: (value)=>_toggleTaskSelection(index),
            ),
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
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTask(tasks),
            ),
          );

          if (result == true) {
            setState(() {
            });
          }
        },
        child: Icon(Icons.add),
      ),
      persistentFooterButtons:isDeleteButtonVisible ?[
        ElevatedButton(
          onPressed: () {
            _deleteSelectedTasks();
          },
          child: Text('Delete Selected'),
        ),
      ]
      :null,
    );
  }
}
