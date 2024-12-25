import 'package:flutter/material.dart';
import 'package:todo_app/Style/AppColors.dart';

class AppTheme {
  static ThemeData LightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        primary: AppColors.PrimaryLight
    ),
    useMaterial3: true,
  );
}
