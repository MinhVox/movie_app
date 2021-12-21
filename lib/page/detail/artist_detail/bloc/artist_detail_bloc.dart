import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:final_training_aia/page/detail/artist_detail/models/artist_detail_entity.dart';
import 'package:final_training_aia/page/detail/artist_detail/repository/artist_detail_repository.dart';

part 'artist_detail_event.dart';
part 'artist_detail_state.dart';

class ArtistDetailBloc extends Bloc<ArtistDetailEvent, ArtistDetailState> {
  ArtistDetailBloc() : super(ArtistDetailState(ArtistDetailStatus.Initial));

  @override
  Stream<ArtistDetailState> mapEventToState(
    ArtistDetailEvent event,
  ) async* {
    // TODO: implement mapEventToState
    if (event is LoadArtistDetail) {
      yield state.copyWith(ArtistDetailStatus.Processing, null, null,null);
      yield* _mapArtistDetailToState(event.id);
      yield* _mapImgToState(event.id); 
    } else if (event is LoadSuccess) {
      yield state.copyWith(ArtistDetailStatus.Success, event.data, null,null);
    } else if (event is LoadFailed) {
      yield state.copyWith(ArtistDetailStatus.Failed, null, event.error,null);
    } else if (event is LoadImgSuccess) {
      yield state.copyWith(ArtistDetailStatus.GetImgSuccess, null, null,event.data);
    } else if (event is LoadImgFailed) {
      yield state.copyWith(ArtistDetailStatus.GetImgFailed, null, event.error,null);
    }
  }

  Stream<ArtistDetailState> _mapArtistDetailToState(int id) async* {
    final repository = ArtistDetailRepository();
    try {
      repository.getArtistDetail(id, (data) {
        if (data is ArtistDetailResponse) {
          add(LoadSuccess(data));
        } else {
          add(LoadFailed("An error has occurred"));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(
          ArtistDetailStatus.Failed, null, "An error has occurred",null);
    }
  }

  Stream<ArtistDetailState> _mapImgToState(int id) async* {
    final repository = ArtistDetailRepository();
    try {
      repository.getArtistImageDetail(id, (data) {
        if (data is ArtistImageResponse) {
          add(LoadImgSuccess(data));
        } else {
          add(LoadFailed("An error has occurred"));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(
          ArtistDetailStatus.Failed, null, "An error has occurred",null);
    }
  }
}
