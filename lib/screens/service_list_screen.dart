import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/design_tokens.dart';
import '../models/service_request.dart';
import '../providers/service_provider.dart';
import 'service_request_screen.dart';
import 'ticket_detail_screen.dart';

class ServiceListScreen extends StatelessWidget {
  const ServiceListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = context.watch<ServiceProvider>();
    final tickets = service.tickets;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Tickets'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.indigo.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Text('${service.openCount} open',
                    style: const TextStyle(
                        color: AppColors.indigo,
                        fontWeight: FontWeight.w700,
                        fontSize: 12)),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.indigo,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('New request'),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ServiceRequestScreen()),
        ),
      ),
      body: tickets.isEmpty
          ? const Center(child: Text('No tickets yet'))
          : ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: tickets.length,
              itemBuilder: (context, i) => _TicketCard(ticket: tickets[i]),
            ),
    );
  }
}

class _TicketCard extends StatelessWidget {
  const _TicketCard({required this.ticket});
  final ServiceRequest ticket;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => TicketDetailScreen(ticket: ticket)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
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
            Row(
              children: [
                Text(ticket.id,
                    style: const TextStyle(
                        fontWeight: FontWeight.w800, color: AppColors.indigo)),
                const Spacer(),
                TicketStatusBadge(status: ticket.status),
              ],
            ),
            const SizedBox(height: 6),
            Text(ticket.type.label,
                style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 2),
            Text(ticket.detail,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium),
            if (ticket.technician != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.engineering,
                      size: 16, color: AppColors.textMuted),
                  const SizedBox(width: 4),
                  Text(ticket.technician!,
                      style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class TicketStatusBadge extends StatelessWidget {
  const TicketStatusBadge({super.key, required this.status});
  final TicketStatus status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      TicketStatus.submitted => AppColors.textMuted,
      TicketStatus.assigned => AppColors.indigo,
      TicketStatus.inProgress => AppColors.warning,
      TicketStatus.resolved => AppColors.success,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(status.label,
          style: TextStyle(
              color: color, fontWeight: FontWeight.w700, fontSize: 11)),
    );
  }
}
