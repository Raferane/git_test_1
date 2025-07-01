import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_training/utils/components/z_text_form_field.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  CollectionReference products = FirebaseFirestore.instance.collection(
    'products',
  );

  final List<String> selectedCategories = [];
  final List<String> availableCategories = [
    'Electronics',
    'Devices',
    'Clothing',
    'Books',
    'Toys',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product', style: TextStyle(color: Colors.black)),
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
                controller: _nameController,
                hintText: "Enter Product Name",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Product Name is required";
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: ZTextFormField(
                controller: _descriptionController,
                hintText: "Enter Product Description",
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Product Description is required";
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: ZTextFormField(
                controller: _priceController,
                hintText: "Enter Product Price",
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Product Price is required";
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Select Categories",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children:
                  availableCategories.map((category) {
                    final isSelected = selectedCategories.contains(category);
                    return FilterChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            selectedCategories.add(category);
                          } else {
                            selectedCategories.remove(category);
                          }
                        });
                      },
                      selectedColor: Colors.blue.shade500,
                      backgroundColor: Colors.lightBlueAccent,
                    );
                  }).toList(),
            ),
            SizedBox(height: 90),
            MaterialButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  products
                      .add({
                        'name': _nameController.text.trim(),
                        'description': _descriptionController.text.trim(),
                        'price': _priceController.text.trim(),
                        'userId': FirebaseAuth.instance.currentUser!.uid,
                      })
                      .then((value) {
                        print("Product added successfully");
                      })
                      .catchError((error) {
                        print("Error adding product: $error");
                      });
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/product',
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
                "Add Product",
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
