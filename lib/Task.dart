import 'package:flutter/material.dart';

class Task {
  String description;
  DateTime? date;
  TimeOfDay? time;

  Task(this.description, this.date, this.time);
}
