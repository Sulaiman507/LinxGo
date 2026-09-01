import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/stats_service.dart';
import '../../core/models/connection_config.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final StatsService _statsService = StatsService();
  SystemStats _stats = const SystemStats();
  final List<FlSpot> _cpuHistory = [];
  int _timeCounter = 0;

  @override
  void initState() {
    super.initState();
    _statsService.stream.listen((stats) {
      if (mounted) {
        setState(() {
          _stats = stats;
          _cpuHistory.add(FlSpot(_timeCounter.toDouble(), stats.cpuUsage));
          _timeCounter++;
          if (_cpuHistory.length > 30) {
            _cpuHistory.removeAt(0);
          }
        });
      }
    });
    _statsService.start();
  }

  @override
  void dispose() {
    _statsService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text('📊 Statistics')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Connection Status
            _buildConnectionCard(isDark),
            const SizedBox(height: 16),
            // CPU Usage Chart
            _buildCpuChart(isDark),
            const SizedBox(height: 16),
            // Resource Gauges
            Row(
              children: [
                Expanded(child: _buildGauge('CPU', _stats.cpuUsage, '%', isDark)),
                const SizedBox(width: 12),
                Expanded(child: _buildGauge('RAM', _stats.ramPercentage, '%', isDark)),
                const SizedBox(width: 12),
                Expanded(child: _buildGauge('Disk', _stats.diskPercentage, '%', isDark)),
              ],
            ),
            const SizedBox(height: 16),
            // Processes
            _buildProcessesList(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectionCard(bool isDark) {
    return Card(
      color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: _stats.isConnected ? AppColors.success : AppColors.error,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _stats.isConnected ? 'Connected' : 'Disconnected',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Latency: ${_stats.latencyMs}ms',
                    style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                  ),
                ],
              ),
            ),
            Text(
              _formatDuration(_stats.uptime),
              style: const TextStyle(fontFamily: 'JetBrainsMono', fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCpuChart(bool isDark) {
    return Card(
      color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('CPU Usage', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            SizedBox(
              height: 100,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  minY: 0,
                  maxY: 100,
                  lineBarsData: [
                    LineChartBarData(
                      spots: _cpuHistory,
                      isCurved: true,
                      color: AppColors.lightAccent,
                      barWidth: 2,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: AppColors.lightAccent.withOpacity(0.2),
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

  Widget _buildGauge(String label, double value, String unit, bool isDark) {
    final color = value > 80 ? AppColors.error : value > 60 ? AppColors.warning : AppColors.success;
    return Card(
      color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(label, style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 8),
            SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(
                value: value / 100,
                strokeWidth: 6,
                backgroundColor: (isDark ? Colors.white : Colors.black).withOpacity(0.1),
                valueColor: AlwaysStoppedAnimation(color),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${value.toStringAsFixed(0)}$unit',
              style: TextStyle(fontFamily: 'JetBrainsMono', fontSize: 12, color: color),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProcessesList(bool isDark) {
    return Card(
      color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Active Processes', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ..._stats.processes.take(5).map((p) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  SizedBox(
                    width: 40,
                    child: Text('${p.pid}', style: const TextStyle(fontFamily: 'JetBrainsMono', fontSize: 12)),
                  ),
                  Expanded(
                    child: Text(p.name, style: const TextStyle(fontSize: 13)),
                  ),
                  Text(
                    'CPU: ${p.cpuPercent.toStringAsFixed(1)}%',
                    style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'MEM: ${p.memPercent.toStringAsFixed(1)}%',
                    style: TextStyle(fontSize: 11, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(d.inHours)}:${twoDigits(d.inMinutes % 60)}:${twoDigits(d.inSeconds % 60)}';
  }
}
