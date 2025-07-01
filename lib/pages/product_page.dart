import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_training/pages/product/add_product.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<QueryDocumentSnapshot> productData = [];

  bool isLoading = true;

  getData() async {
    var result =
        await FirebaseFirestore.instance
            .collection('products')
            .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .get();
    setState(() {
      productData = result.docs;
      Future.delayed(Duration(seconds: 1));
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddProduct()),
          );
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.add, color: Colors.black),
      ),
      appBar: AppBar(
        title: Text('Product Page', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        elevation: 10,
        shadowColor: Colors.black,
        backgroundColor: Colors.blue,
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Container(
                    height: 700,
                    width: 500,
                    padding: EdgeInsets.all(10),
                    child: ListView.builder(
                      padding: EdgeInsets.all(10),
                      itemCount: productData.length,
                      itemBuilder:
                          (context, index) => Card(
                            elevation: 3,
                            child: ListTile(
                              title: Text(productData[index]['name']),
                              subtitle: Text(productData[index]['description']),
                              trailing: Text(
                                "\$ ${productData[index]['price']}",
                              ),
                              leading: Column(
                                children: [
                                  //Text(productData[index]['category']),
                                ],
                              ),
                            ),
                          ),
                    ),
                  ),
                ],
              ),
    );
  }
}
