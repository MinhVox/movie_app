
import 'package:final_training_aia/constants/constants.dart';
import 'package:final_training_aia/page/main/discover/models/movie_entity.dart';
import 'package:final_training_aia/services/networking.dart';
import 'package:flutter/material.dart';

class DicoverRestRepository extends Networking {
  void getMoviePopular(
    ValueSetter<dynamic> completion,
  ) {
    final params = {
      'api_key' : Constants.apiKey,
    };
    final configuration = RequestConfiguration(
        HTTPMethod.Get, '/3/discover/tv', null, params);
    executeRequest(configuration, (response) {
      if (response.data != null) {
        final data = MoviePopularResponse.fromJson(response.data["results"]);
        completion(data);
      } else {
        completion(response.error ?? ServerError.internalError());
      }
    });
  }

  void getMovieUpcoming(
    ValueSetter<dynamic> completion,
  ) {
    final params = {
      'api_key' : Constants.apiKey,
    };
    final configuration = RequestConfiguration(
        HTTPMethod.Get, '/3/movie/upcoming', null, params);
    executeRequest(configuration, (response) {
      if (response.data != null) {
        final data = MovieUpcomingResponse.fromJson(response.data["results"]);
        print(data);
        completion(data);
      } else {
        completion(response.error ?? ServerError.internalError());
      }
    });
  }
}