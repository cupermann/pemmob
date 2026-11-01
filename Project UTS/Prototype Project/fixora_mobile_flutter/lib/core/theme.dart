import 'package:flutter/material.dart';

class Fx {
  static const primary = Color(0xFF0053DB);
  static const blue = Color(0xFF2563EB);
  static const deepBlue = Color(0xFF0647BF);
  static const orange = Color(0xFFFF7A2F);
  static const orangeLight = Color(0xFFFFA24B);
  static const bg = Color(0xFFFAF8FF);
  static const ink = Color(0xFF131B2E);
  static const muted = Color(0xFF677086);
  static const lightBlue = Color(0xFFE9EEFF);
  static const white = Colors.white;
  static const green = Color(0xFF0A9668);

  static const blueGradient = LinearGradient(
    colors: [Color(0xFF004AC6), Color(0xFF2563EB)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  static const orangeGradient = LinearGradient(
    colors: [Color(0xFFFF792D), Color(0xFFFF9740)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static final shadow = [
    BoxShadow(color: const Color(0xFF1A2862).withValues(alpha:.075),
        blurRadius: 16, offset: const Offset(0, 6)),
  ];

  static ThemeData theme() => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: bg,
    colorScheme: ColorScheme.fromSeed(seedColor: primary, surface: bg),
    fontFamily: 'Roboto',
    appBarTheme: const AppBarTheme(backgroundColor: bg, foregroundColor: ink,
        centerTitle: false, elevation: 0, surfaceTintColor: Colors.transparent),
    inputDecorationTheme: InputDecorationTheme(
      filled: true, fillColor: white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: const Color(0xFFE3E9FB).withValues(alpha:.35))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: primary, width: 1.4)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFD43D3D))),
      labelStyle: const TextStyle(color: muted),
    ),
  );
}
