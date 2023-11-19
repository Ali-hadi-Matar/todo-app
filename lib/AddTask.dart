import 'dart:math';

import 'package:flutter/material.dart';
import 'Task.dart';

class AddTask extends StatefulWidget {
  final List<Task> tasks;

  AddTask(this.tasks);
  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

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

  void _addTask() {

    Task newTask = Task(
      _descriptionController.text,
      _selectedDate,
      _selectedTime,
    );

    setState(() {
      widget.tasks.add(newTask);
    });

    Navigator.pop(context,true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Enter new task'),
            ),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: Text('Select Date'),
            ),
            Text(
              _selectedDate == null
                  ? 'No Date Selected'
                  : 'Selected Date: ${_selectedDate!.toLocal()}',
            ),
            ElevatedButton(
              onPressed: () => _selectTime(context),
              child: Text('Select Time'),
            ),
            Text(
              _selectedTime == null
                  ? 'No Time Selected'
                  : 'Selected Time: ${_selectedTime!.format(context)}',
            ),
            ElevatedButton(
              onPressed: _addTask,
              child: Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }
}
