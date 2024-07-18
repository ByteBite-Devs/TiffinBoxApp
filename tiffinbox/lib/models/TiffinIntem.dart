// lib/models/tiffin_item.dart

class TiffinItem {
  final String name;
  final String description;
  final double price;
  final List<dynamic>? mealTypes;
  final List<dynamic>? contents;
  final String dietType;
  final List<dynamic> images;
  List<dynamic>? frequency;
  final String business_id;
  late String? id;

  TiffinItem({
    required this.name,
    required this.description,
    required this.price,
    this.mealTypes,
    this.contents,
    required this.dietType,
    required this.images,
    required this.frequency,
    required this.business_id,
    String? this.id,
  });

  Object? toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'mealTypes': mealTypes,
      'contents': contents,
      'dietType': dietType,
      'images': images,
      'frequency': frequency,
      "business_id": business_id
    };
  }
}
