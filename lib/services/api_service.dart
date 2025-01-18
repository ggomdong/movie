import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movie/models/movie_detail_model.dart';
import 'package:movie/models/movie_model.dart';

class ApiService {
  static const String baseUrl = "https://movies-api.nomadcoders.workers.dev";

  static Future<List<MovieModel>> getMovies({
    required String category,
    String? searchText,
  }) async {
    List<MovieModel> movieInstances = [];
    final url = Uri.parse('$baseUrl/$category');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> movies = jsonDecode(response.body)['results'];
      for (var movie in movies) {
        if (searchText != null) {
          if (searchText.isNotEmpty &&
              movie["title"].toString().toLowerCase().contains(searchText)) {
            movieInstances.add(MovieModel.fromJson(movie));
          }
        } else {
          movieInstances.add(MovieModel.fromJson(movie));
        }
      }
      return movieInstances;
    }
    throw Error();
  }

  static Future<MovieDetailModel> getMovieById(int id) async {
    final url = Uri.parse('$baseUrl/movie?id=$id');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final movie = jsonDecode(utf8.decode(response.bodyBytes));
      return MovieDetailModel.fromJson(movie);
    }
    throw Error();
  }
}
