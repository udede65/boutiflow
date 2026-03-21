import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/providers.dart';
import '../../core/models/entities.dart';
import '../../core/localization/app_localizations.dart';
import '../../state/app_state.dart';
import '../../core/theme/neo_brutalist_theme.dart';

class RoomTypesPage extends ConsumerWidget {
  const RoomTypesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final roomTypesAsync = ref.watch(roomTypesProvider);
    final currencySymbol = getCurrencySymbol(
      ref.watch(appStateProvider).user?.currency ?? 'TRY',
    );

    return Scaffold(
      backgroundColor: NeoBrutalistTheme.cream,
      appBar: AppBar(
        backgroundColor: NeoBrutalistTheme.cream,
        foregroundColor: NeoBrutalistTheme.black,
        elevation: 0,
        title: Text(l10n.upper('roomTypesPageTitle'),
            style: NeoBrutalistTheme.titleLarge),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () => _showTypeDialog(context, ref, null),
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
      body: roomTypesAsync.when(
        data: (types) => types.isEmpty
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
                          const Icon(Icons.bedroom_parent_outlined,
                              size: 64, color: NeoBrutalistTheme.purple),
                          const SizedBox(height: 16),
                          Text(l10n.t('noRoomTypesYet'),
                              style: NeoBrutalistTheme.titleMedium),
                          const SizedBox(height: 8),
                          Text(l10n.t('tapPlusForRoomType'),
                              style: NeoBrutalistTheme.bodyMedium),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: types.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final type = types[index];
                  return NeoCard(
                    color: NeoBrutalistTheme.white,
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: NeoBrutalistTheme.cardDecoration(
                              NeoBrutalistTheme.purple),
                          child: const Icon(Icons.bedroom_parent_outlined,
                              color: NeoBrutalistTheme.white),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(type.name,
                                  style: NeoBrutalistTheme.titleMedium),
                              if (type.description != null &&
                                  type.description!.isNotEmpty)
                                Text(
                                  type.description!,
                                  style: NeoBrutalistTheme.bodyMedium
                                      .copyWith(color: NeoBrutalistTheme.grey),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: NeoBrutalistTheme.yellow,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: NeoBrutalistTheme.black, width: 2),
                              ),
                              child: Text(
                                '${type.price.toStringAsFixed(0)} $currencySymbol',
                                style: NeoBrutalistTheme.labelLarge,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap: () =>
                                      _showTypeDialog(context, ref, type),
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: NeoBrutalistTheme.blue,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Icon(Icons.edit_rounded,
                                        color: NeoBrutalistTheme.white,
                                        size: 16),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () =>
                                      _confirmDelete(context, ref, type),
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: NeoBrutalistTheme.red,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Icon(Icons.delete_rounded,
                                        color: NeoBrutalistTheme.white,
                                        size: 16),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
        loading: () => const Center(
            child: CircularProgressIndicator(color: NeoBrutalistTheme.black)),
        error: (e, s) => Center(
          child: Text(
            l10n.tf('errorWithMessage', {'error': e}),
            style: NeoBrutalistTheme.bodyLarge,
          ),
        ),
      ),
    );
  }

  void _showTypeDialog(BuildContext context, WidgetRef ref, RoomType? type) {
    final l10n = context.l10n;
    final nameController = TextEditingController(text: type?.name ?? '');
    final priceController =
        TextEditingController(text: type?.price.toStringAsFixed(0) ?? '');
    final descController = TextEditingController(text: type?.description ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: NeoBrutalistTheme.cream,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: NeoBrutalistTheme.black, width: 3),
        ),
        title: Text(
          type == null
              ? l10n.upper('roomTypeAddTitle')
              : l10n.upper('roomTypeEditTitle'),
          style: NeoBrutalistTheme.titleLarge,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              style: NeoBrutalistTheme.bodyLarge,
              decoration: _neoInputDecoration(
                  l10n.t('typeName'), l10n.t('typeNameHint')),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              style: NeoBrutalistTheme.bodyLarge,
              decoration: _neoInputDecoration(l10n.t('defaultPrice'), '0'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descController,
              style: NeoBrutalistTheme.bodyLarge,
              decoration: _neoInputDecoration(
                l10n.t('description'),
                l10n.t('optional'),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              l10n.upper('cancel'),
              style: NeoBrutalistTheme.labelLarge.copyWith(
                color: NeoBrutalistTheme.grey,
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              final name = nameController.text.trim();
              final price = double.tryParse(priceController.text.trim()) ?? 0.0;

              if (name.isNotEmpty) {
                try {
                  if (type == null) {
                    final hotelId =
                        ref.read(appStateProvider).user?.hotelId ?? '';
                    await ref.read(boutiFlowServiceProvider).createRoomType(
                          hotelId: hotelId,
                          name: name,
                          price: price,
                          description: descController.text.trim(),
                        );
                  } else {
                    await ref.read(boutiFlowServiceProvider).updateRoomType(
                          RoomType(
                            id: type.id,
                            name: name,
                            price: price,
                            description: descController.text.trim(),
                          ),
                        );
                  }
                  ref.invalidate(roomTypesProvider);
                  if (context.mounted) Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        l10n.tf('errorWithMessage', {'error': e}),
                      ),
                    ),
                  );
                }
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration:
                  NeoBrutalistTheme.cardDecoration(NeoBrutalistTheme.green),
              child: Text(
                l10n.upper('save'),
                style: NeoBrutalistTheme.labelLarge.copyWith(
                  color: NeoBrutalistTheme.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, RoomType type) {
    final l10n = context.l10n;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: NeoBrutalistTheme.cream,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: NeoBrutalistTheme.black, width: 3),
        ),
        title: Text(l10n.upper('deleteRoomTypeTitle'),
            style: NeoBrutalistTheme.titleLarge),
        content: Text(
          l10n.tf('deleteRoomTypeConfirmation', {'name': type.name}),
          style: NeoBrutalistTheme.bodyLarge,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              l10n.upper('cancel'),
              style: NeoBrutalistTheme.labelLarge.copyWith(
                color: NeoBrutalistTheme.grey,
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              try {
                await ref
                    .read(boutiFlowServiceProvider)
                    .deleteRoomType(type.id);
                ref.invalidate(roomTypesProvider);
                if (context.mounted) Navigator.pop(context);
              } catch (e) {
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        l10n.tf('errorWithMessage', {
                          'error': e.toString().replaceAll('Exception: ', '')
                        }),
                      ),
                    ),
                  );
                }
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration:
                  NeoBrutalistTheme.cardDecoration(NeoBrutalistTheme.red),
              child: Text(
                l10n.upper('delete'),
                style: NeoBrutalistTheme.labelLarge.copyWith(
                  color: NeoBrutalistTheme.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _neoInputDecoration(String label, String hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
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
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: NeoBrutalistTheme.blue, width: 3),
      ),
    );
  }
}
