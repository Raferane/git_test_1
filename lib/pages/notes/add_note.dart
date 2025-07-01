import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_training/pages/notes/view_note.dart';
import 'package:flutter_firebase_training/utils/components/z_text_form_field.dart';

class AddNote extends StatefulWidget {
  final String categoryId;
  const AddNote({super.key, required this.categoryId});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Note', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: ZTextFormField(
                controller: _noteController,
                hintText: "Enter Your Note",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Note Name is required";
                  }
                  return null;
                },
              ),
            ),
            MaterialButton(
              onPressed: () {
                CollectionReference notes = FirebaseFirestore.instance
                    .collection('categories')
                    .doc(widget.categoryId)
                    .collection('notes');
                if (_formKey.currentState!.validate()) {
                  notes
                      .add({'name': _noteController.text.trim()})
                      .then((value) {
                        print("Note added successfully");
                      })
                      .catchError((error) {
                        print("Error adding Note: $error");
                      });
                }
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => ViewNote(categoryId: widget.categoryId),
                  ),
                  (route) => route.isFirst,
                );
              },
              color: Colors.blue,
              height: 50,
              minWidth: 150,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Text(
                "Add Note",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
