import 'package:wardrobe_app/models/wardrobe.dart';

class Outfit {
  final int id;
  final String? name;
  final List<Wardrobe> wardrobeItems;

  Outfit({
    required this.id,
    required this.wardrobeItems,
    this.name,
  });

  factory Outfit.fromJson(Map<String, dynamic> json) {
    final List<dynamic> wardrobeJsonList = json['wardrobeItems'];
    final List<Wardrobe> wardrobeItems =
        wardrobeJsonList.map((e) => Wardrobe.fromJson(e)).toList();

    return Outfit(
      id: json['id'],
      name: json['name'],
      wardrobeItems: wardrobeItems,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'name': name,
      'wardrobeItems': wardrobeItems.map((e) => e.toJson()).toList(),
    };
    return data;
  }
}
