import 'package:flutter/material.dart';
import '../gif_detail_view.dart';
import '../../classes/giphy.dart';

GridView gridViewToDisplayGIFs(
    List<Data> items, ScrollController scrollController, bool hasMore) {
  return GridView.builder(
    controller: scrollController,
    itemCount: items.length + (hasMore ? 1 : 0),
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
