import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../core/design_tokens.dart';
import '../models/service_request.dart';
import 'service_list_screen.dart';

class TicketDetailScreen extends StatelessWidget {
  const TicketDetailScreen({super.key, required this.ticket});
  final ServiceRequest ticket;

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('d MMM yyyy, HH:mm');
    return Scaffold(
      appBar: AppBar(title: Text(ticket.id)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          // Summary card
          _card(
            context,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(ticket.type.label,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w800)),
                    ),
                    TicketStatusBadge(status: ticket.status),
                  ],
                ),
                const SizedBox(height: 8),
                Text(ticket.detail, style: const TextStyle(height: 1.4)),
                const Divider(height: 24),
                _row(Icons.person_outline, 'Customer', ticket.customerName),
                _row(Icons.phone_outlined, 'Phone', ticket.phone),
                if (ticket.technician != null)
                  _row(Icons.engineering, 'Technician', ticket.technician!),
                _row(Icons.schedule, 'Created', df.format(ticket.createdAt)),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          // Timeline
          _card(
            context,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Status timeline',
                    style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: AppSpacing.md),
                for (var i = 0; i < ticket.timeline.length; i++)
                  _TimelineRow(
                    event: ticket.timeline[i],
                    isLast: i == ticket.timeline.length - 1,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _card(BuildContext context, {required Widget child}) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: AppColors.border),
          boxShadow: AppShadows.card,
        ),
        child: child,
      );

  Widget _row(IconData icon, String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            Icon(icon, size: 16, color: AppColors.textMuted),
            const SizedBox(width: 8),
            SizedBox(
                width: 90,
                child: Text(label,
                    style: const TextStyle(color: AppColors.textMuted))),
            Expanded(
                child: Text(value,
                    style: const TextStyle(fontWeight: FontWeight.w600))),
          ],
        ),
      );
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({required this.event, required this.isLast});
  final TicketEvent event;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final color = event.done ? AppColors.success : AppColors.border;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  color: event.done ? color : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: 2),
                ),
                child: event.done
                    ? const Icon(Icons.check, size: 12, color: Colors.white)
                    : null,
              ),
              if (!isLast)
                Expanded(
                  child: Container(width: 2, color: AppColors.border),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.label,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: event.done
                            ? null
                            : AppColors.textMuted)),
                Text(event.time,
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
