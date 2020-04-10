
enum ItemRequirement {
  none,
  fabricator,
  laserCutter

}


class Item {
  Item(this.name, this.imageUrl, this.description, this.requiredItems);
  String name;
  String imageUrl;
  String description;
  /// Required tools to build item
  List<ItemRequirement> requiredItems;

}