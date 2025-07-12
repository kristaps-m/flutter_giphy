import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'album.dart';
import 'dart:convert';

/// Displays detailed information about a SampleItem.
class SampleItemDetailsView extends StatefulWidget {
  const SampleItemDetailsView({super.key});

  static const routeName = '/sample_item';
  static const myNumber = 100;

  @override
  State<SampleItemDetailsView> createState() => _SampleItemDetailsViewState();
}

class _SampleItemDetailsViewState extends State<SampleItemDetailsView> {
  late Future<Album> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  // Future<http.Response> fetchAlbum() {
  Future<Album> fetchAlbum() async {
    final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/albums/1'),
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Album.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details'),
      ),
      body: Container(
        margin: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            FutureBuilder<Album>(
              future: futureAlbum,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data!.title);
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return const CircularProgressIndicator();
              },
            ),
          ],
          // children: [
          //   const Text(
          //       'More Information Here ${SampleItemDetailsView.myNumber}'),
          //   Image.network('https://picsum.photos/200/300'),
          //   Image.network(
          //       'https://media4.giphy.com/media/BzyTuYCmvSORqs1ABM/200.gif?cid=bd3f1be23ravmnb1kd2hwlkioduk7d6cw5vp3ecdc22vu32b&rid=200.gif&ct=g'),
          // ],
        ),
      ),
    );
  }
}
