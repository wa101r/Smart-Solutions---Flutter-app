import 'package:flutter/foundation.dart';

import '../models/device.dart';
import '../repositories/device_repository.dart';

class DeviceProvider extends ChangeNotifier {
  DeviceProvider(this._repo);
  final DeviceRepository _repo;

  bool loading = false;
  List<IotDevice> devices = [];

  int get onlineCount => devices.where((d) => d.online).length;
  double get totalUsageToday =>
      devices.fold(0, (sum, d) => sum + d.usageToday);

  Future<void> load() async {
    loading = true;
    notifyListeners();
    devices = await _repo.fetchDevices();
    loading = false;
    notifyListeners();
  }

  void toggle(String id) {
    final d = devices.firstWhere((d) => d.id == id);
    d.online = !d.online;
    notifyListeners();
  }
}
