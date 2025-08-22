import 'generic_item.dart';

/// A placeholder class that represents an entity or model.
class GiphyItem extends GenericItem {
  const GiphyItem(this.id) : super(0);

  final int id;
  @override
  final String routeName = '/giphy_item';
  @override
  final String theTitle = 'Giphy GIFS';
  @override
  final String imageLink = 'assets/images/gif.png';
}
