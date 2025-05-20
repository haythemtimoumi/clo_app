import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../product/data/models/product_model.dart';
import '../../../product/presentation/screens/product_detail_screen.dart';
import '../../data/models/user_model.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  final String? postedBy;

  const ProfileScreen({super.key, this.postedBy});

  Future<UserModel?> _getUserModel() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;

    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data()!);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final String userEmail =
        postedBy ?? FirebaseAuth.instance.currentUser?.email ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FA),
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: postedBy == null
            ? const Text('My Posts', style: TextStyle(color: Colors.black))
            : FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .where('email', isEqualTo: postedBy)
                    .limit(1)
                    .get(),
                builder: (context, snapshot) {
                  String displayText = 'Posts by $postedBy';

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    print('🔄 Fetching user display name...');
                    return const Text(
                      'Loading...',
                      style: TextStyle(color: Colors.black),
                    );
                  }

                  if (snapshot.hasError) {
                    print('❌ Error fetching display name: ${snapshot.error}');
                  }

                  if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                    final userData = snapshot.data!.docs.first.data()
                        as Map<String, dynamic>;
                    final fullName = userData['fullName'];
                    print('✅ Full name found: $fullName');
                    displayText = fullName != null && fullName.isNotEmpty
                        ? 'Posts by $fullName'
                        : 'Posts by $postedBy';
                  } else {
                    print('⚠️ No user document found for $postedBy');
                  }

                  return Text(
                    displayText,
                    style: const TextStyle(color: Colors.black),
                  );
                },
              ),
        actions: [
          if (postedBy == null)
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: 'Edit Profile',
              onPressed: () async {
                final user = await _getUserModel();
                if (user != null && context.mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditProfileScreen(user: user),
                    ),
                  );
                }
              },
            ),
        ],
      ),
      body: Column(
        children: [
          if (postedBy == null)
            FutureBuilder<UserModel?>(
              future: _getUserModel(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  );
                }
                final user = snapshot.data!;
                return Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.blueAccent,
                        child:
                            Icon(Icons.person, color: Colors.white, size: 30),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.fullName ?? user.email,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user.email,
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('products')
                  .where('postedBy', isEqualTo: userEmail)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      postedBy == null
                          ? "You haven't posted any products yet."
                          : "This user hasn't posted anything yet.",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  );
                }

                List<ProductModel> myProducts = snapshot.data!.docs.map((doc) {
                  return ProductModel.fromMap(
                      doc.data() as Map<String, dynamic>, doc.id);
                }).toList();

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: GridView.builder(
                    itemCount: myProducts.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                    ),
                    itemBuilder: (context, index) {
                      final product = myProducts[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ProductDetailScreen(product: product),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade300,
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(14)),
                                  child: product.imageUrl.isNotEmpty
                                      ? Image.network(
                                          product.imageUrl,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        )
                                      : Container(
                                          width: double.infinity,
                                          color: Colors.grey[300],
                                          child: const Icon(
                                              Icons.image_not_supported,
                                              size: 50),
                                        ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "\$${product.price.toStringAsFixed(2)}",
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.green),
                                        ),
                                        Row(
                                          children: [
                                            const Icon(Icons.star,
                                                size: 16, color: Colors.amber),
                                            Text(product.rating.toString(),
                                                style: const TextStyle(
                                                    fontSize: 14)),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      product.description,
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.black54),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
