import 'package:dio/dio.dart';
import '../../../../core/utils/app_services.dart';
import '../../domain/entities/loyalty_account.dart';
import '../../domain/entities/loyalty_redemption.dart';

class LoyaltyApiClient {
  final Dio _dio = AppServices.dio;

  Future<LoyaltyAccount> getLoyaltyAccount() async {
    final response = await _dio.get('/loyalty/account');
    return LoyaltyAccount.fromJson(response.data);
  }

  Future<LoyaltyRedemption> redeemReward(int rescueMenuId) async {
    final response = await _dio.post(
      '/loyalty/redeem',
      data: {'rescueMenuId': rescueMenuId},
    );
    return LoyaltyRedemption.fromJson(response.data);
  }
}
