import 'package:flutter_test/flutter_test.dart';
import 'package:taxverse_portfolio/core/validators.dart';

void main() {
  group('Validators.required', () {
    test('rejects null, empty and whitespace-only', () {
      expect(Validators.required(null, 'x'), 'x');
      expect(Validators.required('', 'x'), 'x');
      expect(Validators.required('   ', 'x'), 'x');
    });

    test('accepts text', () => expect(Validators.required('a', 'x'), isNull));
  });

  group('Validators.email', () {
    String? check(String? v) => Validators.email(v, emptyMessage: 'empty');

    test('reports the empty message for blank input', () {
      expect(check(null), 'empty');
      expect(check('  '), 'empty');
    });

    test('accepts common addresses', () {
      expect(check('info@taxverseconsulting.com'), isNull);
      expect(check(' a.b+c@sub.example.co.in '), isNull);
    });

    test('rejects malformed addresses', () {
      for (final bad in ['plain', 'a@b', 'a@b.c', '@x.com', 'a b@x.com', 'a@@x.com']) {
        expect(check(bad), isNotNull, reason: bad);
      }
    });
  });

  group('Validators.phone', () {
    String? check(String? v) => Validators.phone(v, emptyMessage: 'empty');

    test('reports the empty message for blank input', () {
      expect(check(''), 'empty');
    });

    test('accepts common formats', () {
      expect(check('+91 85900 80509'), isNull);
      expect(check('(0483) 276-1234'), isNull);
      expect(check('8590080509'), isNull);
    });

    test('rejects letters and out-of-range lengths', () {
      expect(check('abc12345678'), isNotNull);
      expect(check('123456'), isNotNull);
      expect(check('1234567890123456'), isNotNull);
    });
  });
}
