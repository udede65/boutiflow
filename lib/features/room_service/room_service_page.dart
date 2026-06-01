import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/models/entities.dart';
import '../../core/theme/neo_brutalist_theme.dart';
import '../../services/providers.dart';
import '../../state/app_state.dart';
import '../../providers/booking_providers.dart';

class RoomServicePage extends ConsumerWidget {
  const RoomServicePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final ordersAsync = ref.watch(roomServiceOrdersProvider);
    final currencySymbol = getCurrencySymbol(
      ref.watch(appStateProvider).user?.currency ?? 'TRY',
    );

    return Scaffold(
      backgroundColor: NeoBrutalistTheme.cream,
      appBar: AppBar(
        leading: BackButton(color: NeoBrutalistTheme.black),
        backgroundColor: NeoBrutalistTheme.cream,
        foregroundColor: NeoBrutalistTheme.black,
        elevation: 0,
        title: Text(l10n.upper('roomService'),
            style: NeoBrutalistTheme.titleLarge),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () =>
                  _showAddOrderDialog(context, ref, l10n, currencySymbol),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration:
                    NeoBrutalistTheme.cardDecoration(NeoBrutalistTheme.green),
                child: const Icon(Icons.add_rounded,
                    color: NeoBrutalistTheme.white, size: 24),
              ),
            ),
          ),
        ],
      ),
      body: ordersAsync.when(
        data: (orders) => orders.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: NeoBrutalistTheme.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: NeoBrutalistTheme.black, width: 2),
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.room_service_outlined,
                              size: 64, color: NeoBrutalistTheme.grey),
                          const SizedBox(height: 12),
                          Text(l10n.t('noOrdersYet'),
                              style: NeoBrutalistTheme.titleMedium),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return _OrderCard(
                    order: order,
                    currencySymbol: currencySymbol,
                    l10n: l10n,
                    onStatusChange: (newStatus) async {
                      final service = ref.read(boutiFlowServiceProvider);
                      await service.updateRoomServiceStatus(
                          order.id, newStatus);
                      ref.invalidate(roomServiceOrdersProvider);
                    },
                    onDelete: () async {
                      final service = ref.read(boutiFlowServiceProvider);
                      await service.deleteRoomServiceOrder(order.id);
                      ref.invalidate(roomServiceOrdersProvider);
                    },
                  );
                },
              ),
        loading: () => const Center(
            child: CircularProgressIndicator(color: NeoBrutalistTheme.black)),
        error: (e, _) =>
            Center(child: Text(l10n.tf('errorWithMessage', {'error': e}))),
      ),
    );
  }

  void _showAddOrderDialog(BuildContext context, WidgetRef ref,
      AppLocalizations l10n, String currencySymbol) {
    final itemController = TextEditingController();
    final qtyController = TextEditingController(text: '1');
    final priceController = TextEditingController(text: '0');
    final notesController = TextEditingController();
    String? selectedRoomId;

    final roomsAsync = ref.read(roomsProvider);
    final rooms = roomsAsync.value ?? [];

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: NeoBrutalistTheme.cream,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: NeoBrutalistTheme.black, width: 3),
        ),
        title:
            Text(l10n.upper('newOrder'), style: NeoBrutalistTheme.titleLarge),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedRoomId,
                dropdownColor: NeoBrutalistTheme.white,
                style: NeoBrutalistTheme.bodyLarge,
                decoration: _neoInputDecoration(l10n.t('selectRoom')),
                items: rooms
                    .map((r) =>
                        DropdownMenuItem(value: r.id, child: Text(r.name)))
                    .toList(),
                onChanged: (val) => selectedRoomId = val,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: itemController,
                style: NeoBrutalistTheme.bodyLarge,
                decoration: _neoInputDecoration(l10n.t('itemName')),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: qtyController,
                      style: NeoBrutalistTheme.bodyLarge,
                      decoration: _neoInputDecoration(l10n.t('quantity')),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: priceController,
                      style: NeoBrutalistTheme.bodyLarge,
                      decoration: _neoInputDecoration(
                          '${l10n.t('orderPrice')} ($currencySymbol)'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: notesController,
                style: NeoBrutalistTheme.bodyLarge,
                decoration: _neoInputDecoration(l10n.t('orderNotes')),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.upper('cancel'),
                style: NeoBrutalistTheme.labelLarge
                    .copyWith(color: NeoBrutalistTheme.grey)),
          ),
          GestureDetector(
            onTap: () async {
              if (selectedRoomId == null || itemController.text.isEmpty) return;
              final hotelId = ref.read(appStateProvider).user?.hotelId ?? '';
              await ref.read(boutiFlowServiceProvider).createRoomServiceOrder(
                    hotelId: hotelId,
                    roomId: selectedRoomId!,
                    itemName: itemController.text,
                    quantity: int.tryParse(qtyController.text) ?? 1,
                    price: double.tryParse(priceController.text) ?? 0,
                    notes: notesController.text.isEmpty
                        ? null
                        : notesController.text,
                  );
              ref.invalidate(roomServiceOrdersProvider);
              if (ctx.mounted) Navigator.pop(ctx);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.t('orderCreated'))),
                );
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration:
                  NeoBrutalistTheme.cardDecoration(NeoBrutalistTheme.green),
              child: Text(l10n.upper('save'),
                  style: NeoBrutalistTheme.labelLarge
                      .copyWith(color: NeoBrutalistTheme.white)),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _neoInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: NeoBrutalistTheme.bodyMedium,
      filled: true,
      fillColor: NeoBrutalistTheme.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: NeoBrutalistTheme.black, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: NeoBrutalistTheme.black, width: 2),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final RoomServiceOrder order;
  final String currencySymbol;
  final AppLocalizations l10n;
  final Function(String) onStatusChange;
  final VoidCallback onDelete;

  const _OrderCard({
    required this.order,
    required this.currencySymbol,
    required this.l10n,
    required this.onStatusChange,
    required this.onDelete,
  });

  Color _statusColor(RoomServiceStatus status) {
    switch (status) {
      case RoomServiceStatus.pending:
        return NeoBrutalistTheme.yellow;
      case RoomServiceStatus.preparing:
        return NeoBrutalistTheme.orange;
      case RoomServiceStatus.delivered:
        return NeoBrutalistTheme.green;
      case RoomServiceStatus.cancelled:
        return NeoBrutalistTheme.pink;
    }
  }

  String _statusLabel(RoomServiceStatus status) {
    switch (status) {
      case RoomServiceStatus.pending:
        return l10n.t('statusPending');
      case RoomServiceStatus.preparing:
        return l10n.t('statusPreparing');
      case RoomServiceStatus.delivered:
        return l10n.t('statusDelivered');
      case RoomServiceStatus.cancelled:
        return l10n.t('statusCancelled');
    }
  }

  @override
  Widget build(BuildContext context) {
    final timeStr = DateFormat('HH:mm').format(order.createdAt);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: NeoCard(
        color: _statusColor(order.status),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(order.itemName,
                      style: NeoBrutalistTheme.titleMedium),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: NeoBrutalistTheme.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _statusLabel(order.status),
                    style: NeoBrutalistTheme.labelSmall
                        .copyWith(color: NeoBrutalistTheme.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.access_time_rounded,
                    size: 16, color: NeoBrutalistTheme.black),
                const SizedBox(width: 4),
                Text(timeStr, style: NeoBrutalistTheme.bodyMedium),
                const SizedBox(width: 16),
                Text('x${order.quantity}',
                    style: NeoBrutalistTheme.bodyMedium
                        .copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(width: 16),
                Text(
                    '${(order.price * order.quantity).toStringAsFixed(0)}$currencySymbol',
                    style: NeoBrutalistTheme.titleMedium),
              ],
            ),
            if (order.notes != null && order.notes!.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(order.notes!, style: NeoBrutalistTheme.bodySmall),
            ],
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (order.status == RoomServiceStatus.pending) ...[
                  _ActionChip(
                    label: l10n.t('statusPreparing'),
                    color: NeoBrutalistTheme.orange,
                    onTap: () => onStatusChange('preparing'),
                  ),
                  const SizedBox(width: 8),
                ],
                if (order.status == RoomServiceStatus.preparing)
                  _ActionChip(
                    label: l10n.t('statusDelivered'),
                    color: NeoBrutalistTheme.green,
                    onTap: () => onStatusChange('delivered'),
                  ),
                if (order.status != RoomServiceStatus.delivered &&
                    order.status != RoomServiceStatus.cancelled) ...[
                  const SizedBox(width: 8),
                  _ActionChip(
                    label: l10n.t('statusCancelled'),
                    color: NeoBrutalistTheme.pink,
                    onTap: () => onStatusChange('cancelled'),
                  ),
                ],
                if (order.status == RoomServiceStatus.delivered ||
                    order.status == RoomServiceStatus.cancelled) ...[
                  _ActionChip(
                    label: '🗑',
                    color: NeoBrutalistTheme.pink,
                    onTap: onDelete,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionChip(
      {required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: NeoBrutalistTheme.black, width: 2),
          boxShadow: const [
            BoxShadow(color: NeoBrutalistTheme.black, offset: Offset(2, 2))
          ],
        ),
        child: Text(label,
            style: NeoBrutalistTheme.labelSmall
                .copyWith(color: NeoBrutalistTheme.white)),
      ),
    );
  }
}
