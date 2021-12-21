import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:final_training_aia/page/main/artist/models/artist_entity.dart';
import 'package:final_training_aia/page/main/artist/repository/artist_repository.dart';
import 'package:final_training_aia/services/networking.dart';

part 'artist_event.dart';
part 'artist_state.dart';

class ArtistBloc extends Bloc<ArtistEvent, ArtistState> {
  ArtistBloc() : super(ArtistState(ArtistStatus.Initial));

  @override
  Stream<ArtistState> mapEventToState(
    ArtistEvent event,
  ) async* {
    // TODO: implement mapEventToState
    if (event is LoadArtist) {
      yield state.copyWith(ArtistStatus.Processing, null, null);
      yield* _mapArtistToState();
    } else if (event is LoadSucces) {
      yield state.copyWith(ArtistStatus.Success, event.data, null);
    } else if (event is LoadFailed) {
      yield state.copyWith(ArtistStatus.Failed, null, event.error);
    }
  }

  Stream<ArtistState> _mapArtistToState() async* {
    final repository = ArtistRestRepository();
    try {
      repository.getArtistPopular((data) {
        if (data is ArtistResponse) {
          add(LoadSucces(data));
        } else if (data is ServerError) {
          add(LoadFailed(ServerError.internetConnectionError().message));
        } else {
          add(LoadFailed("An error has occurred"));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(ArtistStatus.Failed, null, "An error has occurred");
    }
  }
}
