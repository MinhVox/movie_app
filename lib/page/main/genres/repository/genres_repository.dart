import 'package:final_training_aia/constants/constants.dart';
import 'package:final_training_aia/page/main/genres/models/genres_entity.dart';
import 'package:final_training_aia/services/networking.dart';
import 'package:flutter/material.dart';

class GenresRestRepository extends Networking {
  void getMoviePopular(
    ValueSetter<dynamic> completion,
  ) {
    final params = {
      'api_key' : Constants.apiKey,
    };
    final configuration = RequestConfiguration(
        HTTPMethod.Get, '/3/genre/movie/list', null, params);
    executeRequest(configuration, (response) {
      if (response.data != null) {
        final data = GenresResponse.fromJson(response.data["genres"]);
        completion(data);
      } else {
        completion(response.error ?? ServerError.internalError());
      }
    });
  }

}