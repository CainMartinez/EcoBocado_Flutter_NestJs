import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/pickup_slots_api_client.dart';
import '../../domain/entities/pickup_slot.dart';

final pickupSlotsApiClientProvider = Provider<PickupSlotsApiClient>((ref) {
  return PickupSlotsApiClient();
});

final availablePickupSlotsProvider = FutureProvider<List<PickupSlot>>((ref) async {
  final client = ref.read(pickupSlotsApiClientProvider);
  return await client.getAvailableSlots();
});
