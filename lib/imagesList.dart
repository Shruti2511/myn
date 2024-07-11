import 'package:flutter/material.dart';

class ImageCards extends StatelessWidget {
  final String title;
  final List<String> images;

  ImageCards({required this.title, required this.images});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(title, style: TextStyle(color: Colors.white))), // White text
        backgroundColor: Colors.grey[850], // Dark grey AppBar
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: BorderSide(color: Colors.white, width: 2), // White border
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                images[index],
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}
