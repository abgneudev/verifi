import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../design_system.dart';

class InfoTiles extends StatelessWidget {
  final double recentSpends;
  final int cardOffers;

  const InfoTiles({
    super.key,
    this.recentSpends = 3082.82,
    this.cardOffers = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Settings tile
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: VerifiTheme.obsidianGlass.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: VerifiTheme.glassBorder, width: 1),
          ),
          child: const Icon(Icons.settings, color: Colors.white, size: 32),
        ),
        const SizedBox(width: 4),
        // Recent spends tile
        Expanded(
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              color: VerifiTheme.obsidianGlass.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: VerifiTheme.glassBorder, width: 1),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '\$${recentSpends.toStringAsFixed(2)}',
                      style: GoogleFonts.manrope(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      'recent spends',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        color: VerifiTheme.ghostGrey,
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.arrow_forward,
                  color: VerifiTheme.ghostGrey,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 4),
        // Card offers tile
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: VerifiTheme.obsidianGlass.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: VerifiTheme.glassBorder, width: 1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '⚡${cardOffers.toString()}',
                style: GoogleFonts.manrope(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'offers',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  color: VerifiTheme.ghostGrey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
