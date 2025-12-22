import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class PickupSelectionPage extends StatefulWidget {
  const PickupSelectionPage({super.key});

  @override
  State<PickupSelectionPage> createState() => _PickupSelectionPageState();
}

class _PickupSelectionPageState extends State<PickupSelectionPage> {
  DateTime? selectedDate;
  TimeSlot? selectedTimeSlot;

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
        selectedTimeSlot = null; // Reset time slot when date changes
      });
    }
  }

  void _confirmSelection() {
    if (selectedDate == null || selectedTimeSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona fecha y hora'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final result = {
      'deliveryType': 'pickup',
      'pickupDate': DateFormat('yyyy-MM-dd').format(selectedDate!),
      'pickupStartTime': selectedTimeSlot!.startTime,
      'pickupEndTime': selectedTimeSlot!.endTime,
    };

    context.pop(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar hora de recogida'),
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
                                    'Fecha de recogida',
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
                  Text(
                    'Horario de recogida',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  
                  if (selectedDate == null)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          children: [
                            Icon(
                              Icons.event_note,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Selecciona primero una fecha',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 2.5,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: availableTimeSlots.length,
                      itemBuilder: (context, index) {
                        final timeSlot = availableTimeSlots[index];
                        final isSelected = selectedTimeSlot == timeSlot;

                        return Material(
                          color: isSelected
                              ? Theme.of(context).primaryColor
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          elevation: isSelected ? 4 : 1,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                selectedTimeSlot = timeSlot;
                              });
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? Theme.of(context).primaryColor
                                      : Colors.grey[300]!,
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  timeSlot.label,
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : Colors.black87,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
          
          // Confirm Button
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: ElevatedButton(
                onPressed: _confirmSelection,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Continuar al pago',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeSlot &&
          runtimeType == other.runtimeType &&
          startTime == other.startTime &&
          endTime == other.endTime;

  @override
  int get hashCode => startTime.hashCode ^ endTime.hashCode;
}
