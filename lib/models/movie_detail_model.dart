class MovieDetailModel {
  final int id, runtime;
  final double vote;
  final String title, overview;
  final List<dynamic> genres;

  MovieDetailModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        vote = json['vote_average'].toDouble(),
        runtime = json['runtime'],
        title = json['title'],
        overview = json['overview'],
        genres = json['genres'];
}
