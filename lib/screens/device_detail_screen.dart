import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/design_tokens.dart';
import '../models/device.dart';
import '../providers/device_provider.dart';

class DeviceDetailScreen extends StatelessWidget {
  const DeviceDetailScreen({super.key, required this.deviceId});
  final String deviceId;

  @override
  Widget build(BuildContext context) {
    // Watch so toggles/updates reflect live.
    final device =
        context.watch<DeviceProvider>().devices.firstWhere((d) => d.id == deviceId);

    return Scaffold(
      appBar: AppBar(title: Text(device.name)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          // Header card
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(color: AppColors.border),
              boxShadow: AppShadows.card,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: AppColors.brandGradient,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.sensors, color: Colors.white),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${device.type} · ${device.serialNo}',
                          style: Theme.of(context).textTheme.bodySmall),
                      Text(device.location,
                          style:
                              const TextStyle(fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
                _StatusChip(online: device.online),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Stat grid
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: AppSpacing.md,
            crossAxisSpacing: AppSpacing.md,
            childAspectRatio: 2.4,
            children: [
              _StatTile(
                  icon: Icons.bolt,
                  label: 'Usage today',
                  value: '${device.usageToday.toStringAsFixed(0)} ${device.unit}'),
              _StatTile(
                  icon: Icons.battery_full,
                  label: 'Battery',
                  value: '${device.battery}%',
                  color: device.battery < 20 ? AppColors.danger : AppColors.success),
              _StatTile(
                  icon: Icons.network_cell,
                  label: 'Signal',
                  value: '${device.signal}%'),
              _StatTile(
                  icon: Icons.memory,
                  label: 'Firmware',
                  value: device.firmware),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Chart card
          _Card(
            title: '7-day usage (${device.unit})',
            child: SizedBox(
              height: 160,
              child: BarChart(
                BarChartData(
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (v, _) {
                          const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                          final i = v.toInt();
                          return Text(i >= 0 && i < days.length ? days[i] : '',
                              style: const TextStyle(
                                  fontSize: 11, color: AppColors.textMuted));
                        },
                      ),
                    ),
                  ),
                  barGroups: [
                    for (var i = 0; i < device.weeklyUsage.length; i++)
                      BarChartGroupData(x: i, barRods: [
                        BarChartRodData(
                          toY: device.weeklyUsage[i],
                          gradient: AppColors.brandGradient,
                          width: 14,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ]),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Activity log
          _Card(
            title: 'Activity log',
            child: Column(
              children: [
                for (final log in device.logs) _LogRow(log: log),
                if (device.logs.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(12),
                    child: Text('No recent activity',
                        style: TextStyle(color: AppColors.textMuted)),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text('Last seen: ${device.lastSeen}',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.online});
  final bool online;
  @override
  Widget build(BuildContext context) {
    final c = online ? AppColors.success : AppColors.danger;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(online ? 'Online' : 'Offline',
          style: TextStyle(color: c, fontWeight: FontWeight.w700, fontSize: 12)),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile(
      {required this.icon,
      required this.label,
      required this.value,
      this.color});
  final IconData icon;
  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, color: color ?? AppColors.indigo),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(value,
                  style: const TextStyle(
                      fontWeight: FontWeight.w800, fontSize: 16)),
              Text(label,
                  style: const TextStyle(
                      color: AppColors.textMuted, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.title, required this.child});
  final String title;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: AppSpacing.md),
          child,
        ],
      ),
    );
  }
}

class _LogRow extends StatelessWidget {
  const _LogRow({required this.log});
  final DeviceLog log;

  @override
  Widget build(BuildContext context) {
    final color = switch (log.level) {
      LogLevel.error => AppColors.danger,
      LogLevel.warning => AppColors.warning,
      LogLevel.info => AppColors.textMuted,
    };
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Icon(Icons.circle, size: 8, color: color),
          ),
          const SizedBox(width: 10),
          Text(log.time,
              style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.w600)),
          const SizedBox(width: 10),
          Expanded(child: Text(log.message)),
        ],
      ),
    );
  }
}
