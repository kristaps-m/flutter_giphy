import 'package:flutter/material.dart';

/// Displays detailed information about a GiphyItem.
class AboutPageView extends StatefulWidget {
  const AboutPageView({super.key});

  static const routeName = '/about_item';

  @override
  State<AboutPageView> createState() => _AboutPageViewState();
}

class _AboutPageViewState extends State<AboutPageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About page'),
      ),
      body: Container(
        margin: const EdgeInsets.all(16.0),
        child: Column(
          children: const [
            Text('Hi this is a about page more info will follow')
          ],
        ),
      ),
    );
  }
}
