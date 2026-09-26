/// Shared form validators and input limits.
///
/// Each validator returns an error message, or null when the value is valid.
class Validators {
  const Validators._();

  /// Keeps the composed WhatsApp URL comfortably under browser/URL limits
  /// (each character can expand to several bytes once percent-encoded).
  static const int maxNameLength = 100;
  static const int maxEmailLength = 254;
  static const int maxPhoneLength = 20;
  static const int maxShortTextLength = 100;
  static const int maxMessageLength = 600;

  static final RegExp _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]{2,}$');
  static final RegExp _phoneChars = RegExp(r'^[0-9+\-\s()]+$');

  static String? required(String? value, String message) =>
      value == null || value.trim().isEmpty ? message : null;

  static String? email(String? value, {required String emptyMessage}) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return emptyMessage;
    return _emailPattern.hasMatch(trimmed)
        ? null
        : 'Please enter a valid email address';
  }

  /// Accepts digits with an optional leading '+', spaces, dashes and
  /// parentheses, and requires 7–15 digits (the E.164 range).
  static String? phone(String? value, {required String emptyMessage}) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return emptyMessage;
    final digits = trimmed.replaceAll(RegExp(r'\D'), '');
    final valid =
        _phoneChars.hasMatch(trimmed) &&
        digits.length >= 7 &&
        digits.length <= 15;
    return valid ? null : 'Please enter a valid phone number';
  }
}
