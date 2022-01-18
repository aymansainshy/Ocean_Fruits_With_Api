part of 'main_route_bloc_bloc.dart';

abstract class MainRouteState extends Equatable {
  const MainRouteState();
  
  @override
  List<Object> get props => [];
}

class MainRouteInitial extends MainRouteState {}

class MainRouteInProgress extends MainRouteState {}

class MainRouteSuccess extends MainRouteState {}

class MainRouteFailure extends MainRouteState {
  final DioError error;

 const MainRouteFailure(this.error);
}

