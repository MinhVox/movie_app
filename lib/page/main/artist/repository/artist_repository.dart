import 'package:final_training_aia/constants/constants.dart';
import 'package:final_training_aia/page/main/artist/models/artist_entity.dart';
import 'package:final_training_aia/services/networking.dart';
import 'package:flutter/material.dart';

class ArtistRestRepository extends Networking {
  void getArtistPopular(
    ValueSetter<dynamic> completion,
  ) {
    final params = {
      'api_key' : Constants.apiKey,
    };
    final configuration = RequestConfiguration(
        HTTPMethod.Get, '/3/person/popular', null, params);
    executeRequest(configuration, (response) {
      if (response.data != null) {
        final data = ArtistResponse.fromJson(response.data["results"]);
        completion(data);
      } else {
        completion(response.error ?? ServerError.internalError());
      }
    });
  }

}