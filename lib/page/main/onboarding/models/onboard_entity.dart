class OnboardResponse {
  List<Onboard> onboard;

  OnboardResponse(this.onboard);

  factory OnboardResponse.fromJson(json) {
    List<Onboard> onboard = [];
    if (json != null) {
      json.forEach((value) {
        onboard.add(new Onboard.fromJson(value));
      });
    }
    return OnboardResponse(onboard);
  }
}

class Onboard {
  final String posterPath;

  Onboard(this.posterPath);

  factory Onboard.fromJson(Map<String, dynamic> json) {
    return Onboard(
      json["poster_path"],
    );
  }
}
