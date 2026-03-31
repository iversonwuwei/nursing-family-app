import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF55F2D8);
  static const primarySoft = Color(0xFF12343A);
  static const beige = Color(0xFF182433);
  static const lightBlue = Color(0xFF112B44);
  static const coral = Color(0xFFFF8F70);
  static const danger = Color(0xFFFF6B7A);
  static const background = Color(0xFF061018);
  static const backgroundSecondary = Color(0xFF0C1825);
  static const card = Color(0xFF0E1A27);
  static const cardElevated = Color(0xFF152538);
  static const textPrimary = Color(0xFFF5FBFF);
  static const textSecondary = Color(0xFF8CA3B9);
  static const border = Color(0xFF1E3A51);
  static const warning = Color(0xFFFFC857);
  static const info = Color(0xFF59B8FF);
  static const accent = Color(0xFFA7FF7A);
  static const glow = Color(0x3349E7FF);
}

class AppGradients {
  static const shell = LinearGradient(
    colors: [AppColors.background, AppColors.backgroundSecondary],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const hero = LinearGradient(
    colors: [Color(0xFF163750), Color(0xFF0A1826)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const card = LinearGradient(
    colors: [AppColors.cardElevated, AppColors.card],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const accent = LinearGradient(
    colors: [AppColors.primary, AppColors.info],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}

class AppTheme {
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
          brightness: Brightness.dark,
        ).copyWith(
      primary: AppColors.primary,
      onPrimary: AppColors.background,
      secondary: AppColors.info,
      onSecondary: AppColors.background,
      error: AppColors.danger,
          onError: Colors.white,
      surface: AppColors.card,
          onSurface: AppColors.textPrimary,
          outline: AppColors.border,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: 'PingFang SC',
      cardColor: AppColors.card,
      dividerColor: AppColors.border,
      iconTheme: const IconThemeData(color: AppColors.textPrimary),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.6,
          color: AppColors.textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.4,
          color: AppColors.textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
          color: AppColors.textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          height: 1.5,
          color: AppColors.textPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          height: 1.5,
          color: AppColors.textSecondary,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.background,
          minimumSize: const Size(0, 48),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, 48),
          side: const BorderSide(color: AppColors.border),
          foregroundColor: AppColors.textPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.primarySoft,
        selectedColor: AppColors.primarySoft,
        disabledColor: AppColors.cardElevated,
        labelStyle: const TextStyle(color: AppColors.textPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        side: const BorderSide(color: AppColors.border),
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: AppColors.textPrimary,
        textColor: AppColors.textPrimary,
      ),
    );
  }
}
