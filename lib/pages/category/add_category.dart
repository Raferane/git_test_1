import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_training/utils/components/z_text_form_field.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _categoryController = TextEditingController();
  CollectionReference categories = FirebaseFirestore.instance.collection(
    'categories',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Category', style: TextStyle(color: Colors.black)),
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
                controller: _categoryController,
                hintText: "Enter Category Name",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Category Name is required";
                  }
                  return null;
                },
              ),
            ),
            MaterialButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  categories
                      .add({
                        'name': _categoryController.text.trim(),
                        'userId': FirebaseAuth.instance.currentUser!.uid,
                      })
                      .then((value) {
                        print("Category added successfully");
                      })
                      .catchError((error) {
                        print("Error adding category: $error");
                      });
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/home',
                    (route) => false,
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
                "Add Category",
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
