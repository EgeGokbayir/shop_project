import 'package:flutter/material.dart';

class SpecChip extends StatelessWidget {
  const SpecChip({
    super.key,
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6F8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE3E5E8)),
      ),
      child: Center(
        child: Text(
          label,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 9,
            height: 1.15,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
