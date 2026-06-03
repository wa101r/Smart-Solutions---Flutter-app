import 'package:flutter/material.dart';

/// Design tokens (Enterprise SaaS style) — sourced from the UI UX Pro Max
/// design system. Three conceptual layers: primitive values -> semantic roles
/// -> used by ThemeData and widgets. Keeping them here means one place to
/// re-theme the whole app.
class AppColors {
  // Brand / primitives
  static const indigo = Color(0xFF4F46E5); // primary
  static const violet = Color(0xFF7C3AED); // secondary
  static const success = Color(0xFF10B981);
  static const danger = Color(0xFFDC2626);
  static const warning = Color(0xFFF59E0B);

  // Light surfaces & text
  static const bg = Color(0xFFF8FAFC);
  static const surface = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFF0F172A);
  static const textMuted = Color(0xFF64748B);
  static const border = Color(0xFFE2E8F0);

  // Dark surfaces & text
  static const bgDark = Color(0xFF0B1120);
  static const surfaceDark = Color(0xFF111827);
  static const textPrimaryDark = Color(0xFFE2E8F0);
  static const textMutedDark = Color(0xFF94A3B8);
  static const borderDark = Color(0xFF1F2937);

  /// Primary CTA gradient (Indigo -> Violet).
  static const brandGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [indigo, violet],
  );
}

/// Spacing scale (4-pt based).
class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
}

/// Corner radii.
class AppRadius {
  static const input = 8.0;
  static const card = 16.0;
  static const pill = 999.0;
}

/// Soft, brand-tinted shadows (not flat grey).
class AppShadows {
  static List<BoxShadow> card = [
    BoxShadow(
      color: AppColors.indigo.withValues(alpha: 0.08),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];
}
