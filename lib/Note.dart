import 'package:flutter/material.dart';

class Note {
  String content;
  bool isSelected;

  Note(this.content, {this.isSelected = false});
}



class NotesList extends StatefulWidget {
  @override
  _NotesListState createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  List<Note> notes = [];
  bool isDeleteButtonVisible = false;

  void _toggleNoteSelection(int index) {
    setState(() {
      notes[index].isSelected = !notes[index].isSelected;
      isDeleteButtonVisible = notes.any((note) => note.isSelected);
    });
  }

  void _deleteSelectedNotes() {
    setState(() {
      notes.removeWhere((note) => note.isSelected);
      isDeleteButtonVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes List'),
        backgroundColor: Theme.of(context).primaryColor, // Set the app bar color
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary, // Set the body background color
        ),
        child: ListView.builder(
          itemCount: notes.length,
          itemBuilder: (context, index) {
            return Card(
              color: Colors.white, // Set the card background color
              elevation: 2,
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                leading: Checkbox(
                  value: notes[index].isSelected,
                  onChanged: (value) => _toggleNoteSelection(index),
                ),
                title: Text(notes[index].content),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showDialog(
            context: context,
            builder: (context) => _AddNoteDialog(),
          );

          if (result != null && result.isNotEmpty) {
            setState(() {
              notes.add(Note(result));
            });
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor, // Set the FAB color
      ),
      persistentFooterButtons: isDeleteButtonVisible
          ? [
        ElevatedButton(
          onPressed: () {
            _deleteSelectedNotes();
          },
          style: ElevatedButton.styleFrom(
            primary: Theme.of(context).primaryColor, // Set the button color
          ),
          child: Text('Delete Selected'),
        ),
      ]
          : null,
    );
  }
}


class _AddNoteDialog extends StatefulWidget {
  @override
  __AddNoteDialogState createState() => __AddNoteDialogState();
}

class __AddNoteDialogState extends State<_AddNoteDialog> {
  TextEditingController _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Note'),
      backgroundColor: Theme.of(context).primaryColor, // Set the dialog background color
      content: TextField(
        controller: _noteController,
        decoration: InputDecoration(
          labelText: 'Enter your note',
          labelStyle: TextStyle(color: Theme.of(context).colorScheme.secondary), // Set the label color
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: TextButton.styleFrom(
            primary: Theme.of(context).colorScheme.secondary, // Set the text color
          ),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, _noteController.text);
          },
          style: ElevatedButton.styleFrom(
            primary: Theme.of(context).primaryColor, // Set the button color
          ),
          child: Text('Add Note'),
        ),
      ],
    );
  }
}
