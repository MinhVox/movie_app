part of 'artist_detail_bloc.dart';

class ArtistDetailState extends Equatable {
  final ArtistDetailStatus status;
  ArtistDetailResponse? data;
  String? error;
  ArtistImageResponse? list;

  ArtistDetailState(this.status);
  @override
  List<Object> get props => [status];

  ArtistDetailState copyWith(
      ArtistDetailStatus? status,
      ArtistDetailResponse? data,
      String? error,
      ArtistImageResponse? list) {
    var newState = ArtistDetailState(status ?? this.status);
    newState.data = data ?? this.data;
    newState.error = error ?? this.error;
    newState.list = list ?? this.list;
    return newState;
  }
}

enum ArtistDetailStatus { Initial, Processing, Success, Failed, GetImgSuccess, GetImgFailed }
