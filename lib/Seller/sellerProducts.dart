import 'package:flutter/material.dart';
import 'package:hackathon/Seller/addProduct.dart';

class SellerProducts extends StatelessWidget {
  final List<Product> products = [
    Product(
      imageUrl: 'assets/O1.jpg', // Replace with your image path
      name: 'Red Dress',
      rating: 4.3,
      reviews: 430,
      tag: 'Myntra Unique',
    ),
    Product(
      imageUrl: 'assets/O1.jpg', // Replace with your image path
      name: 'Black Dress',
      rating: 4.5,
      reviews: 4300,
      tag: 'Myntra Unique',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          return ProductCard(product: products[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddProductPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(product.imageUrl),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              product.name,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Text('${product.rating} ★'),
                SizedBox(width: 10),
                Text('${product.reviews} reviews'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(product.tag),
          ),
        ],
      ),
    );
  }
}

class Product {
  final String imageUrl;
  final String name;
  final double rating;
  final int reviews;
  final String tag;

  Product({
    required this.imageUrl,
    required this.name,
    required this.rating,
    required this.reviews,
    required this.tag,
  });
}
