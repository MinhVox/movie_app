part of 'movie_detail_bloc.dart';

class MovieDetailEvent extends Equatable {
  const MovieDetailEvent();

  @override
  List<Object> get props => [];
}

class LoadMovieDetail extends MovieDetailEvent {
  final int id;
  final int type;
  final String email;
  LoadMovieDetail(this.id, this.type, this.email);

}

class LoadSuccess extends MovieDetailEvent {
  final MovieDetailResponse data;

  LoadSuccess(this.data);
}

class LoadFailed extends MovieDetailEvent {
  final String error;
  LoadFailed(this.error);
}

class LoadFavSuccess extends MovieDetailEvent {
  final ListFavoriteResponse data;

  LoadFavSuccess(this.data);
}

class LoadFavFailed extends MovieDetailEvent {
  final String error;
  LoadFavFailed(this.error);
}
