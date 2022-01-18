part of 'main_route_bloc_bloc.dart';

abstract class MainRouteBlocEvent extends Equatable {
  const MainRouteBlocEvent();

  @override
  List<Object> get props => [];
}


class FetchMainRoute extends MainRouteBlocEvent {}