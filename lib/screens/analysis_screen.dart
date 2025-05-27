import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:math'; // Import dart:math for calculations

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

  int get remedios_corretos =>
      total_remedios - remedios_naotomados - remedios_atrasados;

  // Pie chart data: [green, yellow, red]
  List<double> get pieData {
    if (total_remedios == 0) return [0, 0, 0];
    final corrected = remedios_corretos.toDouble();
    final delayed = remedios_atrasados.toDouble();
    final notTaken = remedios_naotomados.toDouble();
    final total = total_remedios.toDouble();
    return [corrected, delayed, notTaken]; // Return raw values for painter
  }

  final List<Color> pieColors = [
    Color(0xFF50C878),
    Color(0xFFFFC300),
    Color(0xFFE74C3C),
  ];
  final List<String> pieLabels = ['Horário Correto', 'Atraso', 'Não tomou'];

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
      appBar: AppBar(
        title: const Text('Análises'),
        backgroundColor: CupertinoColors.systemGroupedBackground,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Blue header card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: CupertinoColors.activeBlue, // Keep blue for header
              elevation: 4, // Add some elevation
              child: Stack(
                children: [
                  // Background gradient or image can be added here for more flair
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 24,
                      horizontal: 20,
                    ), // Increased padding
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              CupertinoIcons.graph_circle,
                              color: Colors.white,
                              size: 32,
                            ), // Changed icon
                            const SizedBox(width: 12), // Increased spacing
                            const Text(
                              'Acompanhamento Diário',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20, // Increased font size
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10), // Increased spacing
                        const Text(
                          'Veja como está seu progresso ao longo da semana e do dia.', // Updated text
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 15, // Increased font size
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20), // Increased spacing
            // Progress of the week
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4, // Add some elevation
              color: Colors.white, // Set card color to white
              child: Padding(
                padding: const EdgeInsets.all(20), // Increased padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Progresso da Semana',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18, // Increased font size
                      ),
                    ),
                    const SizedBox(height: 12), // Increased spacing
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$taken de $total remédios tomados',
                          style: const TextStyle(fontSize: 15),
                        ),
                        Text(
                          '${(progress * 100).toStringAsFixed(1)}%',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10), // Increased spacing
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 10, // Increased height
                        backgroundColor:
                            CupertinoColors.systemGrey5, // Lighter background
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          CupertinoColors.activeGreen,
                        ), // Changed color to green
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20), // Increased spacing
            // Daily report
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4, // Add some elevation
              color: Colors.white, // Set card color to white
              child: Padding(
                padding: const EdgeInsets.all(20), // Increased padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Relatório Diário', // Changed to Portuguese
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18, // Increased font size
                          ),
                        ),
                        Icon(
                          CupertinoIcons.calendar,
                          color: CupertinoColors.systemGrey,
                          size: 24,
                        ), // Changed icon
                      ],
                    ),
                    const SizedBox(height: 16), // Increased spacing
                    Row(
                      children: [
                        // Pie chart
                        Container(
                          width: 100, // Increased size
                          height: 100, // Increased size
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                CupertinoColors
                                    .systemGroupedBackground, // Match background
                          ),
                          child: CustomPaint(
                            painter: _PieChartPainter(
                              values: pieData, // Use raw values
                              colors: pieColors,
                              total:
                                  total_remedios
                                      .toDouble(), // Pass total for calculation in painter
                            ),
                          ),
                        ),
                        const SizedBox(width: 20), // Increased spacing
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '20 Junho',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ), // Consistent font size
                              const SizedBox(height: 10), // Increased spacing
                              _LegendRow(
                                color: pieColors[0],
                                label: '${pieLabels[0]} (${remedios_corretos})',
                              ),
                              const SizedBox(
                                height: 6,
                              ), // Spacing between legend items
                              _LegendRow(
                                color: pieColors[1],
                                label:
                                    '${pieLabels[1]} (${remedios_atrasados})',
                              ),
                              const SizedBox(
                                height: 6,
                              ), // Spacing between legend items
                              _LegendRow(
                                color: pieColors[2],
                                label:
                                    '${pieLabels[2]} (${remedios_naotomados})',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20), // Increased spacing
            // Overall statistics
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4, // Add some elevation
              color: Colors.white, // Set card color to white
              child: Padding(
                padding: const EdgeInsets.all(20), // Increased padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Estatísticas Mensais', // Changed to Portuguese
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18, // Increased font size
                      ),
                    ),
                    const SizedBox(height: 16), // Increased spacing
                    SizedBox(
                      height: 120, // Increased height for bar chart
                      child: CustomPaint(
                        size: const Size(
                          double.infinity,
                          120,
                        ), // Consistent size
                        painter: _BarChartPainter(
                          values: barData,
                          colors: barColors,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10), // Spacing below chart
                    // Add labels for the bars if needed, could be dates or categories
                    // Example: Row(children: [Text('Seg'), SizedBox(width: ...), Text('Ter'), ...])
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
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _LegendRow extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendRow({required this.color, required this.label});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _LegendDot(color: color),
        const SizedBox(width: 8), // Increased spacing
        Text(
          label,
          style: const TextStyle(fontSize: 15),
        ), // Consistent font size
      ],
    );
  }
}

class _PieChartPainter extends CustomPainter {
  final List<double> values;
  final List<Color> colors;
  final double total; // Receive total here
  _PieChartPainter({
    required this.values,
    required this.colors,
    required this.total,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 14; // Keep stroke width
    double startAngle = -pi / 2; // Start from top
    for (int i = 0; i < values.length; i++) {
      final sweepAngle =
          (values[i] / total) * 2 * pi; // Calculate sweep based on total
      paint.color = colors[i];
      canvas.drawArc(
        Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2),
          radius: size.width / 2 - 7,
        ),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
      startAngle += sweepAngle;
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
    final barWidth = 16.0; // Increased bar width
    final barSpacing = 28.0; // Increased spacing
    final baseY = size.height - 16; // Keep base Y
    final maxBarHeight = size.height - 32; // Keep max height

    // Draw bars
    for (int i = 0; i < values.length; i++) {
      final left =
          i * (barWidth + barSpacing) +
          barSpacing; // Adjust starting position and spacing
      final top = baseY - values[i] * maxBarHeight;
      final paint =
          Paint()
            ..color = colors[i]
            ..style = PaintingStyle.fill
            ..strokeCap = StrokeCap.round; // Keep round cap
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(left, top, barWidth, values[i] * maxBarHeight),
          const Radius.circular(8), // Increased border radius
        ),
        paint,
      );
    }

    // Draw dashed line
    final dashPaint =
        Paint()
          ..color =
              CupertinoColors
                  .systemGrey3 // Lighter dash color
          ..strokeWidth = 1;
    const dashWidth = 6; // Adjusted dash width
    const dashSpace = 6; // Adjusted dash space
    double startX = barSpacing; // Start dashed line after the first bar spacing
    final y = baseY - maxBarHeight / 2; // Keep horizontal position

    // Adjust end position of dashed line to align better
    while (startX < size.width - barSpacing) {
      // Stop before the last bar spacing
      canvas.drawLine(
        Offset(startX, y),
        Offset(startX + dashWidth, y),
        dashPaint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
