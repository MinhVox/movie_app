import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:final_training_aia/page/main/tabbar/models/search_result_entity.dart';
import 'package:final_training_aia/page/main/tabbar/repository/search_repository.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchState(SearchStatus.Initial));

  @override
  Stream<SearchState> mapEventToState(
    SearchEvent event,
  ) async* {
    // TODO: implement mapEventToState
    if (event is Searching) {
      yield state.copyWith(SearchStatus.Processing, null, null);
      yield* _mapFavToState(event.keyword);
    } else if (event is SearchSuccess) {
      yield state.copyWith(SearchStatus.Success, event.data, null);
    } else if (event is SearchFailed) {
      yield state.copyWith(SearchStatus.Failed, null, event.error);
    }
  }

  Stream<SearchState> _mapFavToState(String keyword) async* {
    final repository = SearchRestRepository();
    try {
      repository.getSearchResultPopular(keyword, (data) {
        if (data is SearchResultResponse) {
          add(SearchSuccess(data));
        } else {
          add(SearchFailed("An error has occurred"));
        }
      });
    } on Exception catch (_) {
      yield state.copyWith(SearchStatus.Failed, null, "An error has occurred");
    }
  }
}
