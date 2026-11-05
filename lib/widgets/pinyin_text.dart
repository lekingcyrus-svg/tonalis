import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/word.dart';

TextStyle zh(double size) =>
    GoogleFonts.notoSerifSc(fontSize: size, fontWeight: FontWeight.w600);

Color toneColor(int t) => const {
  1: Color(0xFFC0392B),
  2: Color(0xFF2E8B57),
  3: Color(0xFF2F6DB5),
  4: Color(0xFF8E44AD),
  5: Color(0xFF888888),
}[t]!;

class PinyinText extends StatelessWidget {
  final String p;
  final double size;
  const PinyinText(this.p, {this.size = 24, super.key});

  @override
  Widget build(BuildContext context) => Text.rich(
    TextSpan(
      children: [
        for (final s in p.split(' '))
          TextSpan(
            text: '$s ',
            style: TextStyle(
              color: toneColor(toneOf(s)),
              fontSize: size,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    ),
    textAlign: TextAlign.center,
  );
}
