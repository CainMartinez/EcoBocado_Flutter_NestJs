class PickupSlot {
  final int id;
  final int venueId;
  final String slotDate; // 'YYYY-MM-DD'
  final String startTime; // 'HH:MM:SS'
  final String endTime; // 'HH:MM:SS'
  final int capacity;
  final int bookedCount;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PickupSlot({
    required this.id,
    required this.venueId,
    required this.slotDate,
    required this.startTime,
    required this.endTime,
    required this.capacity,
    required this.bookedCount,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PickupSlot.fromJson(Map<String, dynamic> json) {
    return PickupSlot(
      id: json['id'] as int,
      venueId: json['venueId'] as int,
      slotDate: json['slotDate'] as String,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      capacity: json['capacity'] as int,
      bookedCount: json['bookedCount'] as int,
      isActive: json['isActive'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  /// Retorna el horario formateado para mostrar al usuario
  String get displayTime {
    // Convertir 'HH:MM:SS' a 'HH:MM'
    final start = startTime.substring(0, 5);
    final end = endTime.substring(0, 5);
    return '$start - $end';
  }

  /// Retorna si el slot está disponible (tiene capacidad)
  bool get isAvailable => bookedCount < capacity;

  /// Retorna los espacios disponibles
  int get availableSpots => capacity - bookedCount;
}
