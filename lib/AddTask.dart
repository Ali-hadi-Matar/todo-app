import 'package:flutter/material.dart';
import 'package:todo_app/login.dart';
import 'Task.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:todo_app/Register.dart';
import 'package:todo_app/main.dart';
class AddTask extends StatefulWidget {
  final List<Task> tasks;

  const AddTask(this.tasks, {super.key});

  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  int userId=StateManager.userId;


  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  /*void _addTask() {
    Task newTask = Task(
      _descriptionController.text,
      _selectedDate,
      _selectedTime,
    );

    setState(() {
      widget.tasks.add(newTask);
      _descriptionController.clear();
      _selectedDate = null;
      _selectedTime = null;
    });

    Navigator.pop(context, true);
  }*/

  String formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:00';
  }
  Future<void> insertTasks() async {
    final insertURL = Uri.parse('https://quicktaskapp.000webhostapp.com/insertTasks.php');
    String formattedTime = formatTime(_selectedTime!);

    // Assuming these values are retrieved from your UI controls
    String userIdString = userId.toString();  // Convert userId to String
    String date = _selectedDate?.toLocal().toString() ?? '';  // Convert DateTime to String
    String time = _selectedTime?.format(context) ?? '';  // Format TimeOfDay as String
    String description = _descriptionController.text;  // Get text from the controller

    try {
      final responseInsert = await http.post(
        insertURL,
        body: {
          'user-id': userIdString,
          'date': date,
          'time': formattedTime,
          'description': description,
        },
      );

      print('Response status: ${responseInsert.statusCode}');
      print('Response body: ${responseInsert.body}');
    Navigator.push(context, MaterialPageRoute(builder: (context)=>TaskList()));
    } catch (error) {
      print("Error during insertTasks: $error");
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body:Container(
        decoration: const BoxDecoration(
          color: Color(0xFF2A6594), // Set the body background color
        ),
      child: Padding(

        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Enter new task',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: Theme.of(context).primaryColor,
                  ),
                  const  SizedBox(width: 8),
                const  Text('Select Date'),
                ],
              ),
            ),
           const SizedBox(height: 8),
            Text(
              _selectedDate == null
                  ? 'No Date Selected'
                  : 'Selected Date: ${_selectedDate!.toLocal()}',
            ),
           const SizedBox(height: 16),



            ElevatedButton(
              onPressed: () => _selectTime(context),
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.access_time,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 8),
                const  Text('Select Time'),
                ],
              ),
            ),

           const SizedBox(height: 8),
            Text(
              _selectedTime == null
                  ? 'No Time Selected'
                  : 'Selected Time: ${_selectedTime!.format(context)}',
            ),
           const SizedBox(height: 16),
            ElevatedButton(
              onPressed: insertTasks,
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor,
              ),
              child:const Text('Add Task'),
            ),

          ],
        ),
      ),
    )
    );
  }
}
