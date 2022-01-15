import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ocean_fruits/src/modules/products/models/product_model.dart';
import 'package:ocean_fruits/src/modules/products/repository/poroduct_repository.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  ProductsBloc(this.productsRepository) : super(ProductsInitial());

  final ProductsRepository productsRepository;

  // int page = 1;
  List<Product> products = [];

  @override
  Stream<ProductsState> mapEventToState(ProductsEvent event) async* {
    final currentState = state;

    if (event is FetchProducts && !_hasReachedMax(state)) {
      // if (currentState is ProductsInitial) {
      try {
        yield ProductsInProgress();
        // page = 1;
        products = null;
        // await productsRepository.fetchProducts(DataRader(Urls.fetchProductsUrl(event.supCatId)));
        yield ProductsLoadedSuccess(products: products);
      } catch (e) {
        yield ProductsInFaliure(e.toString());
      }
    }
    // }

    if (event is FetchMoreProducts && !_hasReachedMax(state)) {
      if (currentState is ProductsLoadedSuccess) {
        // page++;
        products = null;
        // await productsRepository.fetchProducts(DataRader(Urls.fetchProductsUrl(event.supCatId)));

        yield products.isEmpty
            ? currentState.copyWith(noMoreData: products.isEmpty)
            : ProductsLoadedSuccess(
                products: currentState.products + products,
                noMoreData: products.isEmpty,
              );
      }
    }
  }

  bool _hasReachedMax(ProductsState state) =>
      state is ProductsLoadedSuccess && state.noMoreData;
}
