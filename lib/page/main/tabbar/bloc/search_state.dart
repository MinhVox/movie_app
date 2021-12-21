part of 'search_bloc.dart';

class SearchState extends Equatable {
  final SearchStatus status;
  SearchResultResponse? data;
  String? error;

  SearchState(this.status);
  
  @override
  List<Object> get props => [status];

   SearchState copyWith(
      SearchStatus? status,
      SearchResultResponse? data,
      String? error) {
    var newState = SearchState(status ?? this.status);
    newState.data = data ?? this.data;
    newState.error = error ?? this.error;
    return newState;
  }
}

enum SearchStatus {Initial, Processing, Success, Failed}
