import 'package:flutter_test/flutter_test.dart';
import 'package:roompilot_flutter/core/services/interstitial_ad_service.dart';
import 'package:roompilot_flutter/core/widgets/banner_ad_widget.dart';

void main() {
  test('iOS release ad units use production identifiers', () {
    expect(
      interstitialAdUnitIdFor(isAndroid: false, useTestAds: false),
      'ca-app-pub-9886669167239411/9858881240',
    );
    expect(
      bannerAdUnitIdFor(isAndroid: false, useTestAds: false),
      'ca-app-pub-9886669167239411/4156930174',
    );
  });

  test('debug ad units keep Google test identifiers', () {
    expect(
      interstitialAdUnitIdFor(isAndroid: false, useTestAds: true),
      'ca-app-pub-3940256099942544/4411468910',
    );
    expect(
      bannerAdUnitIdFor(isAndroid: false, useTestAds: true),
      'ca-app-pub-3940256099942544/2934735716',
    );
  });
}
