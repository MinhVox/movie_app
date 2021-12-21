import 'package:final_training_aia/constants/constants.dart';
import 'package:final_training_aia/page/detail/artist_detail/models/artist_detail_entity.dart';
import 'package:final_training_aia/services/networking.dart';
import 'package:flutter/material.dart';

class ArtistDetailRepository extends Networking {
  void getArtistDetail(
    int id,
    ValueSetter<dynamic> completion,
  ) {
    final params = {
      'api_key': Constants.apiKey,
    };
    final configuration =
        RequestConfiguration(HTTPMethod.Get, '/3/person/${id}', null, params);
    executeRequest(configuration, (response) {
      if (response.data != null) {
        final data = ArtistDetailResponse.fromJson(response.data);
        completion(data);
      } else {
        completion(response.error ?? ServerError.internalError());
      }
    });
  }

  void getArtistImageDetail(
    int id,
    ValueSetter<dynamic> completion,
  ) {
    final params = {
      'api_key': Constants.apiKey,
    };
    final configuration =
        RequestConfiguration(HTTPMethod.Get, '/3/person/${id}/images', null, params);
    executeRequest(configuration, (response) {
      if (response.data != null) {
        final data = ArtistImageResponse.fromJson(response.data["profiles"]);
        completion(data);
      } else {
        completion(response.error ?? ServerError.internalError());
      }
    });
  }
}
