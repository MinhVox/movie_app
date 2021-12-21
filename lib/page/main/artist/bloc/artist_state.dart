part of 'artist_bloc.dart';

class ArtistState extends Equatable {
  final ArtistStatus status;
  ArtistResponse? data;
  String? error;
  ArtistState(this.status);
  
  @override
  List<Object> get props => [status];

  ArtistState copyWith(
      ArtistStatus? status,
      ArtistResponse? data,
      String? error) {
    var newState = ArtistState(status ?? this.status);
    newState.data = data ?? this.data;
    newState.error = error ?? this.error;
    return newState;
  }
}

enum ArtistStatus { Initial, Processing, Success, Failed }

