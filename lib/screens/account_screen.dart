import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../core/design_tokens.dart';
import '../models/order.dart';
import '../providers/auth_provider.dart';
import '../providers/device_provider.dart';
import '../providers/order_provider.dart';
import '../providers/service_provider.dart';
import '../providers/theme_provider.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final orders = context.watch<OrderProvider>();
    final service = context.watch<ServiceProvider>();
    final devices = context.watch<DeviceProvider>();
    final theme = context.watch<ThemeProvider>();
    final baht =
        NumberFormat.currency(locale: 'th_TH', symbol: '฿', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(title: const Text('Account')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          // Profile header
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              gradient: AppColors.brandGradient,
              borderRadius: BorderRadius.circular(AppRadius.card),
              boxShadow: AppShadows.card,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  child: Text(auth.initials,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 20)),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(auth.displayName,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800)),
                      Text(auth.email ?? '',
                          style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.85),
                              fontSize: 13)),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                        child: Text(auth.role,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Padding(
            padding: const EdgeInsets.all(4),
            child: Text(auth.company,
                style: Theme.of(context).textTheme.bodySmall),
          ),
          const SizedBox(height: AppSpacing.md),

          // System summary
          Text('System overview',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: AppSpacing.sm),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: AppSpacing.md,
            crossAxisSpacing: AppSpacing.md,
            childAspectRatio: 2.2,
            children: [
              _SummaryTile(
                  icon: Icons.receipt_long,
                  label: 'Orders',
                  value: '${orders.count}'),
              _SummaryTile(
                  icon: Icons.payments,
                  label: 'Lifetime spend',
                  value: baht.format(orders.lifetimeSpend)),
              _SummaryTile(
                  icon: Icons.build,
                  label: 'Open tickets',
                  value: '${service.openCount}'),
              _SummaryTile(
                  icon: Icons.sensors,
                  label: 'Devices online',
                  value: '${devices.onlineCount}/${devices.devices.length}'),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // Order history
          Text('Order history',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: AppSpacing.sm),
          for (final o in orders.orders) _OrderTile(order: o, baht: baht),
          const SizedBox(height: AppSpacing.lg),

          // Settings
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  secondary: Icon(theme.isDark
                      ? Icons.dark_mode
                      : Icons.light_mode),
                  title: const Text('Dark mode'),
                  value: theme.isDark,
                  activeColor: AppColors.indigo,
                  onChanged: (_) => theme.toggle(),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.logout, color: AppColors.danger),
                  title: const Text('Sign out',
                      style: TextStyle(color: AppColors.danger)),
                  onTap: () => context.read<AuthProvider>().logout(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile(
      {required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

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
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.indigo.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.indigo, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.w800, fontSize: 15)),
                Text(label,
                    style: const TextStyle(
                        color: AppColors.textMuted, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderTile extends StatelessWidget {
  const _OrderTile({required this.order, required this.baht});
  final Order order;
  final NumberFormat baht;

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('d MMM yyyy');
    final statusColor = switch (order.status) {
      OrderStatus.delivered => AppColors.success,
      OrderStatus.shipping => AppColors.warning,
      OrderStatus.confirmed => AppColors.indigo,
      OrderStatus.pending => AppColors.textMuted,
    };
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(order.id,
                    style: const TextStyle(fontWeight: FontWeight.w700)),
                Text('${order.itemCount} items · ${df.format(order.placedAt)}',
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(baht.format(order.total),
                  style: const TextStyle(
                      fontWeight: FontWeight.w800, color: AppColors.indigo)),
              Text(order.status.label,
                  style: TextStyle(
                      color: statusColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w700)),
            ],
          ),
        ],
      ),
    );
  }
}
