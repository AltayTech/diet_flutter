import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final String? imagePath;

  DetailScreen(this.imagePath);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Scaffold(
        body: GestureDetector(
          child: Center(
            child: Hero(
              tag: 'imageHero',
              child: Image.network(
                imagePath!,
                fit: BoxFit.contain,
              ),
            ),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}