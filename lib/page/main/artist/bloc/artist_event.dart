part of 'artist_bloc.dart';

class ArtistEvent extends Equatable {
  const ArtistEvent();

  @override
  List<Object> get props => [];
}

class LoadArtist extends ArtistEvent {}

class LoadSucces extends ArtistEvent {
  final ArtistResponse data;

  LoadSucces(this.data);
}

class LoadFailed extends ArtistEvent {
  final String error;

  LoadFailed(this.error);
}