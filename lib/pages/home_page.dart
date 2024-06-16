import 'package:flutter/material.dart';
import 'package:tarea8/services/firestore.dart'; // Importa tu servicio de Firestore
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreService firestoreService = FirestoreService(); // Instancia del servicio de Firestore
  final TextEditingController nameController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  String? selectedCenter;
  String? selectedDoctor;

  final List<String> centers = ["creado", "por hacer", "trabajando", "finalizado"];
  final List<String> doctors = ["Si", "No"];

  void openNotes({String? docID, Map<String, dynamic>? existingData}) {
    if (existingData != null) {
      nameController.text = existingData['name'] ?? '';
      noteController.text = existingData['note'] ?? '';
      selectedCenter = existingData['center'];
      selectedDoctor = existingData['doctor'];
      dateController.text = existingData['date'] ?? '';
    } else {
      nameController.clear();
      noteController.clear();
      selectedCenter = null;
      selectedDoctor = null;
      dateController.clear();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Crear una nota', style: TextStyle(color: Colors.blueAccent)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'ID',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: noteController,
              decoration: InputDecoration(
                labelText: 'Descripción',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedCenter,
              decoration: InputDecoration(
                labelText: 'Estado',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              items: centers.map((center) {
                return DropdownMenuItem<String>(
                  value: center,
                  child: Text(center),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCenter = value;
                });
              },
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedDoctor,
              decoration: InputDecoration(
                labelText: '¿Es importante?',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              items: doctors.map((doctor) {
                return DropdownMenuItem<String>(
                  value: doctor,
                  child: Text(doctor),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedDoctor = value;
                });
              },
            ),
            SizedBox(height: 10),
            TextField(
              controller: dateController,
              decoration: InputDecoration(
                labelText: 'Fecha',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  setState(() {
                    dateController.text = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                  });
                }
              },
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              final newNote = {
                'name': nameController.text,
                'note': noteController.text,
                'center': selectedCenter ?? '',
                'doctor': selectedDoctor ?? '',
                'date': dateController.text,
                'timestamp': Timestamp.now(),
              };

              if (docID == null) {
                firestoreService.addNote(noteData: newNote);
              } else {
                firestoreService.updateNotes(docID, noteData: newNote);
              }
              nameController.clear();
              noteController.clear();
              selectedCenter = null;
              selectedDoctor = null;
              dateController.clear();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 226, 123, 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text("Agregar nota"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menú de notas', style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
        backgroundColor: Color.fromARGB(255, 194, 101, 24),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openNotes(), // Cambiado para llamar a openNotes sin argumentos
        backgroundColor: Color.fromARGB(255, 15, 207, 134),
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getNotesStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<DocumentSnapshot> notesList = snapshot.data!.docs;

            return ListView.builder(
              itemCount: notesList.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = notesList[index];
                String docID = document.id;

                Map<String, dynamic> data = document.data() as Map<String, dynamic>;

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    title: Text(data['name'] ?? 'Nombre no disponible'), // Usa data['name'] o un valor por defecto si es null
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Estado: ${data['center']}'),
                        Text('Es importante: ${data['doctor']}'),
                        Text('Fecha: ${data['date']}'),
                        Text('Descripcion: ${data['note']}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () => openNotes(docID: docID, existingData: data),
                          icon: const Icon(Icons.edit, color: Colors.blueAccent),
                        ),
                        IconButton(
                          onPressed: () => firestoreService.deleteNotes(docID),
                          icon: const Icon(Icons.delete, color: Colors.redAccent),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Text("Sin notas", style: TextStyle(fontSize: 18)),
            );
          }
        },
      ),
    );
  }
}
