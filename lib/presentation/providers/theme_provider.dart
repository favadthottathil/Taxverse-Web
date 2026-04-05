import 'package:flutter/material.dart';
import '../../domain/repositories/theme_repository.dart';

class ThemeProvider extends ChangeNotifier {
  final ThemeRepository themeRepository;
  ThemeMode _themeMode = ThemeMode.light;

  ThemeProvider({required this.themeRepository}) {
    _loadTheme();
  }

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  Future<void> _loadTheme() async {
    final bool isDark = await themeRepository.getIsDarkMode();
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _themeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    await themeRepository.saveIsDarkMode(isDarkMode);
    notifyListeners();
  }
}
