// 📄 File: lib/features/auth/data/models/product_model.dart

import 'package:equatable/equatable.dart';

class ProductModel extends Equatable {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final double rating;
  final String description;
  final String category;
  final String categoryDetail;
  final String postedBy; // ✅ NEW

  const ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.rating,
    required this.description,
    required this.category,
    required this.categoryDetail,
    required this.postedBy,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'rating': rating,
      'description': description,
      'category': category,
      'categoryDetail': categoryDetail,
      'postedBy': postedBy, // ✅ NEW
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map, String documentId) {
    return ProductModel(
      id: documentId,
      name: map['name'] ?? 'Unnamed Product',
      price: (map['price'] ?? 0).toDouble(),
      imageUrl: map['imageUrl'] ?? '',
      rating: (map['rating'] ?? 0).toDouble(),
      description: map['description'] ?? 'No description available',
      category: map['category'] ?? 'Unknown',
      categoryDetail: map['categoryDetail'] ?? 'Unknown',
      postedBy: map['postedBy'] ?? 'Unknown', // ✅ NEW
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        price,
        imageUrl,
        rating,
        description,
        category,
        categoryDetail,
        postedBy
      ];
}
