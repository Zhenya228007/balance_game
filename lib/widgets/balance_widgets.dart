import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class BalanceBar extends StatelessWidget {
  final String label;
  final int value;
  final int? delta;
  final Color color;
  final Color textColor;

  const BalanceBar({
    super.key,
    required this.label,
    required this.value,
    required this.color,
    required this.textColor,
    this.delta,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          children: [
            Text(label,
                textAlign: TextAlign.center,
                style: TextStyle(color: textColor, fontSize: 12, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: value / 100,
                minHeight: 10,
                color: value <= 20 ? Colors.redAccent : color,
                backgroundColor: textColor.withOpacity(0.15),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              delta == null || delta == 0 ? '$value' : '$value (${delta! > 0 ? '+' : ''}$delta)',
              style: TextStyle(
                color: delta == null || delta == 0
                    ? textColor
                    : (delta! > 0 ? Colors.greenAccent.shade700 : Colors.redAccent),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PulseButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  const PulseButton({super.key, required this.text, required this.onPressed, required this.color});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 28),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        elevation: 12,
        shadowColor: color,
      ),
      child: Text(text, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
    )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .scale(begin: const Offset(1, 1), end: const Offset(1.08, 1.08), duration: 900.ms);
  }
}
