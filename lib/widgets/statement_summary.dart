import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../design_system.dart';

class StatementSummary extends StatelessWidget {
  final String month;
  final String year;
  final int nextStatementDays;

  const StatementSummary({
    super.key,
    this.month = 'march',
    this.year = '24',
    this.nextStatementDays = 23,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Statement summary box
        Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: VerifiTheme.obsidianGlass.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: VerifiTheme.glassBorder, width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'statement summary',
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'for the month $month \'$year',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: VerifiTheme.ghostGrey,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'View now',
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Next statement info
      ],
    );
  }
}
