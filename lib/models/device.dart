/// An activity log entry for an IoT device.
class DeviceLog {
  const DeviceLog({
    required this.time,
    required this.message,
    this.level = LogLevel.info,
  });

  final String time; // e.g. "10:24"
  final String message;
  final LogLevel level;
}

enum LogLevel { info, warning, error }

/// An IoT device monitored on the Smart Solutions dashboard.
class IotDevice {
  IotDevice({
    required this.id,
    required this.name,
    required this.type,
    required this.location,
    required this.online,
    required this.usageToday,
    required this.weeklyUsage,
    this.unit = 'units',
    this.firmware = '1.0.0',
    this.battery = 100,
    this.signal = 100,
    this.lastSeen = 'just now',
    this.serialNo = '',
    this.logs = const [],
  });

  final String id;
  final String name;
  final String type; // Copier, Smart Meter, Sensor...
  final String location;
  bool online;
  final double usageToday;
  final List<double> weeklyUsage;
  final String unit; // copies / kWh / events
  final String firmware;
  final int battery; // 0..100
  final int signal; // 0..100
  final String lastSeen;
  final String serialNo;
  final List<DeviceLog> logs;

  factory IotDevice.fromJson(Map<String, dynamic> json) => IotDevice(
        id: json['id'].toString(),
        name: json['name'] as String,
        type: json['type'] as String? ?? 'Device',
        location: json['location'] as String,
        online: json['online'] as bool? ?? false,
        usageToday: (json['usageToday'] as num).toDouble(),
        weeklyUsage: (json['weeklyUsage'] as List)
            .map((e) => (e as num).toDouble())
            .toList(),
        unit: json['unit'] as String? ?? 'units',
        firmware: json['firmware'] as String? ?? '1.0.0',
        battery: json['battery'] as int? ?? 100,
        signal: json['signal'] as int? ?? 100,
        lastSeen: json['lastSeen'] as String? ?? 'just now',
        serialNo: json['serialNo'] as String? ?? '',
      );
}
