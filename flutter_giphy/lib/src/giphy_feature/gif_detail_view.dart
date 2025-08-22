import 'package:flutter/material.dart';

import '../../styles/gif_detail_styles.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Title: $title",
                style: GifDetailStyles.titleStyle,
              ),
              Text(
                "Rating: $rating",
                style: GifDetailStyles.ratingStyle,
              ),
              const SizedBox(height: 12),
              Center(
                child: Image.network(
                  gifUrl,
                  width: width,
                  height: height,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
