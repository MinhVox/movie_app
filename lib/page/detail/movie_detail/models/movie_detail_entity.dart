import 'package:final_training_aia/page/main/artist/models/artist_entity.dart';
import 'package:final_training_aia/page/main/genres/models/genres_entity.dart';

class MovieDetailResponse {
  final String posterPath;
  final ArtistResponse createdBy;
  final String overview;
  final double voteAverage;
  final GenresResponse genres;
  final String name;
  final String firstAirDate;
  final String originalLanguage;

  MovieDetailResponse(
      this.posterPath,
      this.createdBy,
      this.overview,
      this.voteAverage,
      this.genres,
      this.name,
      this.firstAirDate,
      this.originalLanguage);

  factory MovieDetailResponse.fromJson(Map<String, dynamic> json) {
    return MovieDetailResponse(
        json["backdrop_path"],
        ArtistResponse.fromJson(json["created_by"] ?? []),
        json["overview"],
        json["vote_average"],
        GenresResponse.fromJson(json["genres"] ?? []),
        json["name"] ?? json['original_title'],
        json["first_air_date"] ?? json["release_date"],
        json["original_language"]);
  }
}

class ListFavoriteResponse {
  final List<MovieFavorrite> list;

  ListFavoriteResponse(this.list);

  factory ListFavoriteResponse.fromJson(json) {
    List<MovieFavorrite> movie = [];
    if (json != null) {
      json.forEach((value) {
        movie.add(new MovieFavorrite.fromJson(value));
      });
    }
    return ListFavoriteResponse(movie);
  }
}

class MovieFavorrite {
  final String imagePath;
  final String movieName;
  final int movieId;
  final int mediaType;
  final String dateTimeCreated;

  factory MovieFavorrite.fromJson(Map<String, dynamic> json) {
    return MovieFavorrite(json["imagePath"], json["movieName"], json["movieId"],
        json["mediaType"], json["dateTimeCreated"]);
  }

  MovieFavorrite(this.imagePath, this.movieName, this.movieId, this.mediaType,
      this.dateTimeCreated);
}
