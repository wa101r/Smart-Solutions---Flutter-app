import 'package:flutter/material.dart';

import '../core/design_tokens.dart';

class RatingStars extends StatelessWidget {
  const RatingStars({super.key, required this.rating, this.size = 16, this.color});

  final double rating;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.warning;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 1; i <= 5; i++)
          Icon(
            i <= rating
                ? Icons.star_rounded
                : (i - 0.5 <= rating
                    ? Icons.star_half_rounded
                    : Icons.star_outline_rounded),
            size: size,
            color: c,
          ),
      ],
    );
  }
}
