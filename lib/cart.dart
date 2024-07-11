import 'package:flutter/material.dart';

class CartPage extends StatelessWidget {
  final List<String> cartImages;

  CartPage({required this.cartImages});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart', style: TextStyle(color: Colors.white)), // White text
        backgroundColor: Colors.grey[850], // Dark grey AppBar
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: cartImages.length,
        itemBuilder: (context, index) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: BorderSide(color: Colors.white, width: 2), // White border
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                cartImages[index],
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}
