part of 'movie_favorite_bloc.dart';

class MovieFavoriteEvent extends Equatable {
  const MovieFavoriteEvent();

  @override
  List<Object> get props => [];
}

class LoadFavList extends MovieFavoriteEvent {
  final String email;
  LoadFavList(this.email);
}

class LoadFavSuccess extends MovieFavoriteEvent {
  final ListFavoriteResponse data;

  LoadFavSuccess(this.data);
}

class LoadFavFailed extends MovieFavoriteEvent {
  final String error;
  LoadFavFailed(this.error);
}
