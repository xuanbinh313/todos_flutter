import 'package:flutter/material.dart';
import 'package:notes_app/models/todo.dart';
import 'package:notes_app/pages/settings_page.dart';
import 'package:notes_app/todo_database.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key, required this.database});

  final String title = "Notes";
  final TodoDatabase database;

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final _textController = TextEditingController();
  List<Todo> _todos = [];

  @override
  void initState() {
    _search();
    super.initState();
  }

  void _search() async {
    final List<Todo> res = await widget.database.search();
    setState(() {
      _todos = res;
    });
  }

  void _createNote() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: TextField(
                controller: _textController,
              ),
              actions: [
                MaterialButton(
                    child: const Text("Add Note"),
                    onPressed: () async {
                      await widget.database.insert(Todo(
                          DateTime.now().millisecondsSinceEpoch,
                          _textController.text));
                      _search();
                      _textController.clear();
                      Navigator.pop(context);
                    })
              ],
            ));
  }

  void _updateNote(index) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: TextField(controller: _textController),
              actions: [
                MaterialButton(
                    child: const Text("Update"),
                    onPressed: () async {
                      _todos[index].content = _textController.text;
                      await widget.database.update(_todos[index]);
                      _search();
                      _textController.clear();
                      Navigator.pop(context);
                    })
              ],
            ));
  }

  void _deleteNote(index) async {
    await widget.database.delete(_todos[index]);
    _search();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Text("This is Header")),
             ListTile(
              title:const Text("Todos"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text("Settings"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsPage()));
              },
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(25.0),
            child: Text(
              "Notes",
              style: TextStyle(fontSize: 48),
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: _todos.length,
                itemBuilder: (context, index) {
                  final note = _todos[index];
                  return ListTile(
                    title: Text(note.content),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () => _updateNote(index),
                            icon: const Icon(Icons.edit)),
                        IconButton(
                            onPressed: () => _deleteNote(index),
                            icon: const Icon(Icons.delete))
                      ],
                    ),
                  );
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNote,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
