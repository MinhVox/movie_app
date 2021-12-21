part of 'genres_bloc.dart';

class GenresEvent extends Equatable {
  const GenresEvent();

  @override
  List<Object> get props => [];
}

class LoadGenres extends GenresEvent {

}

class GenresSuccess extends GenresEvent {
  final GenresResponse data;

  GenresSuccess(this.data);
}

class GenresFailed extends GenresEvent {
  final String error;

  GenresFailed(this.error);
}