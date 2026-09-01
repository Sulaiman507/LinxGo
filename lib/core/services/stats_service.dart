import 'dart:async';
import '../models/connection_config.dart';

/// Service for monitoring system statistics
class StatsService {
  SystemStats _stats = const SystemStats();
  SystemStats get stats => _stats;

  final _controller = StreamController<SystemStats>.broadcast();
  Stream<SystemStats> get stream => _controller.stream;

  Timer? _timer;
  bool _isRunning = false;

  void start({Duration interval = const Duration(seconds: 2)}) {
    if (_isRunning) return;
    _isRunning = true;
    
    _fetchStats();
    _timer = Timer.periodic(interval, (_) => _fetchStats());
  }

  Future<void> _fetchStats() async {
    try {
      // Simulated stats — replace with actual Linux commands via Termux
      final now = DateTime.now();
      _stats = SystemStats(
        cpuUsage: _simulateUsage(67),
        ramUsageGB: 1.2,
        ramTotalGB: 4.0,
        diskUsageGB: 2.1,
        diskTotalGB: 16.0,
        uptime: Duration(minutes: now.minute, seconds: now.second),
        processes: const [
          ProcessInfo(pid: 1, name: 'systemd', cpuPercent: 0.1, memPercent: 0.5),
          ProcessInfo(pid: 2, name: 'Xorg', cpuPercent: 5.2, memPercent: 8.1),
          ProcessInfo(pid: 3, name: 'xfce4', cpuPercent: 1.3, memPercent: 3.2),
          ProcessInfo(pid: 4, name: 'firefox-esr', cpuPercent: 12.0, memPercent: 15.5),
          ProcessInfo(pid: 5, name: 'bash', cpuPercent: 0.0, memPercent: 0.1),
        ],
        isConnected: true,
        latencyMs: 45,
      );
      _controller.add(_stats);
    } catch (e) {
      _stats = _stats.copyWith(isConnected: false);
      _controller.add(_stats);
    }
  }

  double _simulateUsage(double base) {
    // Add slight variation to simulate real usage
    return base + (DateTime.now().millisecond % 10 - 5).toDouble().abs();
  }

  void stop() {
    _timer?.cancel();
    _isRunning = false;
  }

  void dispose() {
    stop();
    _controller.close();
  }
}

extension SystemStatsCopy on SystemStats {
  SystemStats copyWith({
    double? cpuUsage,
    double? ramUsageGB,
    double? ramTotalGB,
    double? diskUsageGB,
    double? diskTotalGB,
    Duration? uptime,
    List<ProcessInfo>? processes,
    bool? isConnected,
    int? latencyMs,
  }) {
    return SystemStats(
      cpuUsage: cpuUsage ?? this.cpuUsage,
      ramUsageGB: ramUsageGB ?? this.ramUsageGB,
      ramTotalGB: ramTotalGB ?? this.ramTotalGB,
      diskUsageGB: diskUsageGB ?? this.diskUsageGB,
      diskTotalGB: diskTotalGB ?? this.diskTotalGB,
      uptime: uptime ?? this.uptime,
      processes: processes ?? this.processes,
      isConnected: isConnected ?? this.isConnected,
      latencyMs: latencyMs ?? this.latencyMs,
    );
  }
}
