import 'package:flutter/material.dart';

import '../settings/settings_view.dart';
import '../classes/about_item.dart';
import '../classes/generic_item.dart';
import '../classes/giphy_item.dart';

/// Displays a list of GiphyItems.
class MobileAppListView extends StatelessWidget {
  const MobileAppListView({
    super.key,
    this.items = const [GiphyItem(1), AboutItem(2)],
  });

  static const routeName = '/';

  final List<GenericItem> items;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Mobile App.'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to the settings page. If the user leaves and returns
              // to the app after it has been killed while running in the
              // background, the navigation stack is restored.
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),

      // To work with lists that may contain a large number of items, it’s best
      // to use the ListView.builder constructor.
      //
      // In contrast to the default ListView constructor, which requires
      // building all Widgets up front, the ListView.builder constructor lazily
      // builds Widgets as they’re scrolled into view.
      body: ListView.builder(
        // Providing a restorationId allows the ListView to restore the
        // scroll position when a user leaves and returns to the app after it
        // has been killed while running in the background.
        restorationId: 'MobileAppListView',
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
              title: Text(items[index].theTitle),
              leading: CircleAvatar(
                // Display the Flutter Logo image asset.
                foregroundImage: AssetImage(items[index].imageLink),
              ),
              onTap: () {
                // Navigate to the details page. If the user leaves and returns to
                // the app after it has been killed while running in the
                // background, the navigation stack is restored.
                Navigator.restorablePushNamed(context, items[index].routeName);
              });
        },
      ),
    );
  }
}
