import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../api_key.dart';
import 'dart:convert';
import 'gif_detail_view.dart';
import '../classes/giphy.dart';
import 'methods/giphy_search_row.dart';
import 'methods/grid_view_to_display_GIFs.dart';

/// Displays detailed information about a GiphyItem.
class GiphyItemDetailsView extends StatefulWidget {
  const GiphyItemDetailsView({super.key});

  static const routeName = '/sample_item';

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
  // final _debouncer = Debouncer(milliseconds: 1500);

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
            giphySearchRow(_searchController, _performSearch),
            const SizedBox(height: 12),
            Expanded(
                child: _items.isEmpty && !_isLoading
                    ? const Center(child: Text("No GIFs found."))
                    : gridViewToDisplayGIFs(
                        _items, _scrollController, _hasMore)),
          ],
        ),
      ),
    );
  }
}
