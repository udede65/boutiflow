import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/neo_brutalist_theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  static const _totalSlides = 4;
  int _currentPage = 0;

  void _nextPage() {
    if (_currentPage < _totalSlides - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_onboarding', true);

    if (!mounted) return;
    context.go('/paywall');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final slides = [
      _OnboardingSlide(
        icon: Icons.hotel_rounded,
        color: NeoBrutalistTheme.blue,
        title: l10n.t('onboardingSlideHotelTitle'),
        subtitle: l10n.t('onboardingSlideHotelSubtitle'),
      ),
      _OnboardingSlide(
        icon: Icons.calendar_month_rounded,
        color: NeoBrutalistTheme.orange,
        title: l10n.t('onboardingSlideBookingsTitle'),
        subtitle: l10n.t('onboardingSlideBookingsSubtitle'),
      ),
      _OnboardingSlide(
        icon: Icons.people_rounded,
        color: NeoBrutalistTheme.purple,
        title: l10n.t('onboardingSlideGuestsTitle'),
        subtitle: l10n.t('onboardingSlideGuestsSubtitle'),
      ),
      _OnboardingSlide(
        icon: Icons.analytics_rounded,
        color: NeoBrutalistTheme.green,
        title: l10n.t('onboardingSlideReportsTitle'),
        subtitle: l10n.t('onboardingSlideReportsSubtitle'),
      ),
    ];

    return Scaffold(
      backgroundColor: NeoBrutalistTheme.cream,
      body: SafeArea(
        child: Column(
          children: [
            // Skip Button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: GestureDetector(
                  onTap: _completeOnboarding,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: NeoBrutalistTheme.white,
                      borderRadius: BorderRadius.circular(8),
                      border:
                          Border.all(color: NeoBrutalistTheme.black, width: 2),
                    ),
                    child: Text(l10n.upper('onboardingSkip'),
                        style: NeoBrutalistTheme.labelLarge),
                  ),
                ),
              ),
            ),

            // Pages
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: slides.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) {
                  final slide = slides[index];
                  return Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 140,
                          height: 140,
                          decoration:
                              NeoBrutalistTheme.cardDecoration(slide.color),
                          child: Icon(
                            slide.icon,
                            size: 70,
                            color: NeoBrutalistTheme.white,
                          ),
                        ),
                        const SizedBox(height: 48),
                        Text(
                          slide.title,
                          style: NeoBrutalistTheme.headlineLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          slide.subtitle,
                          style: NeoBrutalistTheme.bodyLarge.copyWith(
                            color: NeoBrutalistTheme.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(slides.length, (index) {
                return Container(
                  width: _currentPage == index ? 32 : 12,
                  height: 12,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? slides[_currentPage].color
                        : NeoBrutalistTheme.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(6),
                    border:
                        Border.all(color: NeoBrutalistTheme.black, width: 2),
                  ),
                );
              }),
            ),
            const SizedBox(height: 32),

            // Next Button
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                child: NeoButton(
                  text: _currentPage == slides.length - 1
                      ? l10n.upper('onboardingStart')
                      : l10n.upper('onboardingNext'),
                  onPressed: _nextPage,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingSlide {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;

  const _OnboardingSlide({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
  });
}
