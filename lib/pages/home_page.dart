import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_training/pages/category/edit_category.dart';
import 'package:flutter_firebase_training/pages/notes/view_note.dart';
import 'package:flutter_firebase_training/utils/firebase/z_firebase_auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Stream<QuerySnapshot> _categoriesStream =
      FirebaseFirestore.instance.collection('categories').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/addCategory');
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.add, color: Colors.black),
      ),
      appBar: AppBar(
        title: Text('Home Page', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        elevation: 10,
        shadowColor: Colors.black,
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: () {
              ZFirebaseAuthService().signOut(context);
            },
            icon: Icon(Icons.logout, color: Colors.black),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _categoriesStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              Container(
                height: 700,
                width: 500,
                padding: EdgeInsets.all(10),
                child: GridView.builder(
                  itemCount: snapshot.data!.docs.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemBuilder:
                      (context, index) => InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => ViewNote(
                                    categoryId: snapshot.data!.docs[index].id,
                                  ),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(10),
                        onLongPress: () {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.warning,
                            title: 'Alert',
                            body: Text(
                              'Do you want to edit or delete this category?',
                            ),
                            btnOkText: 'Edit',
                            btnCancelText: 'Delete',
                            btnOkOnPress: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => EditCategory(
                                        categoryId:
                                            snapshot.data!.docs[index].id,
                                        categoryName:
                                            snapshot.data!.docs[index]['name'],
                                      ),
                                ),
                              );
                            },
                            btnCancelOnPress: () async {
                              await FirebaseFirestore.instance
                                  .collection('categories')
                                  .doc(snapshot.data!.docs[index].id)
                                  .delete();
                            },
                          ).show();
                        },
                        child: Card(
                          elevation: 3,
                          child: Container(
                            padding: EdgeInsets.all(15),
                            child: Column(
                              children: [
                                Image.network(
                                  'https://picsum.photos/200/300',
                                  width: 110,
                                  height: 110,
                                  fit: BoxFit.cover,
                                ),
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
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/product');
                },
                child: Text('View Products'),
              ),
            ],
          );
        },
      ),
    );
  }
}
