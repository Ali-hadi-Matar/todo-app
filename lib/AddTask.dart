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

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body:Container(
        decoration: BoxDecoration(
          color: Color(0xFF2A6594), // Set the body background color
        ),
      child: Padding(

        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Enter new task',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(width: 8),
                  Text('Select Date'),
                ],
              ),
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: 8),
            Text(
              _selectedDate == null
                  ? 'No Date Selected'
                  : 'Selected Date: ${_selectedDate!.toLocal()}',
            ),
            SizedBox(height: 16),



            ElevatedButton(
              onPressed: () => _selectTime(context),
              child: Row(
                children: [
                  Icon(
                    Icons.access_time,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(width: 8),
                  Text('Select Time'),
                ],
              ),
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor,
              ),
            ),

            SizedBox(height: 8),
            Text(
              _selectedTime == null
                  ? 'No Time Selected'
                  : 'Selected Time: ${_selectedTime!.format(context)}',
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addTask,
              child: Text('Add Task'),
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor,
              ),
            ),

          ],
        ),
      ),
    )
    );
  }
}
