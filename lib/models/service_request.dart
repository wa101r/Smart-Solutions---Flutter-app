enum ServiceType { repair, maintenance, installation, consultation }

extension ServiceTypeLabel on ServiceType {
  String get label => switch (this) {
        ServiceType.repair => 'Repair',
        ServiceType.maintenance => 'Maintenance',
        ServiceType.installation => 'Installation',
        ServiceType.consultation => 'Consultation',
      };
}

enum TicketStatus { submitted, assigned, inProgress, resolved }

extension TicketStatusInfo on TicketStatus {
  String get label => switch (this) {
        TicketStatus.submitted => 'Submitted',
        TicketStatus.assigned => 'Assigned',
        TicketStatus.inProgress => 'In progress',
        TicketStatus.resolved => 'Resolved',
      };
}

class TicketEvent {
  const TicketEvent({required this.label, required this.time, required this.done});
  final String label;
  final String time;
  final bool done;
}

/// A service ticket a customer submits (matches the company's after-sales service).
class ServiceRequest {
  ServiceRequest({
    String? id,
    required this.customerName,
    required this.phone,
    required this.type,
    required this.detail,
    this.status = TicketStatus.submitted,
    this.technician,
    DateTime? createdAt,
    this.timeline = const [],
  })  : id = id ?? 'TK-${DateTime.now().millisecondsSinceEpoch % 100000}',
        createdAt = createdAt ?? DateTime.now();

  final String id;
  final String customerName;
  final String phone;
  final ServiceType type;
  final String detail;
  final TicketStatus status;
  final String? technician;
  final DateTime createdAt;
  final List<TicketEvent> timeline;

  Map<String, dynamic> toJson() => {
        'id': id,
        'customerName': customerName,
        'phone': phone,
        'type': type.name,
        'detail': detail,
        'status': status.name,
        'createdAt': createdAt.toIso8601String(),
      };
}
