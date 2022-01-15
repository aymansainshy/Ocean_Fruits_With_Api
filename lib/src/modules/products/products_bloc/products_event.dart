part of 'products_bloc.dart';

abstract class ProductsEvent extends Equatable {
  const ProductsEvent();

  @override
  List<Object> get props => [];
}


class FetchProducts extends ProductsEvent {
  final bool isRefresh;
  final String supCatId;
  FetchProducts({this.isRefresh = false, this.supCatId});
}

class FetchMoreProducts extends ProductsEvent {
  final String supCatId;

  FetchMoreProducts({this.supCatId});

}