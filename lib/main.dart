import 'package:flutter/material.dart';
import 'AddTask.dart';
import 'Task.dart';
import 'Note.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFF00023D),
        hintColor: Color(0xFF2A6594),
      ),
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
  void _navigateToNotesPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotesList(),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do List'),
        backgroundColor: Color(0xFF00023D),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.note),
            onPressed: _navigateToNotesPage,
            color: Color(0xFF2A6594),

          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFF2A6594),
        ),
        child: ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            return Card(
              color: Colors.white,
              elevation: 2,
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                leading: Checkbox(
                  value: tasks[index].isSelected,
                  onChanged: (value) => _toggleTaskSelection(index),
                ),
                title: Text(tasks[index].description),
                subtitle: Text(
                  'Date: ${tasks[index].date?.toLocal().toString() ?? 'Not set'}\n'
                      'Time: ${tasks[index].time?.format(context) ?? 'Not set'}',
                ),
              ),
            );
          },
        ),
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
        backgroundColor: Color(0xFF00023D),

      ),
      persistentFooterButtons:isDeleteButtonVisible ?[
        ElevatedButton(
          onPressed: () {
            _deleteSelectedTasks();
          },
          style: ElevatedButton.styleFrom(
            primary: Color(0xFF2A6594),
          ),
          child: Text('Delete Selected'),
        ),
      ]
      :null,
    );
  }
}
