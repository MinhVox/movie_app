class ArtistResponse {
  final List<Artist> list;

  ArtistResponse(this.list);

  factory ArtistResponse.fromJson(json) {
    List<Artist> movie = [];
    if (json != null) {
      json.forEach((value) {
        movie.add(new Artist.fromJson(value));
      });
    }
    return ArtistResponse(movie);
  }
}

class Artist {
  final String img;
  final String name;
  final int id;

  Artist(this.img, this.name, this.id);

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      json["profile_path"] ?? '/8uO0gUM8aNqYLs1OsTBQiXu0fEv.jpg',
      json["name"],
      json["id"]
    );
  }
}