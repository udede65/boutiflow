import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'app.dart';
import 'core/services/interstitial_ad_service.dart';
import 'services/adapty_service.dart';
import 'services/cloud_sync_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase for cloud sync
  await CloudSyncService.initialize();

  // Initialize AdMob
  await MobileAds.instance.initialize();
  InterstitialAdService.instance.loadAd(); // Pre-load interstitial

  try {
    await AdaptyService.initialize();
  } catch (e) {
    debugPrint('[Adapty] initialize failed: $e');
  }

  runApp(
    const ProviderScope(
      child: BoutiFlowApp(),
    ),
  );
}
