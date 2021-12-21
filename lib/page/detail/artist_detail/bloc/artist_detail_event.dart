part of 'artist_detail_bloc.dart';

class ArtistDetailEvent extends Equatable {
  const ArtistDetailEvent();

  @override
  List<Object> get props => [];
}

class LoadArtistDetail extends ArtistDetailEvent {
  final int id;
  LoadArtistDetail(this.id);

}

class LoadSuccess extends ArtistDetailEvent {
  final ArtistDetailResponse data;

  LoadSuccess(this.data);
}

class LoadFailed extends ArtistDetailEvent {
  final String error;
  LoadFailed(this.error);
}

class LoadImgSuccess extends ArtistDetailEvent {
  final ArtistImageResponse data;

  LoadImgSuccess(this.data);
}

class LoadImgFailed extends ArtistDetailEvent {
  final String error;
  LoadImgFailed(this.error);
}