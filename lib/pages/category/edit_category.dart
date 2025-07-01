import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_training/utils/components/z_text_form_field.dart';

class EditCategory extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  const EditCategory({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _categoryController = TextEditingController();
  CollectionReference categories = FirebaseFirestore.instance.collection(
    'categories',
  );

  @override
  void initState() {
    super.initState();
    _categoryController.text = widget.categoryName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Category', style: TextStyle(color: Colors.black)),
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
                hintText: widget.categoryName,
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
                  categories.doc(widget.categoryId).set({
                    'name': _categoryController.text.trim(),
                    // ignore: require_trailing_commas
                  }, SetOptions(merge: true));
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
