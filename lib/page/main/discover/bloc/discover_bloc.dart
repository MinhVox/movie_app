import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:final_training_aia/page/main/discover/models/movie_entity.dart';
import 'package:final_training_aia/page/main/discover/repository/movie_repository.dart';

part 'discover_event.dart';
part 'discover_state.dart';

class DiscoverBloc extends Bloc<DiscoverEvent, DiscoverState> {
  DiscoverBloc() : super(DiscoverState(DiscoverStatus.Initial));

  @override
  Stream<DiscoverState> mapEventToState(
    DiscoverEvent event,
  ) async* {
    if (event is LoadData) {
      yield state.copyWith(DiscoverStatus.Processing, null, null,null);
      yield* _loadMoviePopularData();
      yield* _loadMovieUpcomingData();
    } else if (event is LoadMoviePopularSuccess) {
      final newState =
          state.copyWith(DiscoverStatus.PopularSuccess, event.data, null,null);
      yield newState;
    } else if (event is LoadMoviePopularFailed) {
      final newState =
          state.copyWith(DiscoverStatus.PopularFailed, null, null,event.error);
      yield newState;
    } else if (event is LoadMovieUpcomingSuccess) {
      final newState =
          state.copyWith(DiscoverStatus.UpcomingSuccess, null, event.data,null);
      yield newState;
    } else if (event is LoadMovieUpcomingFailed) {
      final newState =
          state.copyWith(DiscoverStatus.UpcomingFailed, null, null,event.error);
      yield newState;
    }
  }

  Stream<DiscoverState> _loadMoviePopularData() async* {
    final repository = DicoverRestRepository();
    try {
      repository.getMoviePopular((data) {
        if (data is MoviePopularResponse) {
          add(LoadMoviePopularSuccess(data));
        } else {
          add(LoadMoviePopularFailed("An error has occurred"));
        }
      });
    } on Exception catch (_) {
      add(LoadMoviePopularFailed("An error has occurred"));
    }
  }

  Stream<DiscoverState> _loadMovieUpcomingData() async* {
    final repository = DicoverRestRepository();
    try {
      repository.getMovieUpcoming((data) {
        if (data is MovieUpcomingResponse) {
          add(LoadMovieUpcomingSuccess(data));
        } else {
          add(LoadMovieUpcomingFailed("An error has occurred"));
        }
      });
    } on Exception catch (_) {
      add(LoadMovieUpcomingFailed("An error has occurred"));
    }
  }
}
