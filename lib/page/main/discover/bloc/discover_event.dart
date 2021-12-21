part of 'discover_bloc.dart';

class DiscoverEvent extends Equatable {
  const DiscoverEvent();

  @override
  List<Object> get props => [];
}

class LoadData extends DiscoverEvent {}

class LoadMoviePopularSuccess extends DiscoverEvent {
  final MoviePopularResponse data;

  LoadMoviePopularSuccess(this.data);
}

class LoadMoviePopularFailed extends DiscoverEvent {
  final String error;
  LoadMoviePopularFailed(this.error);
}

class LoadMovieUpcomingSuccess extends DiscoverEvent {
  final MovieUpcomingResponse data;

  LoadMovieUpcomingSuccess(this.data);
}

class LoadMovieUpcomingFailed extends DiscoverEvent {
  final String error;
  LoadMovieUpcomingFailed(this.error);
}
