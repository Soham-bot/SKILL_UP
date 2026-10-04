import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

@immutable
class AppStatusColors extends ThemeExtension<AppStatusColors> {
  final Color success;
  final Color onSuccess;
  final Color successContainer;
  final Color onSuccessContainer;
  final Color warning;
  final Color onWarning;
  final Color warningContainer;
  final Color onWarningContainer;
  final Color certificateGold;
  final Color certificateNavy;
  final Color certificateIvory;

  const AppStatusColors({
    required this.success,
    required this.onSuccess,
    required this.successContainer,
    required this.onSuccessContainer,
    required this.warning,
    required this.onWarning,
    required this.warningContainer,
    required this.onWarningContainer,
    required this.certificateGold,
    required this.certificateNavy,
    required this.certificateIvory,
  });

  @override
  AppStatusColors copyWith({
    Color? success,
    Color? onSuccess,
    Color? successContainer,
    Color? onSuccessContainer,
    Color? warning,
    Color? onWarning,
    Color? warningContainer,
    Color? onWarningContainer,
    Color? certificateGold,
    Color? certificateNavy,
    Color? certificateIvory,
  }) {
    return AppStatusColors(
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      successContainer: successContainer ?? this.successContainer,
      onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      warningContainer: warningContainer ?? this.warningContainer,
      onWarningContainer: onWarningContainer ?? this.onWarningContainer,
      certificateGold: certificateGold ?? this.certificateGold,
      certificateNavy: certificateNavy ?? this.certificateNavy,
      certificateIvory: certificateIvory ?? this.certificateIvory,
    );
  }

