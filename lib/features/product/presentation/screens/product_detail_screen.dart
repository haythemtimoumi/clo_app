import 'package:flutter/material.dart';
import '../../data/models/product_model.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductModel product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🖼️ Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                product.imageUrl,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),

            // 🧾 Name & Price
            Text(
              product.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              "\$${product.price.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 18, color: Colors.green),
            ),
            const SizedBox(height: 8),

            // ⭐ Rating
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber),
                const SizedBox(width: 5),
                Text(product.rating.toString(),
                    style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 12),

            // 🧍‍♂️ Category & Details
            Row(
              children: [
                const Icon(Icons.category),
                const SizedBox(width: 5),
                Text("Category: ${product.category}"),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.style),
                const SizedBox(width: 5),
                Text("Detail: ${product.categoryDetail}"),
              ],
            ),
            const SizedBox(height: 12),

            // 👤 Posted By
            Row(
              children: [
                const Icon(Icons.person_outline),
                const SizedBox(width: 5),
                Text("Posted by: ${product.postedBy}"),
              ],
            ),
            const SizedBox(height: 12),

            // 📝 Description
            const Text("Description",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(product.description),
          ],
        ),
      ),
    );
  }
}
