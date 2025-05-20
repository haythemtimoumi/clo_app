import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../blocs/product_bloc.dart';
import '../blocs/product_event.dart';
import '../blocs/product_state.dart';
import '../../data/models/product_model.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController ratingController = TextEditingController();

  File? _selectedImage;
  String? selectedCategory;
  String? selectedCategoryDetail;

  final List<String> categories = ['Male', 'Female', 'Child'];
  final List<String> categoryDetails = [
    'T-Shirt',
    'Jeans',
    'Hoodie',
    'Polo Shirt',
    'Sweatpants',
    'Denim Jacket',
    'Shorts',
    'Light Jacket',
  ];

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _selectedImage = File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Product")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: pickImage,
                    child: _selectedImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              _selectedImage!,
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Container(
                            height: 180,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.add_a_photo, size: 50),
                          ),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(nameController, "Product Name", Icons.label),
                  _buildTextField(priceController, "Price", Icons.attach_money,
                      isNumber: true),
                  _buildTextField(
                      descriptionController, "Description", Icons.description,
                      maxLines: 3),
                  _buildTextField(ratingController, "Rating (1-5)", Icons.star,
                      isNumber: true),
                  const SizedBox(height: 12),
                  _buildDropdown(
                    label: "Category",
                    icon: Icons.category,
                    value: selectedCategory,
                    items: categories,
                    onChanged: (val) => setState(() => selectedCategory = val),
                  ),
                  const SizedBox(height: 12),
                  _buildDropdown(
                    label: "Category Detail",
                    icon: Icons.style,
                    value: selectedCategoryDetail,
                    items: categoryDetails,
                    onChanged: (val) =>
                        setState(() => selectedCategoryDetail = val),
                  ),
                  const SizedBox(height: 16),
                  BlocConsumer<ProductBloc, ProductState>(
                    listener: (context, state) {
                      if (state is ProductAdded) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Product added successfully!")),
                        );
                        Navigator.pop(context);
                      }
                    },
                    builder: (context, state) {
                      return ElevatedButton.icon(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if (_selectedImage == null ||
                                selectedCategory == null ||
                                selectedCategoryDetail == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text("Please complete all fields")),
                              );
                              return;
                            }

                            final user = FirebaseAuth.instance.currentUser;
                            final postedBy = user?.email ?? "Unknown";

                            final product = ProductModel(
                              id: DateTime.now().toString(),
                              name: nameController.text,
                              price: double.parse(priceController.text),
                              imageUrl: '',
                              rating: double.parse(ratingController.text),
                              description: descriptionController.text,
                              category: selectedCategory!,
                              categoryDetail: selectedCategoryDetail!,
                              postedBy: postedBy,
                            );

                            context.read<ProductBloc>().add(
                                  AddProductEvent(
                                      product: product,
                                      imageFile: _selectedImage!),
                                );
                          }
                        },
                        icon: const Icon(Icons.upload),
                        label: state is ProductLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text("Upload"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {bool isNumber = false, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey[200],
        ),
        validator: (val) =>
            val == null || val.isEmpty ? "Please enter $label" : null,
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required IconData icon,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      items:
          items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      validator: (val) => val == null ? "Please select $label" : null,
    );
  }
}
