// lib/views/GifDetailView.dart
import 'package:flutter/material.dart';

class GifDetailView extends StatelessWidget {
  final String title;
  final String rating;
  final String gifUrl;
  final double width;
  final double height;

  const GifDetailView({
    Key? key,
    required this.rating,
    required this.title,
    required this.gifUrl,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("GIF Detail")),
      body: Column(
        children: [
          Text(
            "Title: $title",
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          Text("Rating: $rating"),
          Center(
            child: Image.network(
              gifUrl,
              width: width,
              height: height,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
