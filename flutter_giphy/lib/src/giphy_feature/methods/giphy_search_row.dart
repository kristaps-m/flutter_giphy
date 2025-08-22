import 'package:flutter/material.dart';
import '../../classes/debouncer.dart';

Row giphySearchRow(
    TextEditingController searchController, void Function() performSearch) {
  final debouncer = Debouncer(milliseconds: 1500);

  return Row(
    children: [
      Expanded(
        child: TextField(
          controller: searchController,
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
            debouncer.run(() {
              //perform search here
              performSearch(); // call API after 1.5k ms;
            });
          },
          onSubmitted: (_) => performSearch(), // Also triggers on Enter
        ),
      ),
      const SizedBox(width: 8),
      ElevatedButton(
        onPressed: performSearch,
        child: const Text('GO'),
      ),
    ],
  );
}
