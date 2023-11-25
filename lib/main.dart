import 'package:flutter/material.dart';
import 'AddTask.dart';
import 'Task.dart';
import 'Note.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF00023D),
        hintColor:const Color(0xFF2A6594),
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
  bool _sortByNew=true;
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
  void _sortTasksByDate() {
    setState(() {
      _sortByNew = !_sortByNew;
      tasks.sort((a, b) {
        final adate = a.date ?? DateTime(0);
        final bdate = b.date ?? DateTime(0);

        final aDateOnly = DateTime(adate.year, adate.month, adate.day);
        final bDateOnly = DateTime(bdate.year, bdate.month, bdate.day);

        if (_sortByNew) {
          return bDateOnly.compareTo(aDateOnly);
        } else {
          return aDateOnly.compareTo(bDateOnly);
        }
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('To-Do List'),
        backgroundColor:const  Color(0xFF00023D),
        centerTitle: true,
        actions: [
          IconButton(
            icon:const Icon(Icons.note),
            onPressed: _navigateToNotesPage,
            color:const Color(0xFF2A6594),

          ),
          IconButton(onPressed: _sortTasksByDate, icon: Icon(_sortByNew? Icons.arrow_downward:Icons.arrow_upward))
        ],
        
      ),
      body: Container(
        decoration:const  BoxDecoration(
          color: const Color(0xFF2A6594),
        ),
        child: tasks.isEmpty
            ? const Center(
          child: Text(
            'Nothing to do!\nEnjoy your day!',
            style: TextStyle(fontSize: 40, color: Colors.white),
          ),
        )
            : ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            return Card(
              color: Colors.white,
              elevation: 2,
              margin:
              const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
        backgroundColor: const Color(0xFF00023D),

      ),
      persistentFooterButtons:isDeleteButtonVisible ?[
        ElevatedButton(
          onPressed: () {
            _deleteSelectedTasks();
          },
          style: ElevatedButton.styleFrom(
            primary: const Color(0xFF2A6594),
          ),
          child: const Text('Delete Selected'),
        ),
      ]
      :null,
    );
  }
}
