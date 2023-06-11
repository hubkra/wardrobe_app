class Wardrobe {
  final int? id;
  final String name;
  final String typeClothes;
  final String imageUrl;
  final String size;

  Wardrobe({
    this.id,
    required this.name,
    required this.typeClothes,
    required this.imageUrl,
    required this.size,
  });

  factory Wardrobe.fromJson(Map<String, dynamic> json) {
    return Wardrobe(
      id: json['id'],
      name: json['name'],
      typeClothes: json['typeClothes'],
      imageUrl: json['imageUrl'],
      size: json['size'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'name': name,
      'typeClothes': typeClothes,
      'imageUrl': imageUrl,
      'size': size.toString().split('.').last
    };
    if (id != null) {
      data['id'] = id;
    }
    return data;
  }
}
