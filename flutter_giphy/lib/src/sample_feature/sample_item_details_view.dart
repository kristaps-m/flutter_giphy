import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'album.dart';
import './../../api_key.dart';
// lib\src\sample_feature\sample_item_details_view.dart
import 'dart:convert';

import 'giphy.dart';

/// Displays detailed information about a SampleItem.
class SampleItemDetailsView extends StatefulWidget {
  const SampleItemDetailsView({super.key});

  static const routeName = '/sample_item';
  static const myNumber = 100;

  @override
  State<SampleItemDetailsView> createState() => _SampleItemDetailsViewState();
}

class _SampleItemDetailsViewState extends State<SampleItemDetailsView> {
  // late Future<Album> futureAlbum; // Album
  late Future<Giphy> futureAlbum; // Album
  late int myLimit = 2;
  late int myOffSet = 4;

  @override
  void initState() {
    // Album
    super.initState();
    futureAlbum = fetchAlbum();
  }
  // void initState() { // Album
  //   super.initState();
  //   futureAlbum = fetchAlbum();
  // }

  // Future<http.Response> fetchAlbum() {
  Future<Giphy> fetchAlbum() async {
    final response = await http.get(
      Uri.parse(
          'https://api.giphy.com/v1/gifs/search?api_key=$giphyApiKey&q=cat&limit=$myLimit&offset=$myOffSet&rating=g&lang=en&bundle=messaging_non_clips'),
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Giphy.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load giphy');
    }
  }
  // Future<Album> fetchAlbum() async {
  //   final response = await http.get(
  //     Uri.parse('https://jsonplaceholder.typicode.com/albums/1'),
  //   );

  //   if (response.statusCode == 200) {
  //     // If the server did return a 200 OK response,
  //     // then parse the JSON.
  //     return Album.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  //   } else {
  //     // If the server did not return a 200 OK response,
  //     // then throw an exception.
  //     throw Exception('Failed to load album');
  //   }
  // }

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
            FutureBuilder<Giphy>(
              future: futureAlbum,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final items = snapshot.data?.data ?? [];

                  print(snapshot.data?.pagination?.totalCount);
                  print(snapshot.data?.data?[0].type);

                  return Expanded(
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, i) {
                        // final type = items[i].type ?? 'No type';
                        // return ListTile(title: Text(type));
                        final item = items[i];
                        final imageUrl = item.images?.fixedWidthSmall?.url;
                        final h = int.parse(
                            item.images?.fixedWidthSmall?.height ?? '100');
                        final w = int.parse(
                            item.images?.fixedWidthSmall?.width ?? '100');
                        // final imageUrl = item.url;

                        return ListTile(
                          leading: Image.network(
                            imageUrl!,
                            width: w.toDouble(),
                            height: h.toDouble(),
                          ),
                        );
                      },
                    ),
                  );
                  // return Column(
                  //   children: List.generate(myLimit, (index) {
                  //     final type = items[index].type ?? 'No Type';
                  //     return Text(type);
                  //   }),
                  // );
                  // for (int i = 0; i < myLimit; i++) {
                  //   Text("${snapshot.data?.data?[i].type}");
                  //   // Text("${snapshot.data?.data?[i].type}");
                  // }
                  // snapshot.data?.data?.map((t) => {
                  //       return Text("${t.type}")
                  //       // return Text(snapshot.data!.data);
                  //     });
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return const CircularProgressIndicator();
              },
            ),
            // FutureBuilder<Album>(
            //   future: futureAlbum,
            //   builder: (context, snapshot) {
            //     if (snapshot.hasData) {
            //       return Text(snapshot.data!.title);
            //     } else if (snapshot.hasError) {
            //       return Text("${snapshot.error}");
            //     }
            //     return const CircularProgressIndicator();
            //   },
            // ),
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
