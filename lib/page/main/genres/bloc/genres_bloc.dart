import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:final_training_aia/page/main/genres/models/genres_entity.dart';
import 'package:final_training_aia/page/main/genres/repository/genres_repository.dart';

part 'genres_event.dart';
part 'genres_state.dart';

class GenresBloc extends Bloc<GenresEvent, GenresState> {
  GenresBloc() : super(GenresState(status: GenresStatus.Initial));

  @override
  Stream<GenresState> mapEventToState(
    GenresEvent event,
  ) async* {
    // TODO: implement mapEventToState
    if (event is LoadGenres) {
      yield state.copyWith(GenresStatus.Processing, null, null);
      yield* _mapGenresToState();
    } else if (event is GenresSuccess) {
      yield state.copyWith(GenresStatus.Success, event.data, null);
    } else if (event is GenresFailed) {
      yield state.copyWith(GenresStatus.Failed, null, event.error);
    }
  }

  Stream<GenresState> _mapGenresToState() async* {
    final repository = GenresRestRepository();
    try {
      repository.getMoviePopular((data) {
        if (data is GenresResponse) {
          add(GenresSuccess(data));
        } else {
          add(GenresFailed("An error has occurred"));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(
          GenresStatus.Failed, null, "An error has occurred");
    }
  }
}
