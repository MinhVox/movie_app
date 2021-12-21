class ArtistDetailResponse {
  final String name;
  final String department;
  final String birthday;
  final int id;
  final int gender;
  final String biography;
  final String placeOfBirth;
  final String profilePath;

  factory ArtistDetailResponse.fromJson(Map<String, dynamic> json) {
    return ArtistDetailResponse(
        json["name"],
        json["known_for_department"],
        json["birthday"],
        json["id"],
        json["gender"],
        json["biography"],
        json["place_of_birth"],
        json["profile_path"]);
  }

  ArtistDetailResponse(this.name, this.department, this.birthday, this.id,
      this.gender, this.biography, this.placeOfBirth, this.profilePath);
}

class ArtistImageResponse {
  final List<ArtistImage> list;

  ArtistImageResponse(this.list);

  factory ArtistImageResponse.fromJson(json) {
    List<ArtistImage> movie = [];
    if (json != null) {
      json.forEach((value) {
        movie.add(new ArtistImage.fromJson(value));
      });
    }
    return ArtistImageResponse(movie);
  }
}

class ArtistImage {
  final String imagePath;

  factory ArtistImage.fromJson(Map<String, dynamic> json) {
    return ArtistImage(json["file_path"]);
  }

  ArtistImage(this.imagePath);
}
