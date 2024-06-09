import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NoteFormPage extends StatefulWidget {
  final DocumentSnapshot? note;

  NoteFormPage({this.note});

  @override
  _NoteFormPageState createState() => _NoteFormPageState();
}

class _NoteFormPageState extends State<NoteFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _descripcion = '';
  DateTime _fecha = DateTime.now();
  String _estado = 'creado';

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _descripcion = widget.note?.get('descripcion') ?? '';
      _fecha = widget.note?.get('fecha').toDate() ?? DateTime.now();
      _estado = widget.note?.get('estado') ?? 'creado';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'Nueva Nota' : 'Editar Nota'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _descripcion,
                decoration: InputDecoration(labelText: 'Descripción'),
                onSaved: (value) => _descripcion = value ?? '',
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Por favor ingresa una descripción';
                  }
                  return null;
                },
              ),
              TextFormField(
                readOnly: true,
                initialValue: _fecha.toLocal().toString().split(' ')[0],
                decoration: InputDecoration(labelText: 'Fecha'),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _fecha,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _fecha = pickedDate;
                    });
                  }
                },
              ),
              DropdownButtonFormField<String>(
                value: _estado,
                decoration: InputDecoration(labelText: 'Estado'),
                items: ['creado', 'por hacer', 'trabajando', 'finalizado']
                    .map((label) => DropdownMenuItem(
                          child: Text(label),
                          value: label,
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _estado = value ?? 'creado';
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Por favor selecciona un estado';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveNote,
                child: Text(widget.note == null ? 'Crear' : 'Actualizar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveNote() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      if (widget.note == null) {
        FirebaseFirestore.instance.collection('notas').add({
          'descripcion': _descripcion,
          'fecha': _fecha,
          'estado': _estado,
        });
      } else {
        widget.note?.reference.update({
          'descripcion': _descripcion,
          'fecha': _fecha,
          'estado': _estado,
        });
      }
      Navigator.pop(context);
    }
  }
}
