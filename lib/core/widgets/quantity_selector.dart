import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_colors.dart';

class QuantitySelector extends StatelessWidget {
  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onDecrement,
    required this.onIncrement,
    this.compact = false,
  });

  final int quantity;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final size = compact ? 32.0 : 40.0;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _QuantityButton(
            icon: Icons.remove_rounded,
            onTap: onDecrement,
            size: size,
          ),
          SizedBox(
            width: compact ? 28 : 36,
            child: Text(
              '$quantity',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: compact ? 14 : 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          _QuantityButton(
            icon: Icons.add_rounded,
            onTap: onIncrement,
            size: size,
            isPrimary: true,
          ),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({
    required this.icon,
    required this.onTap,
    required this.size,
    this.isPrimary = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final double size;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isPrimary ? AppColors.primary : Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(
            icon,
            size: size * 0.5,
            color: isPrimary ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
