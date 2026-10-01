import 'package:flutter/material.dart';

class AppColors {
  // Neo-Brutalist & Anti-Design Primary Palette
  static const Color voidBlack = Color(0xFF050505);
  static const Color pitchBlack = Color(0xFF000000);
  static const Color starkWhite = Color(0xFFFFFFFF);

  // High-Voltage Cyberpunk / Neon Accents
  static const Color acidGreen = Color(0xFF00FF66); // PASS_GRANTED // NO_CAP
  static const Color neonYellow = Color(0xFFFFE600); // Hazard / Streak / XP
  static const Color glitchCrimson = Color(0xFFFF0055); // HAZARD_FAIL / ERROR
  static const Color cyberCyan = Color(0xFF00F0FF); // Systems / Web
  static const Color electricViolet = Color(0xFF8B00FF); // Mobile / Protocol
  static const Color hotPink = Color(0xFFFF007F); // Tag sticker accent

  // Semantic Mappings
  static const Color primary = acidGreen;
  static const Color primaryLight = Color(0xFF5CFF9D);
  static const Color primaryDark = Color(0xFF00CC52);

  static const Color secondary = cyberCyan;
  static const Color secondaryLight = Color(0xFF6BFFFF);

  static const Color accent = neonYellow;
  static const Color success = acidGreen;
  static const Color danger = glitchCrimson;
  static const Color info = cyberCyan;

  // Dark Brutalist Palette (The Void)
  static const Color darkBg = Color(0xFF080808);
  static const Color darkSurface = Color(0xFF111111);
  static const Color darkSurfaceElevated = Color(0xFF1A1A1A);
  static const Color darkBorder = Color(0xFFFFFFFF); // Sharp stark white border
  static const Color darkBorderMuted = Color(0xFF333333);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFBBBBBB);
  static const Color darkTextMuted = Color(0xFF777777);

  // Light Brutalist Palette (The Flashbang)
  static const Color lightBg = Color(0xFFF4F4F0); // Off-white concrete
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceElevated = Color(0xFFE5E5DE);
  static const Color lightBorder = Color(0xFF000000); // Sharp 2px solid black border
  static const Color lightBorderMuted = Color(0xFFCCCCCC);
  static const Color lightTextPrimary = Color(0xFF000000);
  static const Color lightTextSecondary = Color(0xFF222222);
  static const Color lightTextMuted = Color(0xFF666666);

  // Signature Neo-Brutalist Hard Drop Shadows (NO BLUR, 4px hard offset)
  static List<BoxShadow> brutalShadow(Color shadowColor, {double offset = 4.0}) => [
        BoxShadow(
          color: shadowColor,
          offset: Offset(offset, offset),
          blurRadius: 0,
          spreadRadius: 0,
        ),
      ];

  static List<BoxShadow> darkBrutalShadow({double offset = 4.0}) =>
      brutalShadow(acidGreen, offset: offset);

  static List<BoxShadow> lightBrutalShadow({double offset = 4.0}) =>
      brutalShadow(pitchBlack, offset: offset);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [acidGreen, cyberCyan],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient hazardGradient = LinearGradient(
    colors: [neonYellow, glitchCrimson],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    colors: [Color(0xFF141414), Color(0xFF0A0A0A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
