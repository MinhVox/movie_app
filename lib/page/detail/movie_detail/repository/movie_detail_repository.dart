import 'package:final_training_aia/constants/constants.dart';
import 'package:final_training_aia/page/detail/movie_detail/models/movie_detail_entity.dart';
import 'package:final_training_aia/services/authentication_service.dart';
import 'package:final_training_aia/services/networking.dart';
import 'package:flutter/material.dart';

class MovieDetailRestRepository extends Networking{
  void getMovieDetail(
    int id,
    ValueSetter<dynamic> completion,
  )  {
    final params = {
      'api_key' : Constants.apiKey,
    };
    final configuration = RequestConfiguration(
        HTTPMethod.Get, '/3/tv/${id}', null, params);
    executeRequest(configuration, (response) {
      if (response.data != null) {
        final data = MovieDetailResponse.fromJson(response.data);
        completion(data);
      } else {
        completion(response.error ?? ServerError.internalError());
      }
    });
  }

  void getMovieTVDetail(
    int id,
    ValueSetter<dynamic> completion,
  )  {
    final params = {
      'api_key' : Constants.apiKey,
    };
    final configuration = RequestConfiguration(
        HTTPMethod.Get, '/3/movie/${id}', null, params);
    executeRequest(configuration, (response) {
      if (response.data != null) {
        final data = MovieDetailResponse.fromJson(response.data);
        completion(data);
      } else {
        completion(response.error ?? ServerError.internalError());
      }
    });
  }

  Future getListFavorite(
    String email,
    ValueSetter<dynamic> completion,
  ) async {
    AuthenticationService _authSevice = AuthenticationService();
    var result = await _authSevice.getUser(email: email);
    if (result != null) {
      ListFavoriteResponse list = ListFavoriteResponse.fromJson(result["favorite"] ?? []);
      completion(list);
    } else {
      completion(false);
    }
  }
}