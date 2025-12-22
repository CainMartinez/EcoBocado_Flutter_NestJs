import 'package:dio/dio.dart';
import '../../../../core/utils/app_services.dart';
import '../../domain/entities/pickup_slot.dart';

class PickupSlotsApiClient {
  final Dio _dio = AppServices.dio;

  Future<List<PickupSlot>> getAvailableSlots({
    String? startDate,
    String? endDate,
  }) async {
    final queryParams = <String, dynamic>{};
    if (startDate != null) queryParams['startDate'] = startDate;
    if (endDate != null) queryParams['endDate'] = endDate;

    final response = await _dio.get(
      '/pickup-slots/available',
      queryParameters: queryParams,
    );

    final List<dynamic> data = response.data as List<dynamic>;
    return data.map((json) => PickupSlot.fromJson(json as Map<String, dynamic>)).toList();
  }
}
