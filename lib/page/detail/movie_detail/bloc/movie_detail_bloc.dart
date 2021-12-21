import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:final_training_aia/page/detail/movie_detail/models/movie_detail_entity.dart';
import 'package:final_training_aia/page/detail/movie_detail/repository/movie_detail_repository.dart';

part 'movie_detail_event.dart';
part 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  MovieDetailBloc() : super(MovieDetailState(MovieDetailStatus.Initial));

  @override
  Stream<MovieDetailState> mapEventToState(
    MovieDetailEvent event,
  ) async* {
    if (event is LoadMovieDetail) {
      yield state.copyWith(MovieDetailStatus.Processing, null, null,null);
      if(event.type == 0){
        yield* _mapTVDetailToState(event.id);
      }
      else{
        yield* _mapMovieDetailToState(event.id);
      }
      yield* _mapFavToState(event.email); 
    } else if (event is LoadSuccess) {
      yield state.copyWith(MovieDetailStatus.Success, event.data, null,null);
    } else if (event is LoadFailed) {
      yield state.copyWith(MovieDetailStatus.Failed, null, event.error,null);
    } else if (event is LoadFavSuccess) {
      yield state.copyWith(MovieDetailStatus.GetFavoriteSuccess, null, null,event.data);
    } else if (event is LoadFavFailed) {
      yield state.copyWith(MovieDetailStatus.GetFavoriteFailed, null, event.error,null);
    }
  }

  Stream<MovieDetailState> _mapTVDetailToState(int id) async* {
    final repository = MovieDetailRestRepository();
    try {
      repository.getMovieDetail(id, (data) {
        if (data is MovieDetailResponse) {
          add(LoadSuccess(data));
        } else {
          add(LoadFailed("An error has occurred"));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(
          MovieDetailStatus.Failed, null, "An error has occurred",null);
    }
  }

  Stream<MovieDetailState> _mapMovieDetailToState(int id) async* {
    final repository = MovieDetailRestRepository();
    try {
      repository.getMovieTVDetail(id, (data) {
        if (data is MovieDetailResponse) {
          add(LoadSuccess(data));
        } else {
          add(LoadFailed("An error has occurred"));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(
          MovieDetailStatus.Failed, null, "An error has occurred",null);
    }
  }

  Stream<MovieDetailState> _mapFavToState(String email) async* {
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
          MovieDetailStatus.Failed, null, "An error has occurred",null);
    }
  }
}
