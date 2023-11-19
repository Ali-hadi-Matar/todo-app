import 'package:flutter/material.dart';

class Task {
  String description;
  DateTime? date;
  TimeOfDay? time;
  bool isSelected;
  Task(this.description, this.date, this.time): isSelected=false;
}
