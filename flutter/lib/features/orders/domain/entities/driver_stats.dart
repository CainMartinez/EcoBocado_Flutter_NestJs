class DriverStat {
  final int driverId;
  final String driverName;
  final int completedOrders;
  final double averageDeliveryTime; // en minutos

  const DriverStat({
    required this.driverId,
    required this.driverName,
    required this.completedOrders,
    required this.averageDeliveryTime,
  });

  factory DriverStat.fromJson(Map<String, dynamic> json) {
    return DriverStat(
      driverId: json['driverId'] as int,
      driverName: json['driverName'] as String,
      completedOrders: json['completedOrders'] as int,
      averageDeliveryTime: (json['averageDeliveryTime'] as num).toDouble(),
    );
  }

  String get formattedTime {
    final minutes = averageDeliveryTime.floor();
    final seconds = ((averageDeliveryTime - minutes) * 60).round();
    return '${minutes}m ${seconds}s';
  }
}

class DriverStatsResponse {
  final List<DriverStat> topDrivers;

  const DriverStatsResponse({
    required this.topDrivers,
  });

  factory DriverStatsResponse.fromJson(Map<String, dynamic> json) {
    final drivers = (json['topDrivers'] as List)
        .map((d) => DriverStat.fromJson(d as Map<String, dynamic>))
        .toList();
    return DriverStatsResponse(topDrivers: drivers);
  }
}
