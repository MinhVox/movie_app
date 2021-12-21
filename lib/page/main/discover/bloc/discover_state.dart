// ignore_for_file: unnecessary_this

part of 'discover_bloc.dart';

class DiscoverState extends Equatable {
  final DiscoverStatus status;
  MoviePopularResponse? popularData;
  String? error;
  MovieUpcomingResponse? upcomingData;
  DiscoverState(this.status);

  @override
  List<Object> get props => [status];

  DiscoverState copyWith(
      DiscoverStatus? status,
      MoviePopularResponse? data,
      MovieUpcomingResponse? upcomingData,
      String? error) {
    var newState = DiscoverState(status ?? this.status);
    newState.popularData = data ?? this.popularData;
    newState.error = error ?? this.error;
    newState.upcomingData = upcomingData ?? this.upcomingData;
    return newState;
  }
}

enum DiscoverStatus { Initial, Processing, PopularSuccess, PopularFailed, UpcomingSuccess, UpcomingFailed }