  @override
  AppStatusColors lerp(ThemeExtension<AppStatusColors>? other, double t) {
    if (other is! AppStatusColors) return this;
    return AppStatusColors(
      success: Color.lerp(success, other.success, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
      successContainer: Color.lerp(successContainer, other.successContainer, t)!,
      onSuccessContainer: Color.lerp(onSuccessContainer, other.onSuccessContainer, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      onWarning: Color.lerp(onWarning, other.onWarning, t)!,
      warningContainer: Color.lerp(warningContainer, other.warningContainer, t)!,
      onWarningContainer: Color.lerp(onWarningContainer, other.onWarningContainer, t)!,
      certificateGold: Color.lerp(certificateGold, other.certificateGold, t)!,
      certificateNavy: Color.lerp(certificateNavy, other.certificateNavy, t)!,
      certificateIvory: Color.lerp(certificateIvory, other.certificateIvory, t)!,
    );
  }

  static const light = AppStatusColors(
    success: Color(0xFF4F7F6A), // Soft sage
    onSuccess: Color(0xFFFFFFFF),
    successContainer: Color(0xFFE3EDE7),
    onSuccessContainer: Color(0xFF1D3B2E),
    warning: Color(0xFFB5654A), // Muted terracotta
    onWarning: Color(0xFFFFFFFF),
    warningContainer: Color(0xFFF9ECE8),
    onWarningContainer: Color(0xFF4A1F13),
    certificateGold: Color(0xFFB08D57), // Muted antique gold
    certificateNavy: Color(0xFF2B3A67), // Deep navy
    certificateIvory: Color(0xFFFAF8F4), // Warm ivory
  );

  static const dark = AppStatusColors(
    success: Color(0xFF6EA88E),
    onSuccess: Color(0xFF0F261C),
    successContainer: Color(0xFF233B30),
    onSuccessContainer: Color(0xFFBCE3D2),
    warning: Color(0xFFD68A73),
    onWarning: Color(0xFF38140B),
    warningContainer: Color(0xFF48251C),
    onWarningContainer: Color(0xFFF4D1C7),
    certificateGold: Color(0xFFC7A56F),
    certificateNavy: Color(0xFF1E2A4D),
    certificateIvory: Color(0xFFFAF8F4), // Keeps ivory for printable authenticity
  );
}

class AppTheme {
  // Pure color definitions strictly contained in app_theme.dart
  static const Color primarySeed = Color(0xFF2B3A67); // Deep navy-indigo
  static const Color accentGold = Color(0xFFB08D57);  // Muted antique gold

  // Light palette
  static const Color lightSurface = Color(0xFFFAF8F4); // Warm ivory
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightOutline = Color(0xFFE4E0D8);
  static const Color lightOnSurface = Color(0xFF1F2430);
  static const Color lightSurfaceVariant = Color(0xFFF2EFE9);

  // Dark palette
  static const Color darkSurface = Color(0xFF12151F); // Deep ink
  static const Color darkCard = Color(0xFF1A1F2E);
  static const Color darkOutline = Color(0xFF2A3042);
  static const Color darkOnSurface = Color(0xFFE8ECF5);
  static const Color darkSurfaceVariant = Color(0xFF22293D);

  static ThemeData get lightTheme {
    final baseScheme = ColorScheme.fromSeed(
      seedColor: primarySeed,
      brightness: Brightness.light,
    );

    final colorScheme = baseScheme.copyWith(
      primary: primarySeed,
      onPrimary: Colors.white,
      primaryContainer: const Color(0xFFD9E1F2),
      onPrimaryContainer: const Color(0xFF121C38),
      secondary: const Color(0xFF4B5A7E),
      onSecondary: Colors.white,
      secondaryContainer: const Color(0xFFE0E5F0),
      onSecondaryContainer: const Color(0xFF19233B),
      tertiary: accentGold,
      onTertiary: Colors.white,
      tertiaryContainer: const Color(0xFFF7EEDD),
      onTertiaryContainer: const Color(0xFF3D2E14),
      surface: lightSurface,
      onSurface: lightOnSurface,
      surfaceContainerLowest: Colors.white,
      surfaceContainerLow: lightSurface,
      surfaceContainer: lightCard,
      surfaceContainerHigh: lightSurfaceVariant,
      surfaceContainerHighest: const Color(0xFFEAE6DD),
      outline: lightOutline,
      outlineVariant: const Color(0xFFD0CBC1),
    );

    return _buildTheme(colorScheme, AppStatusColors.light);
  }

  static ThemeData get darkTheme {
    final baseScheme = ColorScheme.fromSeed(
      seedColor: primarySeed,
      brightness: Brightness.dark,
    );

    final colorScheme = baseScheme.copyWith(
      primary: const Color(0xFF9CADDB),
      onPrimary: const Color(0xFF121C38),
      primaryContainer: const Color(0xFF2B3A67),
      onPrimaryContainer: const Color(0xFFDCE3F5),
      secondary: const Color(0xFFA5B2D1),
      onSecondary: const Color(0xFF1C253B),
      secondaryContainer: const Color(0xFF2D3955),
      onSecondaryContainer: const Color(0xFFD6DEF2),
      tertiary: const Color(0xFFC7A56F),
      onTertiary: const Color(0xFF33250D),
      tertiaryContainer: const Color(0xFF4A3A1F),
      onTertiaryContainer: const Color(0xFFF2E5D0),
      surface: darkSurface,
      onSurface: darkOnSurface,
      surfaceContainerLowest: const Color(0xFF0D1018),
      surfaceContainerLow: darkSurface,
      surfaceContainer: darkCard,
      surfaceContainerHigh: darkSurfaceVariant,
      surfaceContainerHighest: const Color(0xFF2C344E),
      outline: darkOutline,
      outlineVariant: const Color(0xFF3A4259),
    );

    return _buildTheme(colorScheme, AppStatusColors.dark);
  }

  static ThemeData _buildTheme(ColorScheme colorScheme, AppStatusColors statusColors) {
    final isDark = colorScheme.brightness == Brightness.dark;

    // Headings in Serif (Fraunces / Cormorant Garamond), Body in Inter (Sans)
    final textTheme = TextTheme(
      displayLarge: GoogleFonts.fraunces(
        fontSize: 34,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
        color: colorScheme.onSurface,
        height: 1.25,
      ),
      displayMedium: GoogleFonts.fraunces(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.4,
        color: colorScheme.onSurface,
        height: 1.3,
      ),
      displaySmall: GoogleFonts.fraunces(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        color: colorScheme.onSurface,
        height: 1.3,
      ),
      headlineLarge: GoogleFonts.fraunces(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
        height: 1.35,
      ),
      headlineMedium: GoogleFonts.fraunces(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: colorScheme.onSurface,
        height: 1.35,
      ),
      headlineSmall: GoogleFonts.fraunces(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: colorScheme.onSurface,
        height: 1.4,
      ),
      titleLarge: GoogleFonts.fraunces(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
        height: 1.4,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: colorScheme.onSurface,
        height: 1.45,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: colorScheme.onSurface,
        height: 1.45,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: colorScheme.onSurface,
        height: 1.55,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: colorScheme.onSurface.withOpacity(0.88),
        height: 1.5,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: colorScheme.onSurface.withOpacity(0.72),
        height: 1.5,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
        color: colorScheme.onSurface,
        height: 1.4,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.3,
        color: colorScheme.onSurface.withOpacity(0.8),
        height: 1.4,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        color: colorScheme.onSurface.withOpacity(0.65),
        height: 1.35,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: colorScheme.surface,
      extensions: [statusColors],
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0.5,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
        ),
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surfaceContainer,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: colorScheme.outline,
            width: 1,
          ),
        ),
        margin: EdgeInsets.zero,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          minimumSize: const Size(48, 48),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          minimumSize: const Size(48, 48),
          side: BorderSide(color: colorScheme.outline, width: 1.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          minimumSize: const Size(48, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainer,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: statusColors.warning, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: statusColors.warning, width: 1.8),
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurface.withOpacity(0.45),
        ),
        errorStyle: textTheme.bodySmall?.copyWith(
          color: statusColors.warning,
          fontWeight: FontWeight.w500,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceContainerHigh,
        selectedColor: colorScheme.primaryContainer,
        secondarySelectedColor: colorScheme.primaryContainer,
        labelStyle: textTheme.labelMedium?.copyWith(
          color: colorScheme.onSurface,
        ),
        secondaryLabelStyle: textTheme.labelMedium?.copyWith(
          color: colorScheme.onPrimaryContainer,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: colorScheme.outline, width: 0.8),
        ),
        side: BorderSide(color: colorScheme.outline, width: 0.8),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        indicatorColor: colorScheme.primaryContainer,
        elevation: 1,
        shadowColor: isDark ? Colors.black54 : Colors.black12,
        labelTextStyle: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return textTheme.labelSmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
            );
          }
          return textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.7),
          );
        }),
        iconTheme: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return IconThemeData(color: colorScheme.onPrimaryContainer, size: 24);
          }
          return IconThemeData(color: colorScheme.onSurface.withOpacity(0.7), size: 24);
        }),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
        linearTrackColor: colorScheme.surfaceContainerHighest,
        circularTrackColor: colorScheme.surfaceContainerHighest,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? const Color(0xFF242A3E) : const Color(0xFF202533),
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surfaceContainer,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: colorScheme.outline, width: 1),
        ),
        titleTextStyle: textTheme.headlineSmall?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurface.withOpacity(0.85),
        ),
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        titleTextStyle: textTheme.titleMedium,
        subtitleTextStyle: textTheme.bodySmall,
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outline.withOpacity(0.8),
        thickness: 1,
        space: 1,
      ),
    );
  }
}
