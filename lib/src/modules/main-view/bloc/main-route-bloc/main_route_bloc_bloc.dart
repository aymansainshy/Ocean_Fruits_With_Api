import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:ocean_fruits/src/modules/main-view/repository/main_route_repository.dart';

part 'main_route_bloc_event.dart';
part 'main_route_bloc_state.dart';

class MainRouteBlocBloc extends Bloc<MainRouteBlocEvent, MainRouteState> {
  MainRouteBlocBloc(this.mainRouteRepository) : super(MainRouteInitial());

  final MainRouteRepository mainRouteRepository;

  @override
  Stream<MainRouteState> mapEventToState(MainRouteBlocEvent event) async* {
    if (event is FetchMainRoute) {
      try {
        yield MainRouteInProgress();
        final responseData = await mainRouteRepository.fetchMainRoute();
        
        yield MainRouteSuccess();
      } on DioError catch (error) {
        yield MainRouteFailure(error);
      }
    }
  }
}
