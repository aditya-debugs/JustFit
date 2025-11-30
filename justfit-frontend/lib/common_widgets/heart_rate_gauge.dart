import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeartRateGauge extends StatelessWidget {
  final int heartRate;
  final bool showZones;
  final double size;

  const HeartRateGauge({
    Key? key,
    required this.heartRate,
    this.showZones = false,
    this.size = 200,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate progress based on heart rate (0-180 BPM range)
    final progress = (heartRate / 180).clamp(0.0, 1.0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Circular gauge
        SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background circle
              CustomPaint(
                size: Size(size, size),
                painter: _GaugePainter(
                  progress: progress,
                  showZones: showZones,
                ),
              ),
              
              // Heart rate value
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Heart icon
                  Icon(
                    Icons.favorite,
                    color: const Color(0xFFE91E63),
                    size: size * 0.15,
                  ),
                  SizedBox(height: size * 0.02),
                  // BPM value
                  Text(
                    '$heartRate',
                    style: GoogleFonts.poppins(
                      fontSize: size * 0.25,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      height: 1,
                    ),
                  ),
                  Text(
                    'BPM',
                    style: GoogleFonts.poppins(
                      fontSize: size * 0.08,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[500],
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        // Zone legend (optional)
        if (showZones) ...[
          const SizedBox(height: 32),
          _buildZoneLegend(),
        ],
      ],
    );
  }

  Widget _buildZoneLegend() {
    return Wrap(
      spacing: 16,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: [
        _ZoneDot(color: const Color(0xFF64B5F6), label: 'Resting'),
        _ZoneDot(color: const Color(0xFFBA68C8), label: 'Warm Up'),
        _ZoneDot(color: const Color(0xFFE91E63), label: 'Fat Burning'),
        _ZoneDot(color: const Color(0xFFFFB300), label: 'Anaerobic'),
      ],
    );
  }
}

class _ZoneDot extends StatelessWidget {
  final Color color;
  final String label;

  const _ZoneDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double progress;
  final bool showZones;

  _GaugePainter({
    required this.progress,
    required this.showZones,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 20;
    final strokeWidth = 14.0;

    // Arc spans ~280 degrees (leaving 80 degrees gap at bottom)
    const startAngle = math.pi * 0.6; // Start from bottom-left
    const sweepAngle = math.pi * 1.8; // 280 degrees

    // Background arc (light gray)
    final bgPaint = Paint()
      ..color = Colors.grey[200]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(rect, startAngle, sweepAngle, false, bgPaint);

        // Progress arc with zones
    if (showZones) {
      // Four colored segments based on actual BPM zones
      final colors = [
        const Color(0xFF64B5F6), // Blue - Resting (0-99)
        const Color(0xFFBA68C8), // Purple - Warm Up (100-119)
        const Color(0xFFE91E63), // Red - Fat Burning (120-139)
        const Color(0xFFFFB300), // Orange - Anaerobic (140-180)
      ];
      
      // BPM thresholds (out of 180 max)
      final zoneStops = [0.0, 100/180, 120/180, 140/180, 1.0]; // 0, 0.556, 0.667, 0.778, 1.0

      // Draw each zone segment based on BPM ranges
      for (int i = 0; i < 4; i++) {
        final zoneStartAngle = startAngle + (sweepAngle * zoneStops[i]);
        final zoneEndAngle = startAngle + (sweepAngle * zoneStops[i + 1]);
        final zoneSweep = zoneEndAngle - zoneStartAngle;
        
        final zonePaint = Paint()
          ..color = colors[i]
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.butt;

        canvas.drawArc(
          rect,
          zoneStartAngle,
          zoneSweep,
          false,
          zonePaint,
        );
      }

      // Draw white indicator circle with colored ring
      final indicatorAngle = startAngle + (sweepAngle * progress);
      final dotX = center.dx + radius * math.cos(indicatorAngle);
      final dotY = center.dy + radius * math.sin(indicatorAngle);
      
      // White circle
      final dotPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(Offset(dotX, dotY), 12, dotPaint);
      
      // Colored ring around white circle
      final dotBorderPaint = Paint()
        ..color = _getColorForProgress(progress)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4;
      
      canvas.drawCircle(Offset(dotX, dotY), 12, dotBorderPaint);
    } else {
      // Single color (pink) for measurement screen
      final progressSweep = sweepAngle * progress;
      
      final progressPaint = Paint()
        ..color = const Color(0xFFE91E63)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(rect, startAngle, progressSweep, false, progressPaint);
    }
  }

    Color _getColorForProgress(double p) {
    // p is progress from 0.0 to 1.0 (representing 0-180 BPM)
    final bpm = p * 180;
    
    if (bpm < 100) return const Color(0xFF64B5F6);      // Blue - Resting
    if (bpm < 120) return const Color(0xFFBA68C8);      // Purple - Warm Up
    if (bpm < 140) return const Color(0xFFE91E63);      // Red - Fat Burning
    return const Color(0xFFFFB300);                     // Orange - Anaerobic
  }

  @override
  bool shouldRepaint(_GaugePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.showZones != showZones;
  }
}
