import 'package:final_training_aia/constants/constants.dart';
import 'package:final_training_aia/page/main/tabbar/models/search_result_entity.dart';
import 'package:final_training_aia/services/networking.dart';
import 'package:flutter/material.dart';

class SearchRestRepository extends Networking {
  void getSearchResultPopular(
    String keyword,
    ValueSetter<dynamic> completion,
  ) {
    final params = {
      'api_key' : Constants.apiKey,
      'query' : keyword
    };
    final configuration = RequestConfiguration(
        HTTPMethod.Get, '/3/search/multi', null, params);
    executeRequest(configuration, (response) {
      if (response.data != null) {
        final data = SearchResultResponse.fromJson(response.data["results"]);
        completion(data);
      } else {
        completion(response.error ?? ServerError.internalError());
      }
    });
  }
}