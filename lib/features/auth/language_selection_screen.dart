import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/localization/language_preferences.dart';
import '../../state/app_state.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/neo_brutalist_theme.dart';

class LanguageSelectionScreen extends ConsumerWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: NeoBrutalistTheme.cream,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints:
                  BoxConstraints(minHeight: constraints.maxHeight - 48),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Container(
                    width: 100,
                    height: 100,
                    decoration: NeoBrutalistTheme.cardDecoration(
                        NeoBrutalistTheme.blue),
                    child: const Icon(
                      Icons.language_rounded,
                      size: 50,
                      color: NeoBrutalistTheme.white,
                    ),
                  ),
                  const SizedBox(height: 32),

                  Text(
                    l10n.upper('chooseLanguageTitle'),
                    style: NeoBrutalistTheme.headlineLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.t('chooseLanguageSubtitle'),
                    style: NeoBrutalistTheme.bodyLarge.copyWith(
                      color: NeoBrutalistTheme.grey,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Language Buttons
                  _LanguageButton(
                    code: 'tr',
                    label: AppLocalizations.languageLabel('tr'),
                    emoji: '🇹🇷',
                    color: NeoBrutalistTheme.red,
                    onPressed: () => _selectLanguage(context, ref, 'tr'),
                  ),
                  const SizedBox(height: 12),
                  _LanguageButton(
                    code: 'en',
                    label: AppLocalizations.languageLabel('en'),
                    emoji: '🇬🇧',
                    color: NeoBrutalistTheme.blue,
                    onPressed: () => _selectLanguage(context, ref, 'en'),
                  ),
                  const SizedBox(height: 12),
                  _LanguageButton(
                    code: 'de',
                    label: AppLocalizations.languageLabel('de'),
                    emoji: '🇩🇪',
                    color: NeoBrutalistTheme.yellow,
                    onPressed: () => _selectLanguage(context, ref, 'de'),
                  ),
                  const SizedBox(height: 12),
                  _LanguageButton(
                    code: 'ru',
                    label: AppLocalizations.languageLabel('ru'),
                    emoji: '🇷🇺',
                    color: NeoBrutalistTheme.purple,
                    onPressed: () => _selectLanguage(context, ref, 'ru'),
                  ),
                  const SizedBox(height: 12),
                  _LanguageButton(
                    code: 'fr',
                    label: AppLocalizations.languageLabel('fr'),
                    emoji: '🇫🇷',
                    color: NeoBrutalistTheme.green,
                    onPressed: () => _selectLanguage(context, ref, 'fr'),
                  ),
                  const SizedBox(height: 12),
                  _LanguageButton(
                    code: 'es',
                    label: AppLocalizations.languageLabel('es'),
                    emoji: '🇪🇸',
                    color: NeoBrutalistTheme.orange,
                    onPressed: () => _selectLanguage(context, ref, 'es'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectLanguage(
    BuildContext context,
    WidgetRef ref,
    String code,
  ) async {
    ref.read(appStateProvider.notifier).setLanguage(code);
    await LanguagePreferences.saveSelectedLanguage(code);

    final appState = ref.read(appStateProvider);
    if (!context.mounted) return;

    if (appState.isAuthenticated) {
      context.go('/dashboard');
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final hasSeenOnboarding = prefs.getBool('has_seen_onboarding') ?? false;
    if (!context.mounted) return;
    context.go(hasSeenOnboarding ? '/login' : '/onboarding-intro');
  }
}

class _LanguageButton extends StatelessWidget {
  const _LanguageButton({
    required this.code,
    required this.label,
    required this.emoji,
    required this.color,
    required this.onPressed,
  });

  final String code;
  final String label;
  final String emoji;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: NeoBrutalistTheme.cardDecoration(NeoBrutalistTheme.white),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: NeoBrutalistTheme.black, width: 2),
              ),
              child: Center(
                child: Text(
                  emoji,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: NeoBrutalistTheme.titleLarge,
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_rounded,
              color: NeoBrutalistTheme.black,
            ),
          ],
        ),
      ),
    );
  }
}
