import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'album.dart';
import './../../api_key.dart';
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
  late Future<Giphy> futureGiphy;
  late int myLimit = 2;
  late int myOffSet = 0;
  String searchTerm = 'cat';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureGiphy = fetchGiphy();
  }

  // Future<http.Response> fetchAlbum() {
  Future<Giphy> fetchGiphy() async {
    final response = await http.get(
      Uri.parse(
          'https://api.giphy.com/v1/gifs/search?api_key=$giphyApiKey&q=$searchTerm&limit=$myLimit&offset=$myOffSet&rating=g&lang=en&bundle=messaging_non_clips'),
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

  void _performSearch() {
    setState(() {
      searchTerm = _searchController.text.trim();
      futureGiphy = fetchGiphy();
    });
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
            Row(
              children: [
                Expanded(
                  // padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: const Icon(
                        Icons.search,
                        // onPressed: _performSearch,
                      ),
                    ),
                    onSubmitted: (_) =>
                        _performSearch(), // Also triggers on Enter
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _performSearch,
                  child: const Text('GO'),
                ),
              ],
            ),
            FutureBuilder<Giphy>(
              future: futureGiphy,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final items = snapshot.data?.data ?? [];
                  // print(snapshot.data?.pagination?.totalCount);
                  return Expanded(
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, i) {
                        final item = items[i];
                        final imageUrl = item.images?.fixedWidthSmall?.url;
                        final h = int.parse(
                            item.images?.fixedWidthSmall?.height ?? '100');
                        final w = int.parse(
                            item.images?.fixedWidthSmall?.width ?? '100');

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
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return const CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }
}
