import '../core/api_client.dart';
import '../models/device.dart';

class DeviceRepository {
  DeviceRepository(this._api);
  final ApiClient _api;

  Future<List<IotDevice>> fetchDevices() async {
    try {
      final data = await _api.getJson('/devices');
      return (data as List)
          .map((e) => IotDevice.fromJson(e as Map<String, dynamic>))
          .toList();
    } on ApiException {
      return _mock;
    }
  }

  static List<IotDevice> get _mock => [
        IotDevice(
          id: 'd1',
          name: 'SHARP MX-3071',
          type: 'Copier',
          location: 'HQ Bangkok · Floor 3',
          online: true,
          usageToday: 420,
          unit: 'copies',
          weeklyUsage: [380, 410, 360, 500, 470, 290, 420],
          firmware: '2.4.1',
          battery: 100,
          signal: 92,
          lastSeen: '2 min ago',
          serialNo: 'SHP3071-0098',
          logs: const [
            DeviceLog(time: '10:24', message: 'Print job completed (12 pages)'),
            DeviceLog(
                time: '09:40',
                message: 'Toner level low (18%)',
                level: LogLevel.warning),
            DeviceLog(time: '08:15', message: 'Device powered on'),
          ],
        ),
        IotDevice(
          id: 'd2',
          name: 'Smart Meter',
          type: 'Smart Meter',
          location: 'Rangsit Warehouse',
          online: true,
          usageToday: 58.2,
          unit: 'kWh',
          weeklyUsage: [44, 51, 49, 60, 57, 40, 58.2],
          firmware: '1.8.0',
          battery: 100,
          signal: 78,
          lastSeen: '30 sec ago',
          serialNo: 'MTR-2231',
          logs: const [
            DeviceLog(time: '11:00', message: 'Peak load 12.4 kW recorded'),
            DeviceLog(time: '07:00', message: 'Daily report uploaded'),
          ],
        ),
        IotDevice(
          id: 'd3',
          name: 'Door Sensor',
          type: 'Sensor',
          location: 'HQ Bangkok · Server Room',
          online: false,
          usageToday: 0,
          unit: 'events',
          weeklyUsage: [2, 1, 3, 0, 1, 0, 0],
          firmware: '1.2.3',
          battery: 14,
          signal: 0,
          lastSeen: '3 hrs ago',
          serialNo: 'DR-5567',
          logs: const [
            DeviceLog(
                time: '08:02',
                message: 'Connection lost',
                level: LogLevel.error),
            DeviceLog(
                time: '07:55',
                message: 'Battery critically low (14%)',
                level: LogLevel.warning),
          ],
        ),
        IotDevice(
          id: 'd4',
          name: 'Smart Door Lock',
          type: 'Lock',
          location: 'HQ Bangkok · Main Entrance',
          online: true,
          usageToday: 36,
          unit: 'unlocks',
          weeklyUsage: [40, 38, 42, 35, 50, 12, 36],
          firmware: '3.0.2',
          battery: 67,
          signal: 88,
          lastSeen: '1 min ago',
          serialNo: 'LK-0421',
          logs: const [
            DeviceLog(time: '09:12', message: 'Unlocked by fingerprint (Admin)'),
            DeviceLog(time: '08:30', message: 'Unlocked by PIN'),
          ],
        ),
      ];
}
