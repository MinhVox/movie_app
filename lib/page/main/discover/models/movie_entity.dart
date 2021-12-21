class MoviePopularResponse {
  final List<MoviePopular> list;

  MoviePopularResponse(this.list);

  factory MoviePopularResponse.fromJson(json) {
    List<MoviePopular> movie = [];
    if (json != null) {
      json.forEach((value) {
        movie.add(new MoviePopular.fromJson(value));
      });
    }
    return MoviePopularResponse(movie);
  }
}

class MoviePopular {
  final String originalName;
  final String imgPath;
  final String? voteAverage;
  final int id;

  MoviePopular(this.originalName, this.imgPath, this.voteAverage, this.id);

  factory MoviePopular.fromJson(Map<String, dynamic> json) {
    return MoviePopular(json["name"], json["poster_path"],
        json["first_air_date"] ?? '', json["id"]);
  }
}

class MovieUpcomingResponse {
  final List<MovieUpcoming> list;

  MovieUpcomingResponse(this.list);

  factory MovieUpcomingResponse.fromJson(json) {
    List<MovieUpcoming> movie = [];
    if (json != null) {
      json.forEach((value) {
        movie.add(new MovieUpcoming.fromJson(value));
      });
    }
    return MovieUpcomingResponse(movie);
  }
}

class MovieUpcoming {
  final String originalName;
  final String imgPath;
  final String? voteAverage;
  final int id;

  MovieUpcoming(this.originalName, this.imgPath, this.voteAverage, this.id);

  factory MovieUpcoming.fromJson(Map<String, dynamic> json) {
    return MovieUpcoming(json["original_title"], json["poster_path"] ?? '',
        json["release_date"] ?? '', json["id"]);
  }
}
