part of 'search_bloc.dart';

class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class Searching extends SearchEvent{
  final String keyword;

  Searching(this.keyword);

}

class SearchSuccess extends SearchEvent {
  final SearchResultResponse data;

  SearchSuccess(this.data);
}

class SearchFailed extends SearchEvent {
  final String error;
  SearchFailed(this.error);
}