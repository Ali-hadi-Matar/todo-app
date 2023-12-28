import 'dart:convert';

import 'package:flutter/material.dart';
import 'AddTask.dart';
import 'Task.dart';
import 'Note.dart';
import 'login.dart';
import 'SplashScreen.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF00023D),
        hintColor:const Color(0xFF2A6594),
      ),
      home:const SplashScreen(),
    );
  }
}

class TaskList extends StatefulWidget {
  const TaskList({super.key});


  @override
   _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  List<Task> tasks = [];
  bool isDeleteButtonVisible = false;
  bool _sortByNew = true;
  int userId = StateManager.userId;

  void _toggleTaskSelection(int index) {
    setState(() {
      tasks[index].isSelected = !tasks[index].isSelected;
      isDeleteButtonVisible = tasks.any((task) => task.isSelected);
    });
  }


  void _navigateToNotesPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NotesList(),
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


  Future<void> fetchTasks() async {
    setState(() {
      _loading = true;
    });
    final getTaskUrl = Uri.parse(
        'https://quicktaskapp.000webhostapp.com/getTasks.php');

    try {
      final response = await http.post(
          getTaskUrl, body: {'user-id': userId.toString()});

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        print('Before updating tasks state: $tasks');
        setState(() {
          final jsonResponse = json.decode(response.body);

          tasks = jsonResponse.map<Task>((row) {
            String id = row['id'];
            String description = row['description'];
            String dateString = row['date'];
            String timeString = row['time'];

            DateTime date = DateTime.parse('$dateString $timeString');
            TimeOfDay time = TimeOfDay.fromDateTime(
                DateTime.parse('$dateString $timeString'));

            return Task(id, description, date, time);
          }).toList();
        });

        print('After updating tasks state: $tasks');
       print("user id: ${userId}");
      } else {
        print('Failed to load tasks. Status code: ${response.statusCode}');
      }
      setState(() {
        _loading = false;
      });
    } catch (error) {
      print('Error fetching tasks: $error');
    }
  }

  Future<void> _deleteSelectedTasks() async {
    try {
      for (Task task in tasks.where((task) => task.isSelected)) {
        final deleteTaskUrl = Uri.parse(
            'https://quicktaskapp.000webhostapp.com/deleteTasks.php');
        final response = await http.post(
            deleteTaskUrl, body: {'task-id': task.id.toString()});

        print('Delete task response: ${response.body}');
      }


      setState(() {
        tasks.removeWhere((task) => task.isSelected);
        isDeleteButtonVisible = false;
      });
    } catch (error) {
      print(' Error deleting tasks: $error');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
        backgroundColor: const Color(0xFF00023D),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.note),
            onPressed: _navigateToNotesPage,
            color: const Color(0xFF2A6594),
          ),
          IconButton(
            onPressed: _sortTasksByDate,
            icon: Icon(_sortByNew ? Icons.arrow_downward : Icons.arrow_upward),
          ),
          IconButton(
            onPressed: fetchTasks,
            icon: const Icon(Icons.refresh),
          ),
          IconButton(onPressed:(){
            logout(context);
          },
              icon:const Icon(Icons.logout_rounded)
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF2A6594),
        ),
        child: Column(
          children: [
            Visibility(
              visible: _loading,
              child: const CircularProgressIndicator(),
            ),
            Expanded(
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
                    margin: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 16),
                    child: ListTile(
                      leading: Checkbox(
                        value: tasks[index].isSelected,
                        onChanged: (value) =>
                            _toggleTaskSelection(index),
                      ),
                      title: Text(tasks[index].description),
                      subtitle: Text(
                        'Date: ${tasks[index].date?.toLocal().toString() ??
                            'Not set'}\n'
                            'Time: ${tasks[index].time?.format(context) ??
                            'Not set'}',
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
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
            setState(() {});
          }
        },
        backgroundColor: const Color(0xFF00023D),
        child: const Icon(Icons.add),
      ),
      persistentFooterButtons: isDeleteButtonVisible
          ? [
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
          : null,
    );
  }
}

