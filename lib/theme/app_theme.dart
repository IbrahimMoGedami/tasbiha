import 'package:flutter/material.dart';

abstract final class TasbihaTheme {
  static const Color _seed = Color(0xFF0F766E);

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.light,
      surface: const Color(0xFFF0FDFA),
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
      ),
      textTheme: _textTheme(scheme),
    );
  }

  static TextTheme _textTheme(ColorScheme scheme) {
    final base = Typography.material2021(platform: TargetPlatform.iOS).black;
    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(
        fontWeight: FontWeight.w300,
        letterSpacing: -2,
        color: scheme.onSurface,
      ),
      titleLarge: base.titleLarge?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        color: scheme.onSurfaceVariant,
        height: 1.4,
      ),
    );
  }
}
