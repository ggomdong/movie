import 'dart:async';

import 'package:flutter/material.dart';
import 'package:movie/models/movie_detail_model.dart';
import 'package:movie/models/movie_model.dart';
import 'package:movie/widgets/movie_widget.dart';

FutureBuilder<List<MovieModel>> makeMovieList({
  required Future<List<MovieModel>> movies,
  double boxWidth = 160,
  double boxHeight = 170,
  bool isTitle = true,
  required String category,
}) {
  return FutureBuilder(
    future: movies.timeout(
      const Duration(seconds: 5),
      onTimeout: () => throw TimeoutException("응답시간을 초과하였습니다."),
    ),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const CircularProgressIndicator();
      } else if (snapshot.hasError) {
        return Text(
          snapshot.error.toString(),
          style: const TextStyle(
            color: Colors.red,
          ),
        );
      } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
        return SizedBox(
            height: 280,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var movie = snapshot.data![index];
                return Movie(
                  id: movie.id,
                  poster: movie.poster,
                  backdrop: movie.backdrop,
                  title: movie.title,
                  boxWidth: boxWidth,
                  boxHeight: boxHeight,
                  isTitle: isTitle,
                  category: category,
                );
              },
              separatorBuilder: (context, index) => const SizedBox(width: 15),
            ));
      } else {
        return const Column(
          children: [
            Text(
              '영화 정보가 없습니다.',
              style: TextStyle(
                fontSize: 15,
                color: Colors.red,
              ),
            ),
            SizedBox(
              height: 50,
            )
          ],
        );
      }
    },
  );
}

FutureBuilder<MovieDetailModel> showMovieDetails({
  required Future<MovieDetailModel> movie,
}) {
  return FutureBuilder(
    future: movie.timeout(
      const Duration(seconds: 5),
      onTimeout: () => throw TimeoutException("응답시간을 초과하였습니다."),
    ),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const CircularProgressIndicator();
      } else if (snapshot.hasError) {
        return Text(
          snapshot.error.toString(),
          style: const TextStyle(
            color: Colors.red,
          ),
        );
      } else if (snapshot.hasData) {
        return SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                snapshot.data!.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                  height: 1.0,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  for (var star in makeStar(snapshot.data!.vote)) star,
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DefaultTextStyle(
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 15,
                  ),
                  child: Row(
                    children: [
                      Text(
                        '${(snapshot.data!.runtime / 60).floor()}h ${snapshot.data!.runtime % 60}min | ',
                      ),
                      Text(
                        makeGenres(snapshot.data!.genres),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              const Text(
                'Storyline',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                snapshot.data!.overview,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.1,
                  height: 1.4,
                ),
              ),
            ],
          ),
        );
      } else {
        return const Text('영화 정보가 없습니다.');
      }
    },
  );
}

String makeGenres(List<dynamic> genres) {
  String textGenre = "";

  if (genres.isNotEmpty) {
    for (var genre in genres) {
      textGenre += genre['name'];
      textGenre += ', ';
    }
    textGenre = textGenre.substring(0, textGenre.length - 2);
  } else {
    textGenre = "";
  }

  return textGenre;
}

List<Widget> makeStar(double vote) {
  int fullStar = (vote / 2.0).floor();
  bool isHalf = (vote / 2.0) - fullStar > 0.5 ? true : false;
  int emptyStar = isHalf ? 4 - fullStar : 5 - fullStar;

  List<Widget> star = [];

  for (int i = 1; i <= fullStar; i++) {
    star.add(const Icon(
      Icons.star_rounded,
      color: Colors.amber,
      size: 30,
    ));
  }

  if (isHalf) {
    star.add(const Icon(
      Icons.star_half_rounded,
      color: Colors.amber,
      size: 30,
    ));
  }

  for (int i = 1; i <= emptyStar; i++) {
    star.add(Icon(
      Icons.star_rounded,
      color: Colors.grey.withValues(alpha: 0.5),
      size: 30,
    ));
  }

  return star;
}
