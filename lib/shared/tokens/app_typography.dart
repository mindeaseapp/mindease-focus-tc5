import 'package:flutter/material.dart';

class AppTypography {
  AppTypography._();

  static const String fontFamily = 'Inter';

  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;

  static const TextStyle displayLarge = TextStyle(
    fontSize: 48,
    fontWeight: bold,
    height: 1.2,
    letterSpacing: -0.5,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 40,
    fontWeight: bold,
    height: 1.2,
    letterSpacing: -0.25,
  );

  static const TextStyle displaySmall = TextStyle(
    fontSize: 32,
    fontWeight: semiBold,
    height: 1.25,
  );

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

  static const TextStyle h4 = TextStyle(
    fontSize: 18,
    fontWeight: medium,
    height: 1.4,
  );

  static const TextStyle titleLarge = TextStyle(
    fontSize: 18,
    fontWeight: semiBold,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: semiBold,
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: 14,
    fontWeight: medium,
  );

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

  static const TextStyle labelLarge = TextStyle(
    fontSize: 16,
    fontWeight: medium,
    letterSpacing: 0.3,
  );

  static const TextStyle label = TextStyle(
    fontSize: 14,
    fontWeight: medium,
    letterSpacing: 0.2,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 12,
    fontWeight: medium,
    letterSpacing: 0.4,
  );

  static const TextStyle navItem = TextStyle(
    fontSize: 14,
    fontWeight: medium,
  );

  static const TextStyle navItemActive = TextStyle(
    fontSize: 14,
    fontWeight: semiBold,
  );

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

  static const TextStyle overline = TextStyle(
    fontSize: 11,
    fontWeight: medium,
    letterSpacing: 1.2,
  );

  static const TextStyle link = TextStyle(
    fontSize: 14,
    fontWeight: medium,
    decoration: TextDecoration.underline,
  );

  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: semiBold,
    letterSpacing: 0.5,
  );

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

  static const TextStyle warning = TextStyle(
    fontSize: 12,
    fontWeight: medium,
    color: Colors.orange,
  );

  static const TextStyle info = TextStyle(
    fontSize: 12,
    fontWeight: medium,
    color: Colors.blue,
  );

  static const TextStyle mono = TextStyle(
    fontFamily: 'monospace',
    fontSize: 13,
    height: 1.4,
  );

  static TextStyle responsive(
    BuildContext context,
    TextStyle base,
  ) {
    final width = MediaQuery.of(context).size.width;

    if (width >= 1200) {
      return base.copyWith(fontSize: base.fontSize! * 1.15);
    } else if (width >= 800) {
      return base.copyWith(fontSize: base.fontSize! * 1.05);
    }
    return base;
  }
}
