import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eco_bocado/features/billing/data/datasources/billing_remote_datasource.dart';
import 'package:eco_bocado/features/billing/domain/entities/billing_record.dart';

final billingDataSourceProvider = Provider<BillingRemoteDataSource>((ref) {
  return BillingRemoteDataSource();
});

final billingRecordsProvider = FutureProvider<List<BillingRecord>>((ref) async {
  final dataSource = ref.watch(billingDataSourceProvider);
  final data = await dataSource.getAllBillingRecords();
  return data.map((json) => BillingRecord.fromJson(json)).toList();
});
