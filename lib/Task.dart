import 'package:flutter/material.dart';

class Task {
  String id;
  String description;
  DateTime? date;
  TimeOfDay? time;
  bool isSelected;
  Task(this.id,this.description, this.date, this.time): isSelected=false;
}
