import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/add_product_usecase.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final AddProductUseCase addProductUseCase;

  ProductBloc({required this.addProductUseCase}) : super(ProductInitial()) {
    on<AddProductEvent>((event, emit) async {
      emit(ProductLoading());
      try {
        await addProductUseCase(event.product, event.imageFile);
        emit(ProductAdded());
      } catch (e) {
        print("🔥 Error in ProductBloc: ${e.toString()}"); // ✅ Debugging log
        emit(ProductError("Failed to add product: ${e.toString()}"));
      }
    });
  }
}
