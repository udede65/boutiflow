import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io' show Platform;

/// Manages interstitial (full-screen) ads.
/// Call [loadAd] early, then [showAd] after a successful save action.
class InterstitialAdService {
  InterstitialAdService._();
  static final instance = InterstitialAdService._();

  InterstitialAd? _interstitialAd;
  bool _isLoaded = false;

  // Set this to false ONLY when you are publishing the app to the App Store!
  // App Store'a göndermeden önce bunu false yap.
  static const bool _useTestAds = true;

  String get _adUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/1033173712'; // Android test
    }
    return _useTestAds
        ? 'ca-app-pub-3940256099942544/4411468910' // iOS test
        : 'ca-app-pub-9886669167239411/9858881240'; // iOS Real
  }

  /// Pre-load an interstitial ad so it's ready when needed.
  void loadAd() {
    InterstitialAd.load(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('[AdMob] Interstitial loaded.');
          _interstitialAd = ad;
          _isLoaded = true;

          // Auto-reload after dismissal
          _interstitialAd!.fullScreenContentCallback =
              FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _interstitialAd = null;
              _isLoaded = false;
              loadAd(); // Pre-load the next one
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              debugPrint('[AdMob] Interstitial failed to show: $error');
              ad.dispose();
              _interstitialAd = null;
              _isLoaded = false;
              loadAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint('[AdMob] Interstitial failed to load: $error');
          _isLoaded = false;
        },
      ),
    );
  }

  /// Show the interstitial ad if one is loaded.
  /// Returns true if an ad was shown, false otherwise.
  bool showAd() {
    if (_isLoaded && _interstitialAd != null) {
      _interstitialAd!.show();
      return true;
    }
    // If not loaded yet, silently skip — don't block the user
    debugPrint('[AdMob] Interstitial not ready, skipping.');
    return false;
  }
}
