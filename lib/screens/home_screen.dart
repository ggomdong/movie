import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie/models/movie_model.dart';
import 'package:movie/services/api_service.dart';
import 'package:movie/services/builder_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const String popular = "popular";
  static const String now = "now-playing";
  static const String coming = "coming-soon";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  static String _searchText = '';
  late Future<List<MovieModel>> popularMovies;
  late Future<List<MovieModel>> nowMovies;
  late Future<List<MovieModel>> comingMovies;

  @override
  void initState() {
    super.initState();
    popularMovies = ApiService.getMovies(category: HomeScreen.popular);
    nowMovies = ApiService.getMovies(category: HomeScreen.now);
    comingMovies = ApiService.getMovies(category: HomeScreen.coming);
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchText = query;
    });

    if (query.isNotEmpty) {
      popularMovies = ApiService.getMovies(
          category: HomeScreen.popular, searchText: _searchText);

      nowMovies = ApiService.getMovies(
          category: HomeScreen.now, searchText: _searchText);

      comingMovies = ApiService.getMovies(
          category: HomeScreen.coming, searchText: _searchText);
    } else {
      popularMovies = ApiService.getMovies(category: HomeScreen.popular);
      nowMovies = ApiService.getMovies(category: HomeScreen.now);
      comingMovies = ApiService.getMovies(category: HomeScreen.coming);
    }
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: CupertinoSearchTextField(
          controller: _textEditingController,
          onChanged: _onSearchChanged,
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 20,
          ),
          child: DefaultTextStyle(
            style: const TextStyle(
              color: Colors.black,
              fontSize: 25,
              fontWeight: FontWeight.w800,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Popular Movies',
                ),
                const SizedBox(
                  height: 20,
                ),
                makeMovieList(
                  movies: popularMovies,
                  boxWidth: 335,
                  boxHeight: 250,
                  isTitle: false,
                  category: HomeScreen.popular,
                ),
                const Text(
                  'Now in Cinemas',
                ),
                const SizedBox(
                  height: 20,
                ),
                makeMovieList(
                  movies: nowMovies,
                  category: HomeScreen.now,
                ),
                const Text(
                  'Coming soon',
                ),
                const SizedBox(
                  height: 20,
                ),
                makeMovieList(
                  movies: comingMovies,
                  category: HomeScreen.coming,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
