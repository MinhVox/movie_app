part of 'movie_favorite_bloc.dart';

class MovieFavoriteState extends Equatable {
  final FavoriteStatus status;
  String? error;
  ListFavoriteResponse? list;
  MovieFavoriteState(this.status);

  @override
  List<Object> get props => [status];

  MovieFavoriteState copyWith(
    FavoriteStatus? status,
    ListFavoriteResponse? list,
    String? error,
  ) {
    var newState = MovieFavoriteState(status ?? this.status);
    newState.error = error ?? this.error;
    newState.list = list ?? this.list;
    return newState;
  }
}

enum FavoriteStatus { Initial, Processing, Success, Failed }
