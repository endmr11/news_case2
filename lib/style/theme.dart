import 'package:flutter/cupertino.dart';

class Colors {
  const Colors();

  static const Color mainColor = Color(0xFFF6511D);
  static const Color secondColor = Color(0xFFF6511D);
  static const Color grey = Color(0xFFE5E5E5);
  static const Color background = Color(0xFFf0f1f6);
  static const Color titleColor = Color(0xFF061857);
  static const primaryGradient = LinearGradient(
    colors: [
      Color(0xFFf6501c),
      Color(0xFFff7e00),
    ],
    stops: [0.0, 1.0],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}
