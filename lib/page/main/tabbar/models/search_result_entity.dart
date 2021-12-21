class SearchResultResponse {
  final List<SearchResult> list;

  SearchResultResponse(this.list);

  factory SearchResultResponse.fromJson(json) {
    List<SearchResult> movie = [];
    if (json != null) {
      json.forEach((value) {
        movie.add(new SearchResult.fromJson(value));
      });
    }
    return SearchResultResponse(movie);
  }
}

class SearchResult {
  final String? posterPath;
  final String? profilePath;
  final int id;
  final String? name;
  final String? title;
  final String mediaType;
  final String? originalTitle;

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
        json["poster_path"] ?? '',
        json["profile_path"] ?? '',
        json["id"],
        json["name"] ?? '',
        json["title"] ?? '',
        json['media_type'],
        json['original_title'] ?? '');
  }

  SearchResult(this.posterPath, this.profilePath, this.id, this.name,
      this.title, this.mediaType, this.originalTitle);
}
