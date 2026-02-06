import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class DeliveryTimeSelectionPage extends StatefulWidget {
  final Map<String, dynamic>? addressData;

  const DeliveryTimeSelectionPage({
    super.key,
    this.addressData,
  });

  @override
  State<DeliveryTimeSelectionPage> createState() => _DeliveryTimeSelectionPageState();
}

class _DeliveryTimeSelectionPageState extends State<DeliveryTimeSelectionPage> {
  DateTime? selectedDate;
  TimeSlot? selectedTimeSlot;
  Map<String, dynamic>? temporaryAddressData;

  final List<TimeSlot> availableTimeSlots = [
    TimeSlot(startTime: '09:00:00', endTime: '10:00:00', label: '09:00 - 10:00'),
    TimeSlot(startTime: '10:00:00', endTime: '11:00:00', label: '10:00 - 11:00'),
    TimeSlot(startTime: '11:00:00', endTime: '12:00:00', label: '11:00 - 12:00'),
    TimeSlot(startTime: '12:00:00', endTime: '13:00:00', label: '12:00 - 13:00'),
    TimeSlot(startTime: '13:00:00', endTime: '14:00:00', label: '13:00 - 14:00'),
    TimeSlot(startTime: '17:00:00', endTime: '18:00:00', label: '17:00 - 18:00'),
    TimeSlot(startTime: '18:00:00', endTime: '19:00:00', label: '18:00 - 19:00'),
    TimeSlot(startTime: '19:00:00', endTime: '20:00:00', label: '19:00 - 20:00'),
    TimeSlot(startTime: '20:00:00', endTime: '21:00:00', label: '20:00 - 21:00'),
  ];

  bool get isTemporaryAddress => widget.addressData?['isTemporary'] == true;

  /// Filtra los slots de tiempo disponibles.
  /// Si la fecha seleccionada es hoy, solo muestra slots cuyo endTime sea después de la hora actual.
  List<TimeSlot> get filteredTimeSlots {
    if (selectedDate == null) return availableTimeSlots;

    final now = DateTime.now();
    final isToday = selectedDate!.year == now.year &&
        selectedDate!.month == now.month &&
        selectedDate!.day == now.day;

    if (!isToday) return availableTimeSlots;

    // Filtrar slots que ya pasaron
    return availableTimeSlots.where((slot) {
      final endParts = slot.endTime.split(':');
      final endHour = int.parse(endParts[0]);
      final endMinute = int.parse(endParts[1]);
      
      final slotEndTime = DateTime(
        now.year,
        now.month,
        now.day,
        endHour,
        endMinute,
      );

      return slotEndTime.isAfter(now);
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    // Si es dirección temporal, ir directamente al formulario
    if (isTemporaryAddress) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _goToTemporaryAddressForm();
      });
    }
  }

  Future<void> _goToTemporaryAddressForm() async {
    final result = await context.push('/temporary-address-form');
    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        temporaryAddressData = result;
      });
    } else if (mounted) {
      // Si canceló, volver atrás
      context.pop();
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime firstDate = now;
    final DateTime lastDate = now.add(const Duration(days: 30));

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: firstDate,
      lastDate: lastDate,
      locale: const Locale('es', 'ES'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        selectedTimeSlot = null;
      });
    }
  }

  void _confirmSelection() {
    if (selectedDate == null || selectedTimeSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona fecha y hora estimada de entrega'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final result = <String, dynamic>{
      'deliveryType': 'delivery',
      'estimatedDeliveryDate': DateFormat('yyyy-MM-dd').format(selectedDate!),
      'estimatedDeliveryTime': selectedTimeSlot!.startTime,
    };

    // Si es dirección guardada, agregar el ID
    if (!isTemporaryAddress && widget.addressData?['userAddressId'] != null) {
      result['userAddressId'] = widget.addressData!['userAddressId'];
    }

    // Si es dirección temporal, agregar todos los campos
    if (isTemporaryAddress && temporaryAddressData != null) {
      result.addAll(temporaryAddressData!);
    }

    context.pop(result);
  }

  @override
  Widget build(BuildContext context) {
    // Si es dirección temporal y aún no tiene datos, mostrar loading
    if (isTemporaryAddress && temporaryAddressData == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hora estimada de entrega'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Info banner
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.orange.shade700),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Selecciona la franja horaria estimada para la entrega',
                            style: TextStyle(
                              color: Colors.orange.shade900,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Date Selection
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      onTap: () => _selectDate(context),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.calendar_today,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Fecha de entrega',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: Colors.grey[600],
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    selectedDate != null
                                        ? DateFormat('EEEE, d MMMM yyyy', 'es_ES').format(selectedDate!)
                                        : 'Selecciona una fecha',
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios, size: 16),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Time Slot Selection
                  if (selectedDate != null) ...[
                    Text(
                      'Franja horaria estimada',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Selecciona una franja horaria para organizar las rutas de reparto',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    const SizedBox(height: 16),
                    if (filteredTimeSlots.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.orange.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, color: Colors.orange.shade700),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'No hay franjas horarias disponibles para hoy. Por favor, selecciona otra fecha.',
                                style: TextStyle(
                                  color: Colors.orange.shade900,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 2.5,
                        ),
                        itemCount: filteredTimeSlots.length,
                        itemBuilder: (context, index) {
                          final slot = filteredTimeSlots[index];
                          final isSelected = selectedTimeSlot == slot;

                          return InkWell(
                            onTap: () {
                              setState(() {
                                selectedTimeSlot = slot;
                              });
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Theme.of(context).primaryColor
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? Theme.of(context).primaryColor
                                      : Colors.grey.shade300,
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  slot.label,
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : Colors.black87,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ],
              ),
            ),
          ),

          // Confirm Button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _confirmSelection,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Confirmar entrega a domicilio'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TimeSlot {
  final String startTime;
  final String endTime;
  final String label;

  TimeSlot({
    required this.startTime,
    required this.endTime,
    required this.label,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TimeSlot &&
        other.startTime == startTime &&
        other.endTime == endTime;
  }

  @override
  int get hashCode => startTime.hashCode ^ endTime.hashCode;
}
