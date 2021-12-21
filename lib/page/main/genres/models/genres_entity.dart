class GenresResponse {
  final List<Genres> list;

  GenresResponse(this.list);

  factory GenresResponse.fromJson(json) {
    List<Genres> movie = [];
    if (json != null) {
      json.forEach((value) {
        movie.add(new Genres.fromJson(value));
      });
    }
    return GenresResponse(movie);
  }
}

class Genres {
  final int id;
  final String name;

  Genres(this.id, this.name);

  factory Genres.fromJson(Map<String, dynamic> json) {
    return Genres(
      json["id"],
      json["name"],
    );
  }
}