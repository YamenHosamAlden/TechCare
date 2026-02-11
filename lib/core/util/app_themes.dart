import 'package:flutter/material.dart';
import 'package:tech_care_app/core/util/app_colors.dart';
import 'package:tech_care_app/core/util/app_constants.dart';

enum AppTheme {
  lightTheme,
}

final Map<AppTheme, ThemeData> appThemeData = {
  AppTheme.lightTheme: ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(primary: AppColors.martiniqueColor),
    primaryColor: AppColors.eucalyptusColor,
    scaffoldBackgroundColor: AppColors.alabasterColor,
    primaryColorLight: AppColors.martiniqueColor,
    appBarTheme: const AppBarTheme(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(10))),
      backgroundColor: AppColors.eucalyptusColor,
      centerTitle: true,
      elevation: 10,
      titleTextStyle: TextStyle(
          color: AppColors.whiteColor,
          fontSize: 18,
          fontWeight: FontWeight.w600),
      iconTheme: IconThemeData(color: AppColors.whiteColor),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.altoColor,
    ),
    inputDecorationTheme: InputDecorationTheme(
      isDense: true,
      fillColor: AppColors.whiteColor,
      filled: true,
      contentPadding: const EdgeInsets.all(10),
      prefixIconColor: Colors.grey,
      hintStyle: const TextStyle(
        fontSize: 14,
        height: 1,
        color: Colors.grey,
        fontWeight: FontWeight.w400,
      ),
      border: OutlineInputBorder(
        gapPadding: 0,
        borderRadius: BorderRadius.circular(5),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.whiteColor),
        gapPadding: 0,
        borderRadius: BorderRadius.circular(5),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.altoColor),
        gapPadding: 0,
        borderRadius: BorderRadius.circular(5),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.martiniqueColor),
        gapPadding: 0,
        borderRadius: BorderRadius.circular(5),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 14, color: AppColors.whiteColor),
        foregroundColor: AppColors.whiteColor,
        backgroundColor: AppColors.martiniqueColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    ),
    listTileTheme: ListTileThemeData(
      dense: true,
    ),
    expansionTileTheme: ExpansionTileThemeData(
      backgroundColor: Colors.white,
      expansionAnimationStyle: AnimationStyle(
          curve: Curves.easeInOut, reverseCurve: Curves.easeInOut),
      childrenPadding: EdgeInsets.all(AppConstants.mediumPadding),
    ),
  ),
};
