import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'note_form_page.dart';

class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final CollectionReference notesCollection = FirebaseFirestore.instance.collection('notas');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notas'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _navigateToNoteForm(context),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: notesCollection.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No hay datos disponibles.'));
          }
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              return ListTile(
                title: Text(document['descripcion']),
                subtitle: Text(document['fecha'].toDate().toString()),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteNote(document.id),
                ),
                onTap: () => _navigateToNoteForm(context, document),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  void _navigateToNoteForm(BuildContext context, [DocumentSnapshot? document]) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoteFormPage(note: document)),
    );
  }

  void _deleteNote(String id) {
    notesCollection.doc(id).delete();
  }
}
