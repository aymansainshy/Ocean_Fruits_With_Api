part of 'products_bloc.dart';

abstract class ProductsState extends Equatable {
  const ProductsState();

  @override
  List<Object> get props => [];
}

class ProductsInitial extends ProductsState {}

class ProductsInProgress extends ProductsState {}

class ProductsLoadedSuccess extends ProductsState {
  final List<Product> products;
  final bool noMoreData;

  const ProductsLoadedSuccess({this.products, this.noMoreData = false});

  ProductsLoadedSuccess copyWith({List<Product> products, bool noMoreData}) {
    return ProductsLoadedSuccess(
      products: products ?? this.products,
      noMoreData: noMoreData ?? this.noMoreData,
    );
  }

  @override
  List<Object> get props => [products, noMoreData];
}

class ProductsInFaliure extends ProductsState {
  final String error;

  const ProductsInFaliure(this.error);
}
