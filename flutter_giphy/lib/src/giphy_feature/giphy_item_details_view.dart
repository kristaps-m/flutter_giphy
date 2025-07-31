import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../classes/debouncer.dart';
import '../../api_key.dart';
import 'dart:convert';
import 'gif_detail_view.dart';
import 'giphy.dart';

/// Displays detailed information about a GiphyItem.
class GiphyItemDetailsView extends StatefulWidget {
  const GiphyItemDetailsView({super.key});

  static const routeName = '/sample_item';
  static const myNumber = 100;

  @override
  State<GiphyItemDetailsView> createState() => _GiphyItemDetailsViewState();
}

class _GiphyItemDetailsViewState extends State<GiphyItemDetailsView> {
  final ScrollController _scrollController = ScrollController();
  final List<Data> _items = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int myLimit = 20;
  int myOffSet = 0;
  String searchTerm = 'cat';
  final TextEditingController _searchController = TextEditingController();
  final _debouncer = Debouncer(milliseconds: 3000);

  @override
  void initState() {
    super.initState();
    _loadMore();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !_isLoading &&
          _hasMore) {
        _loadMore();
      }
    });
  }

  Future<void> _loadMore() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(Uri.parse(
          'https://api.giphy.com/v1/gifs/search?api_key=$giphyApiKey&q=$searchTerm&limit=$myLimit&offset=$myOffSet&rating=g&lang=en&bundle=messaging_non_clips'));

      if (response.statusCode == 200) {
        final giphy = Giphy.fromJson(jsonDecode(response.body));
        final newItems = giphy.data ?? [];

        setState(() {
          myOffSet += myLimit;
          _items.addAll(newItems);
          _hasMore = newItems.isNotEmpty;
        });
      } else {
        throw Exception("API failed");
      }
    } catch (e) {
      debugPrint("Error loading: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _performSearch() {
    setState(() {
      searchTerm = _searchController.text.trim();
      myOffSet = 0;
      _items.clear();
      _hasMore = true;
    });
    _loadMore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search favorite gif...'),
      ),
      body: Container(
        margin: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Text(
            //   'Debug: limit $myLimit offSet $myOffSet items.len ${_items.length}',
            //   style: const TextStyle(height: 5, fontSize: 10),
            // ),
            giphySearchRow(),
            const SizedBox(height: 12),
            Expanded(
                child: _items.isEmpty && !_isLoading
                    ? const Center(child: Text("No GIFs found."))
                    : gridViewToDisplayGIFs(_items)),
          ],
        ),
      ),
    );
  }

  GridView gridViewToDisplayGIFs(List<Data> items) {
    return GridView.builder(
      controller: _scrollController,
      itemCount: items.length + (_hasMore ? 1 : 0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // number of columns
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 1, // adjust if images are too tall/wide
      ),
      itemBuilder: (context, i) {
        if (i >= items.length) {
          return const Center(child: CircularProgressIndicator());
        }
        final item = items[i];
        // detailed gif data.
        final original = item.images?.original;
        final gifUrl = original?.url ?? '';
        final title = item.title ?? '';
        final rating = item.rating ?? '';
        final originalWidth = double.tryParse(original?.width ?? '') ?? 400;
        final originalHeight = double.tryParse(original?.height ?? '') ?? 225;
        // grid gif data.
        final fixedWidth = item.images?.fixedWidth;
        final imageUrl = fixedWidth?.url ?? '';
        final h = double.tryParse(fixedWidth?.height ?? '') ?? 112;
        final w = double.tryParse(fixedWidth?.width ?? '') ?? 200;

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => GifDetailView(
                  title: title,
                  rating: rating,
                  gifUrl: gifUrl,
                  width: originalWidth,
                  height: originalHeight,
                ),
              ),
            );
          },
          child: Image.network(
            imageUrl,
            width: w,
            height: h,
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }

  Row giphySearchRow() {
    return Row(
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
              ),
            ),
            onChanged: (string) {
              _debouncer.run(() {
                //perform search here
                _performSearch(); // call API after 3k ms;
              });
            },
            onSubmitted: (_) => _performSearch(), // Also triggers on Enter
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: _performSearch,
          child: const Text('GO'),
        ),
      ],
    );
  }
}
