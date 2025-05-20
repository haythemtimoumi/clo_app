import '../repositories/product_repository.dart';
import '../../data/models/product_model.dart';
import 'dart:io';

class AddProductUseCase {
  final ProductRepository repository;

  AddProductUseCase({required this.repository});

  Future<void> call(ProductModel product, File imageFile) async {
    try {
      await repository.addProduct(product, imageFile);
    } catch (e) {
      print(
          "🔥 Error in AddProductUseCase: ${e.toString()}"); // ✅ Debugging log
      throw Exception("Failed to add product: ${e.toString()}");
    }
  }
}
