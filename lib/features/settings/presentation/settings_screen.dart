import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../state/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.nearWhite : AppColors.deepNavy;

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.settings)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ── Theme selector ───────────────────────────
          _SectionHeader(title: AppStrings.theme),
          const SizedBox(height: 8),
          _GlassTile(
            isDark: isDark,
            child: Column(
              children: [
                _ThemeOption(
                  label: AppStrings.themeLight,
                  icon: Icons.wb_sunny_rounded,
                  selected: themeMode == ThemeMode.light,
                  onTap: () => ref
                      .read(themeModeProvider.notifier)
                      .setTheme(ThemeMode.light),
                ),
                const Divider(height: 1),
                _ThemeOption(
                  label: AppStrings.themeDark,
                  icon: Icons.nightlight_round,
                  selected: themeMode == ThemeMode.dark,
                  onTap: () => ref
                      .read(themeModeProvider.notifier)
                      .setTheme(ThemeMode.dark),
                ),
                const Divider(height: 1),
                _ThemeOption(
                  label: AppStrings.themeSystem,
                  icon: Icons.settings_brightness_rounded,
                  selected: themeMode == ThemeMode.system,
                  onTap: () => ref
                      .read(themeModeProvider.notifier)
                      .setTheme(ThemeMode.system),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // ── About ────────────────────────────────────
          _SectionHeader(title: AppStrings.about),
          const SizedBox(height: 8),
          _GlassTile(
            isDark: isDark,
            child: Column(
              children: [
                ListTile(
                  leading: ShaderMask(
                    shaderCallback: (b) =>
                        AppColors.brandGradientHorizontal.createShader(b),
                    child: const Icon(Icons.info_outline_rounded,
                        color: Colors.white),
                  ),
                  title: Text(AppStrings.appName,
                      style: TextStyle(
                          fontWeight: FontWeight.w600, color: textColor)),
                  subtitle: Text('${AppStrings.version} ${AppStrings.appVersion}',
                      style: TextStyle(color: textColor.withValues(alpha: 0.5))),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.privacy_tip_outlined, color: textColor.withValues(alpha: 0.6)),
                  title: Text(AppStrings.privacyPolicy,
                      style: TextStyle(color: textColor)),
                  trailing:
                      Icon(Icons.chevron_right, color: textColor.withValues(alpha: 0.3)),
                  onTap: () => _showPrivacyPolicy(context, isDark),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),
          // Branding footer
          Center(
            child: ShaderMask(
              shaderCallback: (b) =>
                  AppColors.brandGradientHorizontal.createShader(b),
              child: const Text(
                'Made with ♥ — SonicNote',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.65,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF101530) : AppColors.nearWhite,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Privacy Policy',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.nearWhite : AppColors.deepNavy,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _privacyText,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: (isDark ? AppColors.nearWhite : AppColors.deepNavy)
                        .withValues(alpha: 0.7),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static const String _privacyText = '''
SonicNote Privacy Policy
Last updated: March 2026

SonicNote is an offline-only notes application. We are committed to protecting your privacy.

DATA COLLECTION
SonicNote does NOT collect, store, transmit, or share any personal data or information. All notes and settings are stored exclusively on your device using local storage (Hive database).

SPEECH RECOGNITION
The voice-to-text feature uses your device's built-in speech recognition service. No audio data is sent to our servers because we do not operate any servers. Audio processing depends on your device manufacturer's speech service and their respective privacy policies.

THIRD-PARTY SERVICES
SonicNote does not integrate with any third-party analytics, advertising, or tracking services. There are no ads and no tracking.

INTERNET ACCESS
SonicNote does not require internet access to function. The app works entirely offline.

DATA STORAGE
All your notes are stored locally on your device. If you uninstall the app, all data will be permanently deleted.

CHILDREN'S PRIVACY
SonicNote does not knowingly collect information from children under 13.

CHANGES
We may update this policy from time to time. Any changes will be reflected in the app update.

CONTACT
If you have questions about this privacy policy, you can reach us through the app's Play Store listing page.
''';
}

// ─── Helper widgets ────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.accentIndigo,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _GlassTile extends StatelessWidget {
  const _GlassTile({required this.isDark, required this.child});
  final bool isDark;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.pureWhite.withValues(alpha: 0.07)
                : AppColors.deepNavy.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark
                  ? AppColors.pureWhite.withValues(alpha: 0.12)
                  : AppColors.pureWhite.withValues(alpha: 0.3),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.nearWhite : AppColors.deepNavy;

    return ListTile(
      leading: Icon(icon,
          color: selected ? AppColors.accentIndigo : textColor.withValues(alpha: 0.4)),
      title:
          Text(label, style: TextStyle(color: textColor, fontWeight: FontWeight.w500)),
      trailing: selected
          ? const Icon(Icons.check_circle_rounded,
              color: AppColors.accentIndigo)
          : null,
      onTap: onTap,
    );
  }
}
