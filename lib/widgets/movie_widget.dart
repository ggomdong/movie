import 'package:flutter/material.dart';
import 'package:movie/screens/detail_screen.dart';

class Movie extends StatelessWidget {
  const Movie({
    super.key,
    required this.id,
    required this.backdrop,
    required this.poster,
    required this.title,
    required this.boxWidth,
    required this.boxHeight,
    required this.isTitle,
    required this.category,
  });

  final int id;
  final String backdrop, poster, title, category;
  final double boxWidth, boxHeight;
  final bool isTitle;

  final imageUrl = 'https://image.tmdb.org/t/p/w500';
  final popular = 'popular';

  void _onTap(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DetailScreen(
          id: id,
          poster: poster,
          category: category,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onTap(context),
      child: Column(
        children: [
          Hero(
            tag: id.toString() + category,
            child: Container(
              width: boxWidth,
              height: boxHeight,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.network(
                category == popular
                    ? '$imageUrl/$backdrop'
                    : '$imageUrl/$poster',
                fit: BoxFit.fill,
                alignment: Alignment.center,
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          if (isTitle)
            SizedBox(
              width: boxWidth,
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
