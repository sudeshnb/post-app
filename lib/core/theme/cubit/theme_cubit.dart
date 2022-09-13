import '../app_theme.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class ThemeCubit extends HydratedCubit<bool> {
  ThemeCubit() : super(true);

  void toggleTheme({required bool value}) {
    emit(value);
  }

  void updateAppTheme() {
    final Brightness currentBrightness = AppTheme.currentSystemBrightness;
    currentBrightness == Brightness.light
        ? _setTheme(ThemeMode.light)
        : _setTheme(ThemeMode.dark);
  }

  void _setTheme(ThemeMode themeMode) {
    AppTheme.setStatusBarAndNavigationBarColors(themeMode);
  }

  @override
  bool? fromJson(Map<String, dynamic> json) {
    return json["isDark"];
  }

  @override
  Map<String, dynamic>? toJson(bool state) {
    return {"isDark": state};
  }
}
