import 'package:flutter/foundation.dart';

import '../models/service_request.dart';
import '../repositories/product_repository.dart';

/// Manages submitted service tickets + their statuses.
class ServiceProvider extends ChangeNotifier {
  ServiceProvider(this._repo);
  final ProductRepository _repo;

  final List<ServiceRequest> _tickets = [
    ServiceRequest(
      id: 'TK-20451',
      customerName: 'Wooned',
      phone: '061-223-2291',
      type: ServiceType.maintenance,
      detail: 'ขอช่างเข้าตรวจเช็คเครื่องถ่ายเอกสารประจำไตรมาส',
      status: TicketStatus.inProgress,
      technician: 'ช่างอนันต์',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      timeline: const [
        TicketEvent(label: 'Submitted', time: 'Yesterday 14:02', done: true),
        TicketEvent(label: 'Assigned to ช่างอนันต์', time: 'Yesterday 16:20', done: true),
        TicketEvent(label: 'Technician on the way', time: 'Today 09:30', done: true),
        TicketEvent(label: 'Resolved', time: 'Pending', done: false),
      ],
    ),
    ServiceRequest(
      id: 'TK-20390',
      customerName: 'Wooned',
      phone: '061-223-2291',
      type: ServiceType.repair,
      detail: 'เครื่องพิมพ์มีเสียงดังผิดปกติเวลาดึงกระดาษ',
      status: TicketStatus.resolved,
      technician: 'ช่างสมศักดิ์',
      createdAt: DateTime.now().subtract(const Duration(days: 9)),
      timeline: const [
        TicketEvent(label: 'Submitted', time: '9 days ago', done: true),
        TicketEvent(label: 'Assigned', time: '9 days ago', done: true),
        TicketEvent(label: 'In progress', time: '8 days ago', done: true),
        TicketEvent(label: 'Resolved', time: '8 days ago', done: true),
      ],
    ),
  ];

  List<ServiceRequest> get tickets => List.unmodifiable(_tickets.reversed);
  int get openCount =>
      _tickets.where((t) => t.status != TicketStatus.resolved).length;

  Future<void> submit(ServiceRequest request) async {
    await _repo.submitServiceRequest(request);
    final withTimeline = ServiceRequest(
      id: request.id,
      customerName: request.customerName,
      phone: request.phone,
      type: request.type,
      detail: request.detail,
      status: TicketStatus.submitted,
      createdAt: request.createdAt,
      timeline: const [
        TicketEvent(label: 'Submitted', time: 'Just now', done: true),
        TicketEvent(label: 'Assigned', time: 'Pending', done: false),
        TicketEvent(label: 'In progress', time: 'Pending', done: false),
        TicketEvent(label: 'Resolved', time: 'Pending', done: false),
      ],
    );
    _tickets.add(withTimeline);
    notifyListeners();
  }
}
