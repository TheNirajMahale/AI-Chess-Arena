import 'package:flutter/material.dart';

/// Smooth animated material evaluation indicator bar.
class EvalBar extends StatelessWidget {
  final int materialAdvantage;
  final bool isFlipped;
  final double height;
  final double width;

  const EvalBar({
    super.key,
    required this.materialAdvantage,
    this.isFlipped = false,
    this.height = 360,
    this.width = 18,
  });

  @override
  Widget build(BuildContext context) {
    // Clamp advantage between -15 and +15 for visual bar normalization
    final clampedAdvantage = materialAdvantage.clamp(-15, 15);
    // Base 50% ratio + 3.0% per material point
    final whiteRatio = (0.5 + (clampedAdvantage * 0.033)).clamp(0.08, 0.92);
    final blackRatio = 1.0 - whiteRatio;

    final topRatio = isFlipped ? whiteRatio : blackRatio;
    final bottomRatio = isFlipped ? blackRatio : whiteRatio;

    final topColor = isFlipped ? const Color(0xFFE2E8F0) : const Color(0xFF1E293B);
    final bottomColor = isFlipped ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);

    final advantageText = materialAdvantage == 0
        ? '0'
        : materialAdvantage > 0
            ? '+$materialAdvantage'
            : '$materialAdvantage';

    final topFlex = (topRatio * 1000).toInt().clamp(1, 999);
    final bottomFlex = (bottomRatio * 1000).toInt().clamp(1, 999);

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 6,
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              Expanded(
                flex: topFlex,
                child: Container(color: topColor),
              ),
              Expanded(
                flex: bottomFlex,
                child: Container(color: bottomColor),
              ),
            ],
          ),
          Positioned(
            bottom: isFlipped ? (materialAdvantage < 0 ? 6 : null) : (materialAdvantage > 0 ? 6 : null),
            top: isFlipped ? (materialAdvantage > 0 ? 6 : null) : (materialAdvantage < 0 ? 6 : null),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.75),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text(
                advantageText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
