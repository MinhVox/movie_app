import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:final_training_aia/page/detail/movie_detail/models/movie_detail_entity.dart';
import 'package:final_training_aia/page/detail/movie_detail/repository/movie_detail_repository.dart';

part 'movie_favorite_event.dart';
part 'movie_favorite_state.dart';

class MovieFavoriteBloc extends Bloc<MovieFavoriteEvent, MovieFavoriteState> {
  MovieFavoriteBloc() : super(MovieFavoriteState(FavoriteStatus.Initial));

  @override
  Stream<MovieFavoriteState> mapEventToState(
    MovieFavoriteEvent event,
  ) async* {
    // TODO: implement mapEventToState
    if (event is LoadFavList) {
      yield state.copyWith(FavoriteStatus.Processing, null, null);
      yield* _mapFavToState(event.email);
    } else if (event is LoadFavSuccess) {
      yield state.copyWith(
          FavoriteStatus.Success, event.data,null);
    } else if (event is LoadFavFailed) {
      yield state.copyWith(
          FavoriteStatus.Failed, null, event.error);
    }
  }

  Stream<MovieFavoriteState> _mapFavToState(String email) async* {
    final repository = MovieDetailRestRepository();
    try {
      repository.getListFavorite(email, (data) {
        if (data is ListFavoriteResponse) {
          add(LoadFavSuccess(data));
        } else {
          add(LoadFavFailed("An error has occurred"));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(
          FavoriteStatus.Failed, null, "An error has occurred");
    }
  }
}
