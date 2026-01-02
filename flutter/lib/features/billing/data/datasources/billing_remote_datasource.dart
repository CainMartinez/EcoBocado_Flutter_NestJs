import 'package:eco_bocado/core/utils/app_services.dart';

class BillingRemoteDataSource {
  Future<List<dynamic>> getAllBillingRecords() async {
    final response = await AppServices.dio.get('/admin/billing');
    return response.data as List<dynamic>;
  }
}
