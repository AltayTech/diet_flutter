import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';

class BoxLogin extends StatelessWidget {
  final String? imagePath;

  BoxLogin(this.imagePath);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Scaffold(
        body: GestureDetector(
          child: Center(
            child: Hero(
              tag: 'imageHero',
              child: ImageUtils.fromNetwork(
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