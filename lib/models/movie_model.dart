class MovieModel {
  final int id;
  final String poster, backdrop, title;

  MovieModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        poster = json['poster_path'],
        backdrop = json['backdrop_path'],
        title = json['title'];
}
