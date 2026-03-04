import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../notes/presentation/screens/home_screen.dart';

/// Animated splash screen with gradient glow and brand logo.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 2200));
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) => const HomeScreen(),
        transitionsBuilder: (_, anim, __, child) {
          return FadeTransition(opacity: anim, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0A194C),
              Color(0xFF101840),
              Color(0xFF1A1055),
            ],
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // ── Background glow ──
            Positioned(
              top: MediaQuery.of(context).size.height * 0.3,
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.accentIndigo.withValues(alpha: 0.35),
                      AppColors.neonPurple.withValues(alpha: 0.15),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            )
                .animate()
                .fadeIn(duration: 800.ms)
                .scaleXY(begin: 0.7, end: 1.1, duration: 1800.ms, curve: Curves.easeOut),

            // ── Logo icon + text ──
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Circular icon container
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.brandGradient,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accentIndigo.withValues(alpha: 0.5),
                        blurRadius: 30,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.music_note_rounded,
                    size: 48,
                    color: AppColors.pureWhite,
                  ),
                )
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .scaleXY(begin: 0.5, end: 1, duration: 700.ms, curve: Curves.elasticOut),

                const SizedBox(height: 28),

                // App name
                ShaderMask(
                  shaderCallback: (bounds) =>
                      AppColors.brandGradientHorizontal.createShader(bounds),
                  child: const Text(
                    AppStrings.appName,
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(duration: 500.ms, delay: 300.ms)
                    .slideY(begin: 0.2, end: 0, duration: 500.ms, delay: 300.ms),

                const SizedBox(height: 10),

                // Tagline
                Text(
                  'Speak it. Save it.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.nearWhite.withValues(alpha: 0.5),
                    letterSpacing: 1.5,
                  ),
                )
                    .animate()
                    .fadeIn(duration: 500.ms, delay: 600.ms),
              ],
            ),

            // ── Bottom loading indicator ──
            Positioned(
              bottom: 60,
              child: SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation(
                    AppColors.accentIndigo.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ).animate().fadeIn(duration: 400.ms, delay: 800.ms),
          ],
        ),
      ),
    );
  }
}
