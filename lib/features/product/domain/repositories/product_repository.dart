import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../../data/models/product_model.dart';

abstract class ProductRepository {
  Future<void> addProduct(ProductModel product, File imageFile);
}

class ProductRepositoryImpl implements ProductRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  @override
  Future<void> addProduct(ProductModel product, File imageFile) async {
    try {
      // ✅ Ensure image file exists
      if (!imageFile.existsSync()) {
        throw Exception("Image file not found!");
      }

      // ✅ Unique file path
      final String filePath =
          'products/${DateTime.now().millisecondsSinceEpoch}_${product.name}.jpg';

      // ✅ Upload to Firebase Storage
      final UploadTask uploadTask = storage.ref(filePath).putFile(imageFile);
      final TaskSnapshot taskSnapshot = await uploadTask;
      final String imageUrl = await taskSnapshot.ref.getDownloadURL();

      // ✅ Save to Firestore
      await firestore.collection('products').doc(product.id).set({
        'id': product.id,
        'name': product.name,
        'price': product.price,
        'imageUrl': imageUrl,
        'rating': product.rating,
        'description': product.description,
        'category': product.category,
        'categoryDetail': product.categoryDetail,
        'postedBy': product.postedBy, // ✅ NEW FIELD
      });
    } catch (e) {
      throw Exception("Failed to upload product: ${e.toString()}");
    }
  }
}
