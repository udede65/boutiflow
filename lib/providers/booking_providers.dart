import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/models/entities.dart';
import '../services/providers.dart';
import '../state/app_state.dart';

final bookingsProvider = FutureProvider<List<Booking>>((ref) {
  final user = ref.watch(appStateProvider).user;
  if (user == null) return <Booking>[];
  final service = ref.watch(boutiFlowServiceProvider);
  return service.fetchBookings(user.hotelId);
});

final roomsProvider = FutureProvider<List<Room>>((ref) {
  final user = ref.watch(appStateProvider).user;
  if (user == null) return <Room>[];
  final service = ref.watch(boutiFlowServiceProvider);
  return service.fetchRooms(user.hotelId);
});

final dashboardProvider = FutureProvider.autoDispose<DashboardSummary>((ref) {
  final user = ref.watch(appStateProvider).user;
  if (user == null) {
    return DashboardSummary(
      todayCheckIns: [],
      todayCheckOuts: [],
      occupancy: 0,
      upcoming: [],
    );
  }
  final service = ref.watch(boutiFlowServiceProvider);
  return service.fetchDashboard(user.hotelId);
});

final guestsProvider = FutureProvider<List<Guest>>((ref) {
  final user = ref.watch(appStateProvider).user;
  if (user == null) return <Guest>[];
  final service = ref.watch(boutiFlowServiceProvider);
  return service.fetchGuests(user.hotelId);
});

final roomServiceOrdersProvider = FutureProvider<List<RoomServiceOrder>>((ref) {
  final user = ref.watch(appStateProvider).user;
  if (user == null) return <RoomServiceOrder>[];
  final service = ref.watch(boutiFlowServiceProvider);
  return service.fetchRoomServiceOrders(user.hotelId);
});
