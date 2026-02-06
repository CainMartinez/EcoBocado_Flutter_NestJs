import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/loyalty_api_client.dart';
import '../../domain/entities/loyalty_account.dart';
import '../../domain/entities/loyalty_redemption.dart';

final loyaltyApiClientProvider = Provider<LoyaltyApiClient>((ref) {
  return LoyaltyApiClient();
});

final loyaltyAccountProvider = FutureProvider<LoyaltyAccount>((ref) async {
  final apiClient = ref.watch(loyaltyApiClientProvider);
  return await apiClient.getLoyaltyAccount();
});

final redeemRewardProvider = FutureProvider.family<LoyaltyRedemption, int>(
  (ref, rescueMenuId) async {
    final apiClient = ref.watch(loyaltyApiClientProvider);
    return await apiClient.redeemReward(rescueMenuId);
  },
);
