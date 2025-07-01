import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_training/pages/notes/add_note.dart';
import 'package:flutter_firebase_training/pages/notes/update_note.dart';

class ViewNote extends StatefulWidget {
  final String categoryId;
  const ViewNote({super.key, required this.categoryId});

  @override
  State<ViewNote> createState() => _ViewNoteState();
}

class _ViewNoteState extends State<ViewNote> {
  late final Stream<QuerySnapshot> _notesStream;

  @override
  void initState() {
    super.initState();
    _notesStream =
        FirebaseFirestore.instance
            .collection('categories')
            .doc(widget.categoryId)
            .collection('notes')
            .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddNote(categoryId: widget.categoryId),
              ),
            );
          },
          backgroundColor: Colors.blue,
          child: Icon(Icons.add, color: Colors.black),
        ),
        appBar: AppBar(
          title: Text('Notes', style: TextStyle(color: Colors.black)),
          centerTitle: true,
          elevation: 10,
          shadowColor: Colors.black,
          backgroundColor: Colors.blue,
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: _notesStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            return Padding(
              padding: const EdgeInsets.only(top: 10),
              child: GridView.builder(
                itemCount: snapshot.data!.docs.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemBuilder:
                    (context, index) => InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onLongPress: () {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.warning,
                          title: 'Alert',
                          body: Text(
                            'Do you want to edit or delete this Note?',
                          ),
                          btnOkText: 'Edit',
                          btnCancelText: 'Delete',
                          btnOkOnPress: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => UpdateNote(
                                      noteId: snapshot.data!.docs[index].id,
                                      oldNoteName:
                                          snapshot.data!.docs[index]['name'],
                                      categoryId: widget.categoryId,
                                    ),
                              ),
                            );
                          },
                          btnCancelOnPress: () async {
                            await FirebaseFirestore.instance
                                .collection('categories')
                                .doc(widget.categoryId)
                                .collection('notes')
                                .doc(snapshot.data!.docs[index].id)
                                .delete();
                            if (context.mounted) {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => ViewNote(
                                        categoryId: widget.categoryId,
                                      ),
                                ),
                                (route) => route.isFirst,
                              );
                            }
                          },
                        ).show();
                      },
                      child: Card(
                        elevation: 3,
                        child: Container(
                          padding: EdgeInsets.all(15),
                          child: Column(
                            children: [
                              SizedBox(height: 10),
                              Text(
                                snapshot.data!.docs[index]['name'],
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
              ),
            );
          },
        ),
      ),
    );
  }
}
