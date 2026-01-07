import 'package:flutter/material.dart';

class AppTypography {
  static const String fontFamily = 'Inter';

  // Weights
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;

  // Display
  static const TextStyle displayLarge = TextStyle(
    fontSize: 48,
    fontWeight: bold,
    height: 1.2,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 40,
    fontWeight: bold,
    height: 1.2,
  );

  static const TextStyle displaySmall = TextStyle(
    fontSize: 32,
    fontWeight: semiBold,
    height: 1.25,
  );

  // Headlines
  static const TextStyle h1 = TextStyle(
    fontSize: 28,
    fontWeight: semiBold,
    height: 1.3,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 24,
    fontWeight: semiBold,
    height: 1.3,
  );

  static const TextStyle h3 = TextStyle(
    fontSize: 20,
    fontWeight: medium,
    height: 1.4,
  );

  // Body
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 18,
    fontWeight: regular,
    height: 1.6,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    fontWeight: regular,
    height: 1.6,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 14,
    fontWeight: regular,
    height: 1.5,
  );

  // Labels
  static const TextStyle labelLarge = TextStyle(
    fontSize: 16,
    fontWeight: medium,
    letterSpacing: 0.2,
  );

  static const TextStyle label = TextStyle(
    fontSize: 14,
    fontWeight: medium,
    letterSpacing: 0.2,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 12,
    fontWeight: medium,
    letterSpacing: 0.3,
  );

  // Supporting
  static const TextStyle helper = TextStyle(
    fontSize: 12,
    fontWeight: regular,
    height: 1.4,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: regular,
    color: Colors.grey,
  );

  // Interaction
  static const TextStyle link = TextStyle(
    fontSize: 14,
    fontWeight: medium,
    decoration: TextDecoration.underline,
  );

  // Feedback
  static const TextStyle error = TextStyle(
    fontSize: 12,
    fontWeight: medium,
    color: Colors.redAccent,
  );

  static const TextStyle success = TextStyle(
    fontSize: 12,
    fontWeight: medium,
    color: Colors.green,
  );
}
