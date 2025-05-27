import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  // Constants for the daily report
  static const int total_remedios = 14;
  static const int remedios_atrasados = 0;
  static const int remedios_naotomados = 0;

  int get remedios_corretos => total_remedios - remedios_naotomados - remedios_atrasados;

  // Pie chart data: [green, yellow, red]
  List<double> get pieData {
    if (total_remedios == 0) return [0, 0, 0];
    return [
      remedios_corretos / total_remedios,
      remedios_atrasados / total_remedios,
      remedios_naotomados / total_remedios,
    ];
  }
  final List<Color> pieColors = [Color(0xFF50C878), Color(0xFFFFC300), Color(0xFFE74C3C)];

  // Progress bar
  int get taken => remedios_corretos + remedios_atrasados;
  int get total => total_remedios;
  double get progress => total == 0 ? 0 : taken / total;

  // Bar chart data: [red, green, yellow, green, green] (mocked for now)
  final List<double> barData = [0.3, 0.7, 0.5, 0.8, 0.6];
  final List<Color> barColors = [
    Color(0xFFE74C3C),
    Color(0xFF50C878),
    Color(0xFFFFC300),
    Color(0xFF50C878),
    Color(0xFF50C878),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Blue header card
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: CupertinoColors.activeBlue,
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(CupertinoIcons.gift, color: Colors.white, size: 28),
                        const SizedBox(width: 10),
                        const Text(
                          'Acompanhamento Diário',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Veja como está seu progresso ao longo da semana.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Progress of the week
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Progresso da Semana',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('$taken de $total remédios tomados'),
                        Text('${(progress * 100).toStringAsFixed(1)}%', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor: const Color(0xFFE3EAFD),
                        valueColor: const AlwaysStoppedAnimation<Color>(CupertinoColors.activeBlue),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Daily report
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Daily report',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Icon(CupertinoIcons.slider_horizontal_3, color: CupertinoColors.systemGrey, size: 22),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        // Pie chart
                        Container(
                          width: 70,
                          height: 70,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFF5F6FA),
                          ),
                          child: CustomPaint(
                            painter: _PieChartPainter(
                              values: pieData,
                              colors: pieColors,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('20 Junho', style: const TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                _LegendDot(color: pieColors[0]),
                                const SizedBox(width: 4),
                                Text('Horário Correto (${remedios_corretos})', style: const TextStyle(fontSize: 13)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                _LegendDot(color: pieColors[1]),
                                const SizedBox(width: 4),
                                Text('Atraso (${remedios_atrasados})', style: const TextStyle(fontSize: 13)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                _LegendDot(color: pieColors[2]),
                                const SizedBox(width: 4),
                                Text('Não tomou (${remedios_naotomados})', style: const TextStyle(fontSize: 13)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Overall statistics
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Overall statistics',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 80,
                      child: CustomPaint(
                        size: const Size(double.infinity, 80),
                        painter: _BarChartPainter(
                          values: barData,
                          colors: barColors,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  const _LegendDot({required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _PieChartPainter extends CustomPainter {
  final List<double> values;
  final List<Color> colors;
  _PieChartPainter({required this.values, required this.colors});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;
    double startAngle = -1.57;
    for (int i = 0; i < values.length; i++) {
      final sweep = values[i] * 3.14 * 2;
      paint.color = colors[i];
      canvas.drawArc(
        Rect.fromCircle(center: Offset(size.width/2, size.height/2), radius: size.width/2-7),
        startAngle,
        sweep,
        false,
        paint,
      );
      startAngle += sweep;
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _BarChartPainter extends CustomPainter {
  final List<double> values;
  final List<Color> colors;
  _BarChartPainter({required this.values, required this.colors});
  @override
  void paint(Canvas canvas, Size size) {
    final barWidth = 12.0;
    final barSpacing = 24.0;
    final baseY = size.height - 16;
    final maxBarHeight = size.height - 32;
    for (int i = 0; i < values.length; i++) {
      final left = i * barSpacing + 12;
      final top = baseY - values[i] * maxBarHeight;
      final paint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.fill
        ..strokeCap = StrokeCap.round;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(left, top, barWidth, values[i] * maxBarHeight),
          const Radius.circular(6),
        ),
        paint,
      );
    }
    // Draw dashed line
    final dashPaint = Paint()
      ..color = const Color(0xFFB0B8C1)
      ..strokeWidth = 1;
    const dashWidth = 5;
    const dashSpace = 4;
    double startX = 0;
    final y = baseY - maxBarHeight/2;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, y), Offset(startX + dashWidth, y), dashPaint);
      startX += dashWidth + dashSpace;
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
} 