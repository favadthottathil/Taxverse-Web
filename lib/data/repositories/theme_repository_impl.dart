import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/repositories/theme_repository.dart';

class ThemeRepositoryImpl implements ThemeRepository {
  static const String _themeKey = 'isDarkMode';
  final SharedPreferences sharedPreferences;

  ThemeRepositoryImpl({required this.sharedPreferences});

  @override
  Future<bool> getIsDarkMode() async {
    return sharedPreferences.getBool(_themeKey) ?? false;
  }

  @override
  Future<void> saveIsDarkMode(bool isDarkMode) async {
    await sharedPreferences.setBool(_themeKey, isDarkMode);
  }
}
