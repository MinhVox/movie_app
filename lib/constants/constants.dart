
class Constants {
  static const String patternEmail =
      r"""^[\w][\w-\.]+@([\w-]+\.)+[\w-]{2,10}$""";
  static const String patternEmailInvalidSpecialKey =
      r"^_|_-|-_|--|__|-\.|_\.|\.-|\._|\.\.|-$|_$|\.$";
  static const String prefixUrlImg = "https://image.tmdb.org/t/p/w500";
  static const String apiKey = "c734d38ab8976d1bdbc54f29fa8e689c";
}
