import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_training/pages/notes/view_note.dart';
import 'package:flutter_firebase_training/utils/components/z_text_form_field.dart';

class UpdateNote extends StatefulWidget {
  final String categoryId;
  final String noteId;
  final String oldNoteName;
  const UpdateNote({
    super.key,
    required this.categoryId,
    required this.oldNoteName,
    required this.noteId,
  });

  @override
  State<UpdateNote> createState() => _UpdateNoteState();
}

class _UpdateNoteState extends State<UpdateNote> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _noteController = TextEditingController();
  CollectionReference categories = FirebaseFirestore.instance.collection(
    'categories',
  );

  @override
  void initState() {
    super.initState();
    _noteController.text = widget.oldNoteName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Note', style: TextStyle(color: Colors.black)),
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
                hintText: widget.oldNoteName,
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
                if (_formKey.currentState!.validate()) {
                  categories
                      .doc(widget.categoryId)
                      .collection('notes')
                      .doc(widget.noteId)
                      .set({
                        'name': _noteController.text.trim(),
                        // ignore: require_trailing_commas
                      }, SetOptions(merge: true));
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => ViewNote(categoryId: widget.categoryId),
                    ),
                    (route) => route.isFirst,
                  );
                }
              },
              color: Colors.blue,
              height: 50,
              minWidth: 150,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Text(
                "Save",
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
