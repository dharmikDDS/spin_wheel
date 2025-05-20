import 'package:flutter/material.dart';

class TriangleClipper extends CustomClipper<Path> {
  TriangleClipper({this.isRotated = false});

  final bool isRotated;

  @override
  Path getClip(Size size) {
    final path = Path();

    if (isRotated) {
      path.lineTo(size.width / 2, size.height);
      path.lineTo(size.width, 0);
      path.close();
      return path;
    }

    path.moveTo(size.width / 2, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
