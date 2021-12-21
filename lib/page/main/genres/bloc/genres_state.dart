part of 'genres_bloc.dart';

class GenresState extends Equatable {
  final GenresStatus status;
  GenresResponse? data;
  String? error;
  GenresState({required this.status});
  @override
  List<Object> get props => [status];

  GenresState copyWith(
      GenresStatus? status, GenresResponse? data, String? error) {
    var newState = GenresState(status: status ?? this.status);
    newState.data = data ?? this.data;

    newState.error = error ?? this.error;

    return newState;
  }
}

enum GenresStatus { Initial, Processing, Success, Failed }
