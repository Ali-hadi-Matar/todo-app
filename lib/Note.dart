import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:todo_app/login.dart';

class Note {
  String id;
  String content;
  bool isSelected;

  Note({required this.id, required this.content, this.isSelected = false});
}
int userId=StateManager.userId;
String userIdString=userId.toString();

class NotesList extends StatefulWidget {
  const NotesList({super.key});

  @override
  _NotesListState createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  List<Note> notes = [];
  bool isDeleteButtonVisible = false;
  bool _loading = false;

  void _toggleNoteSelection(int index) {
    setState(() {
      notes[index].isSelected = !notes[index].isSelected;
      isDeleteButtonVisible = notes.any((note) => note.isSelected);
    });
  }

  void _deleteSelectedNotes() {
    setState(() {
      for (Note note in notes.where((note) => note.isSelected)) {
        print('HIIIII');
        _deleteSelectedTasks(note.id);
      }
      notes.removeWhere((note) => note.isSelected);

      isDeleteButtonVisible = false;
    });
  }

  Future<void> _deleteSelectedTasks(String note_id) async{
    final deleteUrl=Uri.parse('https://quicktaskapp.000webhostapp.com/deleteNotes.php');
    final deleteNoteResponse=await http.post(
        deleteUrl,
        body: {
          'note_id':note_id
        }
    );
    if(deleteNoteResponse.statusCode==200){
      print('Note deleted!${note_id}');
    }else{
      print('Failed to load tasks. Status code: ${deleteNoteResponse.statusCode}');
    }
  }




  Future<void> _updateNoteInDatabase(String noteId, String newContent,String userId) async {
    try {
      final updateNoteUrl =
      Uri.parse('https://quicktaskapp.000webhostapp.com/updateNotes.php');
      await http.post(updateNoteUrl, body: {'note-id': noteId, 'content': newContent,'user-id':userId});
      print('Note is updated');
    } catch (error) {
      print('Error updating note in the database: $error');
    }
  }


  void _editNotes(Note note) async {
    final result = await showDialog(
      context: context,
      builder: (context) => _EditNotesDia(note: note),
    );

    if (result != null) {
      await _updateNoteInDatabase(note.id, result,userIdString);

      setState(() {
        note.content = result;
      });
    }
  }

  Future<void> fetchNotes() async {
    setState(() {
      _loading = true;
    });
    final fetchNotesUrl=Uri.parse('https://quicktaskapp.000webhostapp.com/getNotes.php');

    try {
      final response = await http.post(
        fetchNotesUrl,
        body: {'user_id': userId.toString()},
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        notes = jsonResponse.map<Note>((row) {
          String id = row['id'];
          String content = row['content'];

          return Note(id: id, content: content, isSelected: false);
        }).toList();

        print('After updating notes state: $notes');
      } else {
        print('Failed to load notes. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching notes: $error');
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }




  @override
  void initState() {
    super.initState();
    _loading = true;
    fetchNotes().then((_) {
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes List'),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        actions: [
          IconButton(onPressed: fetchNotes, icon: const Icon(Icons.refresh))
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
            ),
            child: ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.white,
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(
                      vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: Checkbox(
                      value: notes[index].isSelected,
                      onChanged: (value) => _toggleNoteSelection(index),
                    ),
                    title: Text(notes[index].content),
                    onTap: () {
                      _editNotes(notes[index]);
                    },
                  ),
                );
              },
            ),
          ),
         Center( child: Visibility(
           visible: _loading,
           child: const CircularProgressIndicator(color: Color(0xFF00023D)),
         ),)
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showDialog(
            context: context,
            builder: (context) => _AddNoteDialog(),
          );

          if (result != null && result.isNotEmpty) {
            setState(() {
              String uniqueId =
              DateTime.now().millisecondsSinceEpoch.toString();
              notes.add(Note(id: uniqueId, content: result));
            });
          }
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add),
      ),
      persistentFooterButtons: isDeleteButtonVisible
          ? [
        ElevatedButton(
          onPressed: () {
            _deleteSelectedNotes();
          },
          style: ElevatedButton.styleFrom(
            primary: Theme.of(context).primaryColor,
          ),
          child: const Text('Delete Selected'),
        ),
      ]
          : null,
    );
  }

}
class _EditNotesDia extends StatefulWidget {
  final Note note;

  const _EditNotesDia({Key? key, required this.note}) : super(key: key);

  @override
  State<_EditNotesDia> createState() => _EditNotesDiaState();
}
class _EditNotesDiaState extends State<_EditNotesDia> {
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _noteController.text = widget.note.content;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Note'),
      backgroundColor: Colors.white,
      content: TextField(
        controller: _noteController,
        decoration: InputDecoration(
          labelText: 'Edit your note',
          labelStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: TextButton.styleFrom(
            backgroundColor: const Color(0xFF00023D),
          ),
          child: const Text('Cancel',style: TextStyle(color: Colors.white),),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, _noteController.text);
          },
          style: ElevatedButton.styleFrom(
            primary: Theme.of(context).primaryColor,
          ),
          child: const Text('Save Changes'),
        ),
      ],
    );
  }
}



class  _AddNoteDialog extends StatefulWidget {
  @override
  __AddNoteDialogState createState() => __AddNoteDialogState();
}

class __AddNoteDialogState extends State<_AddNoteDialog> {
  final TextEditingController _noteController = TextEditingController();


  Future<void> insertNote() async{
    final insertUrl=Uri.parse('https://quicktaskapp.000webhostapp.com/insertNotes.php');
    String userIdString=userId.toString();
    String content=_noteController.text;
    print('Sending data: user_id=$userIdString, content=$content');
    final insertResponse=await http.post(

        insertUrl,
        body: {
          'user_id':userIdString,
          'content':content
        }

    );
    print('response status: ${insertResponse.statusCode}');
    print('response body: ${insertResponse.body}');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Note',style: TextStyle(color: Color(0xFF00023D)),),
      backgroundColor: Colors.white,
      content: TextField(
        controller: _noteController,
        decoration: const InputDecoration(
          labelText: 'Enter your note',
          labelStyle: TextStyle(color: Color(0xFF00023D)),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: TextButton.styleFrom(
            backgroundColor: const Color(0xFF00023D),
          ),
          child: const Text('Cancel',style: TextStyle(color: Colors.white)),
        ),
        ElevatedButton(
          onPressed: () {

            insertNote();
            Navigator.pop(context, _noteController.text);
          },
          style: ElevatedButton.styleFrom(
            primary: Theme.of(context).primaryColor,
          ),
          child: const Text('Add Note'),
        ),
      ],
    );
  }
}
