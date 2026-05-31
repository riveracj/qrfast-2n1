import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.trueBlack,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.neonEmerald,
        secondary: AppColors.electricBlue,
        surface: AppColors.surfaceDark,
        error: AppColors.errorRed,
      ),
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.dark().textTheme.copyWith(
              headlineLarge: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              bodyLarge: const TextStyle(color: AppColors.textPrimary),
              bodyMedium: const TextStyle(color: AppColors.textSecondary),
            ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.trueBlack,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: const CardThemeData(
        color: AppColors.surfaceCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.neonEmerald,
        foregroundColor: AppColors.trueBlack,
        elevation: 4,
      ),
      iconTheme: const IconThemeData(color: AppColors.textPrimary),
      dividerTheme: const DividerThemeData(
        color: AppColors.slateGray,
        thickness: 0.5,
      ),
    );
  }
}
