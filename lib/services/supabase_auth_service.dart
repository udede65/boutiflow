import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SupabaseAuthService {
  static const String _supabaseUrl = 'https://poggjnbcysagdumhszex.supabase.co';
  static const String _supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBvZ2dqbmJjeXNhZ2R1bWhzemV4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzMyNTQ4MDEsImV4cCI6MjA4ODgzMDgwMX0.qH0Z0PWCIVI7nEyNjbX9XiAT6PVj47rW9_zH5zl8us4';
  
  static const String _userIdKey = 'supabase_user_id';
  static const String _userEmailKey = 'supabase_user_email';
  static const String _isLoggedInKey = 'is_logged_in';
  
  static bool _initialized = false;

  SupabaseClient get client => Supabase.instance.client;

  /// Initialize Supabase (call once at app startup)
  static Future<void> initialize() async {
    if (_initialized) return;
    try {
      await Supabase.initialize(
        url: _supabaseUrl,
        anonKey: _supabaseAnonKey,
      );
      _initialized = true;
      debugPrint('Supabase Auth initialized successfully');
    } catch (e) {
      debugPrint('Supabase Auth init error: $e');
    }
  }

  /// Check if user has an existing session
  Future<bool> hasActiveSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;
      
      if (!isLoggedIn) return false;
      
      // Check Supabase session
      final session = client.auth.currentSession;
      if (session != null) {
        return true;
      }
      
      // Session expired, clear local storage
      await _clearSession();
      return false;
    } catch (e) {
      debugPrint('Session check error: $e');
      return false;
    }
  }

  /// Get current user info
  User? get currentUser => client.auth.currentUser;

  /// Get stored user email
  Future<String?> getStoredUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userEmailKey);
  }

  /// Sign in with Google
  Future<AuthResult> signInWithGoogle() async {
    try {
      // Web client ID for Android - from Google Cloud Console
      const webClientId = '727352258131-o3mghmf120cpiqaqq9609g21nmmk7e6u.apps.googleusercontent.com';
      
      final GoogleSignIn googleSignIn = GoogleSignIn(
        serverClientId: webClientId,
      );
      
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        return AuthResult(success: false, error: 'Giriş iptal edildi');
      }

      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null || idToken == null) {
        return AuthResult(success: false, error: 'Google token alınamadı');
      }

      // Sign in with Supabase using Google tokens
      final response = await client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      if (response.user != null) {
        await _saveSession(response.user!);
        return AuthResult(
          success: true,
          userId: response.user!.id,
          email: response.user!.email,
        );
      }

      return AuthResult(success: false, error: 'Supabase giriş başarısız');
    } catch (e) {
      debugPrint('Google sign in error: $e');
      return AuthResult(success: false, error: e.toString());
    }
  }

  /// Sign in with Apple
  Future<AuthResult> signInWithApple() async {
    try {
      // Generate nonce for security
      final rawNonce = _generateNonce();
      final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: hashedNonce,
      );

      final idToken = credential.identityToken;
      if (idToken == null) {
        return AuthResult(success: false, error: 'Apple token alınamadı');
      }

      // Sign in with Supabase using Apple token
      final response = await client.auth.signInWithIdToken(
        provider: OAuthProvider.apple,
        idToken: idToken,
        nonce: rawNonce,
      );

      if (response.user != null) {
        await _saveSession(response.user!);
        return AuthResult(
          success: true,
          userId: response.user!.id,
          email: response.user!.email ?? credential.email,
        );
      }

      return AuthResult(success: false, error: 'Supabase giriş başarısız');
    } catch (e) {
      debugPrint('Apple sign in error: $e');
      return AuthResult(success: false, error: e.toString());
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await client.auth.signOut();
      await _clearSession();
      
      // Also sign out from Google
      try {
        await GoogleSignIn().signOut();
      } catch (_) {}
    } catch (e) {
      debugPrint('Sign out error: $e');
    }
  }

  /// Save session to local storage
  Future<void> _saveSession(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, user.id);
    await prefs.setString(_userEmailKey, user.email ?? '');
    await prefs.setBool(_isLoggedInKey, true);
  }

  /// Clear session from local storage
  Future<void> _clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdKey);
    await prefs.remove(_userEmailKey);
    await prefs.setBool(_isLoggedInKey, false);
  }

  /// Generate random nonce for Apple Sign In
  String _generateNonce([int length = 32]) {
    const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
  }
}

class AuthResult {
  final bool success;
  final String? userId;
  final String? email;
  final String? error;

  AuthResult({
    required this.success,
    this.userId,
    this.email,
    this.error,
  });
}
