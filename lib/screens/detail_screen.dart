import 'package:flutter/material.dart';
import 'package:movie/models/movie_detail_model.dart';
import 'package:movie/services/api_service.dart';
import 'package:movie/services/builder_service.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({
    super.key,
    required this.id,
    required this.poster,
    required this.category,
  });

  final int id;
  final String poster, category;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<MovieDetailModel> movie;

  @override
  void initState() {
    super.initState();
    movie = ApiService.getMovieById(widget.id);
  }

  void _onBackTap() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: widget.id.toString() + widget.category,
      child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(
                'https://image.tmdb.org/t/p/w500/${widget.poster}'),
            opacity: 0.5,
          ),
        ),
        child: Scaffold(
          appBar: AppBar(
            leadingWidth: 30,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                color: Colors.white,
                iconSize: 16,
                onPressed: _onBackTap,
              ),
            ),
            centerTitle: false,
            title: GestureDetector(
              onTap: _onBackTap,
              child: const Text(
                'Back to list',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            backgroundColor: Colors.transparent,
          ),
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 50,
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 200,
                  ),
                  showMovieDetails(
                    movie: movie,
                  ),
                  const SizedBox(
                    height: 80,
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow,
                        minimumSize: const Size(300, 65),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Buy ticket',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
