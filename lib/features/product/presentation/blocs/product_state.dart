abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductAdded extends ProductState {}

class ProductError extends ProductState {
  final String message;
  ProductError(this.message);

  @override
  String toString() => "ProductError: $message"; // ✅ Improved error logging
}
