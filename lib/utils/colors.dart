import 'package:flutter/material.dart';

String hexPrimaryColor = '';
Color primaryColor = Colors.white;
// Color.fromRGBO(149, 57, 51, 1);
Color iconColor = Colors.black;
// const navBarItem = white;
// const textColorPrimary = Color(0xFF212121);
// const textColorSecondary = Color(0xFF757575);
//
// const shadow_color = Color(0x95E9EBF0);
// const darkCardColor = Color(0xFF1D2939);

extension ColorExtensions on Color {
  bool isDarkness() {
    // Calculate the luminance of the color (0.0 to 1.0)
    final luminance = (0.299 * r + 0.587 * g + 0.114 * b) / 255;
    return luminance < 0.5; // Consider it dark if luminance is less than 0.5
  }
}
