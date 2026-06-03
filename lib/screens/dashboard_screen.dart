import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/design_tokens.dart';
import '../models/device.dart';
import '../providers/device_provider.dart';
import '../widgets/skeleton.dart';
import 'device_detail_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => context.read<DeviceProvider>().load());
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DeviceProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('IoT Devices')),
      body: provider.loading
          ? const _DashboardSkeleton()
          : RefreshIndicator(
              onRefresh: () => context.read<DeviceProvider>().load(),
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.md),
                children: [
                  Row(
                    children: [
                      _KpiCard(
                        label: 'Online devices',
                        value:
                            '${provider.onlineCount}/${provider.devices.length}',
                        icon: Icons.wifi_rounded,
                        gradient: AppColors.brandGradient,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      _KpiCard(
                        label: 'Usage today',
                        value: provider.totalUsageToday.toStringAsFixed(0),
                        icon: Icons.bolt_rounded,
                        gradient: const LinearGradient(
                          colors: [AppColors.success, Color(0xFF0EA5E9)],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text('Devices',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: AppSpacing.sm),
                  for (final d in provider.devices) _DeviceCard(device: d),
                ],
              ),
            ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.gradient,
  });
  final String label;
  final String value;
  final IconData icon;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(AppRadius.card),
          boxShadow: AppShadows.card,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(height: AppSpacing.sm),
            Text(value,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w800)),
            Text(label,
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85), fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class _DeviceCard extends StatelessWidget {
  const _DeviceCard({required this.device});
  final IotDevice device;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
            builder: (_) => DeviceDetailScreen(deviceId: device.id)),
      ),
      child: Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.border),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (device.online ? AppColors.success : AppColors.textMuted)
                      .withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.sensors,
                    size: 18,
                    color: device.online ? AppColors.success : AppColors.textMuted),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(device.name,
                        style: const TextStyle(fontWeight: FontWeight.w700)),
                    Text(device.location,
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              Switch(
                value: device.online,
                activeColor: AppColors.indigo,
                onChanged: (_) =>
                    context.read<DeviceProvider>().toggle(device.id),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            height: 80,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    gradient: AppColors.brandGradient,
                    barWidth: 3,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.indigo.withValues(alpha: 0.20),
                          AppColors.indigo.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                    spots: [
                      for (var i = 0; i < device.weeklyUsage.length; i++)
                        FlSpot(i.toDouble(), device.weeklyUsage[i]),
                    ],
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

class _DashboardSkeleton extends StatelessWidget {
  const _DashboardSkeleton();
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: const [
        Row(
          children: [
            Expanded(child: Skeleton(height: 96, radius: 16)),
            SizedBox(width: AppSpacing.md),
            Expanded(child: Skeleton(height: 96, radius: 16)),
          ],
        ),
        SizedBox(height: AppSpacing.lg),
        Skeleton(height: 150, radius: 16),
        SizedBox(height: AppSpacing.md),
        Skeleton(height: 150, radius: 16),
      ],
    );
  }
}
