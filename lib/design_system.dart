import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Glass-Pop Design System for Verifi
/// Combines Stripe's clean aesthetics with CRED's NeoPOP vibrancy
class VerifiTheme {
  // ============================================================
  // COLOR PALETTE (Dark Mode First)
  // ============================================================

  // Backgrounds (The Void)
  static const Color voidBlack = Color(0xFF0E1117);
  static const Color obsidianGlass = Color(0xFF161B22);
  static const Color voidBlackLight = Color(0xFF1A1F2C);

  // Primary Accents (The "Pop")
  static const Color hyperViolet = Color(0xFF635BFF); // AI / Active State
  static const Color neonMint = Color(0xFF00D68F); // Success / Verified
  static const Color signalOrange = Color(0xFFFF7043); // Warning / Pending
  static const Color electricPink = Color(0xFFFF3366); // Action / Scan

  // Text & Borders
  static const Color starlightWhite = Color(0xFFF6F9FC); // Primary Text
  static const Color ghostGrey = Color(0xFF8898AA); // Secondary Text
  static const Color glassBorder = Color(0x19FFFFFF); // White with 10% opacity

  // Derived colors for const usage
  static const Color cardBackground = Color(
    0x99161B22,
  ); // obsidianGlass with 0.6 alpha
  static const Color labelSmallColor = Color(
    0xCC8898AA,
  ); // ghostGrey with 0.8 alpha

  // ============================================================
  // THEME DATA
  // ============================================================

  static ThemeData get themeData {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: voidBlack,
      primaryColor: hyperViolet,
      colorScheme: const ColorScheme.dark(
        primary: hyperViolet,
        secondary: electricPink,
        surface: obsidianGlass,
        error: signalOrange,
      ),

      // Typography (Stripe-ish)
      textTheme: TextTheme(
        displayLarge: GoogleFonts.manrope(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: starlightWhite,
          letterSpacing: -1.0,
        ),
        displayMedium: GoogleFonts.manrope(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: starlightWhite,
          letterSpacing: -0.5,
        ),
        headlineMedium: GoogleFonts.manrope(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: starlightWhite,
        ),
        headlineSmall: GoogleFonts.manrope(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: starlightWhite,
        ),
        titleLarge: GoogleFonts.manrope(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: starlightWhite,
        ),
        bodyLarge: GoogleFonts.inter(fontSize: 16, color: starlightWhite),
        bodyMedium: GoogleFonts.inter(fontSize: 14, color: ghostGrey),
        bodySmall: GoogleFonts.inter(fontSize: 12, color: ghostGrey),
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: starlightWhite,
          letterSpacing: 0.5,
        ),
        labelSmall: GoogleFonts.jetBrainsMono(
          fontSize: 12,
          color: labelSmallColor,
        ),
      ),

      // Card Style (Glass Base)
      cardTheme: CardThemeData(
        color: cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: glassBorder, width: 1),
        ),
        elevation: 0,
      ),

      // Button Style (CRED Neo-Pop)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: hyperViolet,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: hyperViolet.withValues(alpha: 0.5),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: GoogleFonts.manrope(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Text Field Style (Glass Input)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: obsidianGlass.withValues(alpha: 0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: glassBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: glassBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: hyperViolet, width: 2),
        ),
        hintStyle: GoogleFonts.inter(color: ghostGrey),
        labelStyle: GoogleFonts.inter(color: ghostGrey),
      ),

      // AppBar Style
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.manrope(
          fontSize: 20,
          fontWeight: FontWeight.w900,
          letterSpacing: 2,
          color: starlightWhite,
        ),
        iconTheme: const IconThemeData(color: starlightWhite),
      ),
    );
  }
}

// ============================================================
// REUSABLE GLASS CARD WIDGET
// ============================================================

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? color;
  final double? width;
  final double? height;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin ?? const EdgeInsets.all(20),
      padding: padding ?? const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color?.withValues(alpha: 0.05) ??
                Colors.white.withValues(alpha: 0.05),
            color?.withValues(alpha: 0.01) ??
                Colors.white.withValues(alpha: 0.01),
          ],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: VerifiTheme.glassBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 30,
            spreadRadius: -5,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: child,
        ),
      ),
    );
  }
}

// ============================================================
// NEO-POP BUTTON (CRED-style with haptic feedback)
// ============================================================

class NeoPopButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final IconData? icon;
  final Color? color;
  final Color? foregroundColor;
  final bool isLoading;

  const NeoPopButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.icon,
    this.color,
    this.foregroundColor,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final buttonColor = color ?? VerifiTheme.hyperViolet;
    final textColor = foregroundColor ?? Colors.white;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: buttonColor.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed == null
            ? null
            : () {
                HapticFeedback.mediumImpact();
                onPressed!();
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: textColor,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(textColor),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 16, color: textColor),
                    const SizedBox(width: 8),
                  ],
                  Flexible(
                    child: Text(
                      text.toUpperCase(),
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: textColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// ============================================================
// STATUS BADGE (For AI Consensus, Contract Status, etc.)
// ============================================================

class StatusBadge extends StatelessWidget {
  final String text;
  final Color color;
  final IconData? icon;

  const StatusBadge({
    super.key,
    required this.text,
    required this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
          ],
          Text(
            text.toUpperCase(),
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// AMOUNT DISPLAY (Large financial numbers)
// ============================================================

class AmountDisplay extends StatelessWidget {
  final double amount;
  final String currency;
  final Color? color;

  const AmountDisplay({
    super.key,
    required this.amount,
    this.currency = 'USD',
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'AMOUNT',
          style: GoogleFonts.jetBrainsMono(
            fontSize: 12,
            color: VerifiTheme.ghostGrey,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: GoogleFonts.manrope(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: color ?? VerifiTheme.starlightWhite,
            letterSpacing: -1.5,
          ),
        ),
        Text(
          currency,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: VerifiTheme.ghostGrey,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}
