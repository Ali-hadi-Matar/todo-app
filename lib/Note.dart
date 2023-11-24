import 'package:flutter/material.dart';

class Note {
  String id;
  String content;
  bool isSelected;

  Note({required this.id, required this.content, this.isSelected = false});
}


class NotesList extends StatefulWidget {
  const NotesList({super.key});

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
void _editNotes(Note note)async{
final result=await showDialog(context: context,
    builder:(context)=> _EditNotesDia(note:note),
);
if(result!=null){
  setState(() {
    note.content=result;
  });
}
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('Notes List'),
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
              margin:const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                leading: Checkbox(
                  value: notes[index].isSelected,
                  onChanged: (value) => _toggleNoteSelection(index),
                ),
                title: Text(notes[index].content),
                onTap: (){
                  _editNotes(notes[index]);
                },
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
              String uniqueId = DateTime.now().millisecondsSinceEpoch.toString();
              notes.add(Note(id: uniqueId, content: result));
            });
          }
        },
        backgroundColor: Theme.of(context).primaryColor,
        child:const Icon(Icons.add), // Set the FAB color
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
          child:const Text('Delete Selected'),
        ),
      ]
          : null,
    );
  }
}
class _EditNotesDia extends StatefulWidget {
  final Note note;

  // Corrected the constructor
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
      backgroundColor: Theme.of(context).primaryColor,
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
            primary: Theme.of(context).colorScheme.secondary,
          ),
          child: const Text('Cancel'),
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



class _AddNoteDialog extends StatefulWidget {
  @override
  __AddNoteDialogState createState() => __AddNoteDialogState();
}

class __AddNoteDialogState extends State<_AddNoteDialog> {
  final TextEditingController _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Note'),
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
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, _noteController.text);
          },
          style: ElevatedButton.styleFrom(
            primary: Theme.of(context).primaryColor, // Set the button color
          ),
          child: const Text('Add Note'),
        ),
      ],
    );
  }
}
