part of 'movie_detail_bloc.dart';

class MovieDetailState extends Equatable {
  final MovieDetailStatus status;
  MovieDetailResponse? data;
  String? error;
  ListFavoriteResponse? list;
  MovieDetailState(this.status);
  
  @override
  List<Object> get props => [status];
  MovieDetailState copyWith(
      MovieDetailStatus? status,
      MovieDetailResponse? data,
      String? error,
      ListFavoriteResponse? list) {
    var newState = MovieDetailState(status ?? this.status);
    newState.data = data ?? this.data;
    newState.error = error ?? this.error;
    newState.list = list ?? this.list;
    return newState;
  }
}


enum MovieDetailStatus { Initial, Processing, Success, Failed, GetFavoriteSuccess, GetFavoriteFailed }