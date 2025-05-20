import 'dart:io';
import 'package:equatable/equatable.dart';
import '../../data/models/product_model.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

// ✅ Event to add a new product
class AddProductEvent extends ProductEvent {
  final ProductModel product;
  final File imageFile;

  const AddProductEvent({required this.product, required this.imageFile});

  @override
  List<Object?> get props => [product, imageFile];
}
