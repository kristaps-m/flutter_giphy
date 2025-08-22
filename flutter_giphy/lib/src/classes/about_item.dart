import 'package:flutter_giphy/src/classes/generic_item.dart';

/// A placeholder class that represents an entity or model.
class AboutItem extends GenericItem {
  const AboutItem(this.id) : super(0);

  final int id;
  @override
  final String routeName = '/about_item';
  @override
  final String theTitle = 'About';
  @override
  final String imageLink = 'assets/images/flutter_logo.png';
}
