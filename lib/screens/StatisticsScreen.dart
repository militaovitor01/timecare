// statisticsScreen.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});
  
 @override
  Widget build(BuildContext context) {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
      children: [
        _buildWeeklyCard(),
        const SizedBox(height: 16),
        _buildWeeklyProgress(), // <-- Novo contador aqui
        const SizedBox(height: 16),
        _buildDailyReport(),
        const SizedBox(height: 16),
        _buildOverallStatistics(),
      ],
    ),
  );
}

Widget _buildWeeklyProgress() {
  // Dados de exemplo — depois você pode conectar com dados reais
  int totalTomados = 12;
  int totalPrevistos = 14;
  double porcentagem = (totalTomados / totalPrevistos) * 100;

  return Container(
    padding: const EdgeInsets.all(16),
    decoration: _boxDecoration(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Progresso da Semana',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$totalTomados de $totalPrevistos remédios tomados',
              style: const TextStyle(fontSize: 14),
            ),
            Text(
              '${porcentagem.toStringAsFixed(1)}%',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: porcentagem / 100,
            backgroundColor: Colors.grey[300],
            color: Colors.blueAccent,
            minHeight: 8,
          ),
        ),
      ],
    ),
  );
}
 Widget _buildWeeklyCard() {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      gradient: const LinearGradient(
        colors: [
          Color(0xFF0D47A1),
          Color(0xFF1565C0),
          Color(0xFF1E88E5),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.card_giftcard, color: Colors.white, size: 30),
          SizedBox(height: 10),
          Text(
            'Acompanhamento Diário',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            'Veja como está seu progresso\nao longo da semana.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}


Widget _buildDailyReport() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Daily report', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Icon(Icons.tune),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildPieChart(),
              const SizedBox(width: 16),
              _buildLegend(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPieChart() {
    return SizedBox(
      width: 100,
      height: 100,
      child: PieChart(
        PieChartData(
          sectionsSpace: 2,
          centerSpaceRadius: 20,
          sections: [
            PieChartSectionData(value: 30, color: Colors.orange, radius: 25),
            PieChartSectionData(value: 20, color: Colors.red, radius: 25),
            PieChartSectionData(value: 50, color: Colors.green, radius: 25),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text('20 Junho', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        LegendItem(color: Colors.orange, label: 'Atraso'),
        LegendItem(color: Colors.red, label: 'Não tomou'),
        LegendItem(color: Colors.green, label: 'Horário Correto'),
      ],
    );
  }

  Widget _buildOverallStatistics() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Overall statistics', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          SizedBox(
            height: 150,
            child: BarChart(
              BarChartData(
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(show: false),
                barGroups: [
                  BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 6, color: Colors.red)]),
                  BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 5, color: Colors.green)]),
                  BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 4, color: Colors.orange)]),
                  BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 6, color: Colors.green)]),
                  BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 3, color: Colors.red)]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _boxDecoration() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      );
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const LegendItem({super.key, required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(radius: 5, backgroundColor: color),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }
}
