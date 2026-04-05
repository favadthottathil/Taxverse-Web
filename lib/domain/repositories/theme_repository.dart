abstract class ThemeRepository {
  Future<bool> getIsDarkMode();
  Future<void> saveIsDarkMode(bool isDarkMode);
}
