import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// A gradient-filled button matching SonicNote branding.
class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.gradient,
    this.borderRadius = 14,
    this.padding,
  });

  final VoidCallback onPressed;
  final Widget child;
  final Gradient? gradient;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Ink(
          decoration: BoxDecoration(
            gradient: gradient ?? AppColors.brandGradient,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Padding(
            padding: padding ??
                const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            child: DefaultTextStyle(
              style: const TextStyle(
                color: AppColors.pureWhite,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
