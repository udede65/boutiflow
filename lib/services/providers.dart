import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'boutiflow_service.dart';
import 'backup_service.dart';
import 'cloud_sync_service.dart';
import 'supabase_auth_service.dart';

import '../providers/database_provider.dart';
import '../core/models/entities.dart' as entities;
import '../state/app_state.dart';

final boutiFlowServiceProvider = Provider<BoutiFlowService>((ref) {
  final db = ref.watch(databaseProvider);
  return BoutiFlowService(db);
});

final supabaseAuthServiceProvider = Provider<SupabaseAuthService>((ref) {
  return SupabaseAuthService();
});

final backupServiceProvider = Provider<BackupService>((ref) {
  final boutiFlowService = ref.watch(boutiFlowServiceProvider);
  return BackupService(boutiFlowService);
});

final cloudSyncServiceProvider = Provider<CloudSyncService>((ref) {
  final boutiFlowService = ref.watch(boutiFlowServiceProvider);
  return CloudSyncService(boutiFlowService);
});

final roomTypesProvider = FutureProvider<List<entities.RoomType>>((ref) async {
  final service = ref.watch(boutiFlowServiceProvider);
  return service.fetchRoomTypes();
});

final reportsProvider = FutureProvider<entities.ReportSummary>((ref) async {
  final user = ref.watch(appStateProvider).user;
  if (user == null) {
    return entities.ReportSummary(
      totalBookings: 0,
      totalRevenue: 0,
      occupancySeries: [],
      topGuests: [],
      monthlyRevenue: {},
      bookingSources: {},
      revenueByRoomType: {},
    );
  }
  final service = ref.watch(boutiFlowServiceProvider);
  return service.fetchReports(user.hotelId);
});
