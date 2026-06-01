import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Google Sign-In is not included in the iOS release surface', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    final iosInfoPlist = File('ios/Runner/Info.plist').readAsStringSync();
    final authService =
        File('lib/services/supabase_auth_service.dart').readAsStringSync();

    expect(pubspec, isNot(contains('google_sign_in')));
    expect(iosInfoPlist, isNot(contains('GIDClientID')));
    expect(iosInfoPlist, isNot(contains('googleusercontent')));
    expect(authService, isNot(contains('GoogleSignIn')));
    expect(authService, isNot(contains('signInWithGoogle')));
  });
}
