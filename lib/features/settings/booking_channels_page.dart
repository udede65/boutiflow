import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/neo_brutalist_theme.dart';
import '../../services/providers.dart';
import '../../state/app_state.dart';

class BookingChannelsPage extends ConsumerStatefulWidget {
  const BookingChannelsPage({super.key});

  @override
  ConsumerState<BookingChannelsPage> createState() =>
      _BookingChannelsPageState();
}

class _BookingChannelsPageState extends ConsumerState<BookingChannelsPage> {
  final _nameController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _addChannel() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    setState(() => _isLoading = true);
    try {
      final user = ref.read(appStateProvider).user;
      if (user != null) {
        await ref.read(boutiFlowServiceProvider).createBookingChannel(
              hotelId: user.hotelId,
              name: name,
            );
        _nameController.clear();
        ref.invalidate(bookingChannelsProvider);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteChannel(String id) async {
    setState(() => _isLoading = true);
    try {
      await ref.read(boutiFlowServiceProvider).deleteBookingChannel(id);
      ref.invalidate(bookingChannelsProvider);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final channelsAsync = ref.watch(bookingChannelsProvider);

    return Scaffold(
      backgroundColor: NeoBrutalistTheme.cream,
      appBar: AppBar(
        backgroundColor: NeoBrutalistTheme.cream,
        foregroundColor: NeoBrutalistTheme.black,
        elevation: 0,
        leading: Navigator.of(context).canPop()
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: NeoBrutalistTheme.black),
                onPressed: () => context.pop(),
              )
            : null,
        title: Text(l10n.upper('bookingSources'),
            style: NeoBrutalistTheme.titleLarge),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NeoCard(
                color: NeoBrutalistTheme.white,
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: l10n.t('sourceNameHint'),
                          hintStyle: NeoBrutalistTheme.bodyMedium
                              .copyWith(color: NeoBrutalistTheme.grey),
                          border: InputBorder.none,
                        ),
                        style: NeoBrutalistTheme.bodyLarge,
                      ),
                    ),
                    GestureDetector(
                      onTap: _isLoading ? null : _addChannel,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: NeoBrutalistTheme.cardDecoration(
                            NeoBrutalistTheme.blue),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                    color: NeoBrutalistTheme.white,
                                    strokeWidth: 2))
                            : Text(l10n.upper('add'),
                                style: NeoBrutalistTheme.labelLarge
                                    .copyWith(color: NeoBrutalistTheme.white)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(l10n.upper('activeSources'),
                  style: NeoBrutalistTheme.titleMedium),
              const SizedBox(height: 12),
              Expanded(
                child: channelsAsync.when(
                  data: (channels) {
                    if (channels.isEmpty) {
                      return Center(child: Text(l10n.t('noSources')));
                    }
                    return ListView.separated(
                      itemCount: channels.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final channel = channels[index];
                        return NeoCard(
                          color: NeoBrutalistTheme.white,
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(channel.name,
                                  style: NeoBrutalistTheme.bodyLarge),
                              if (!channel.isDefault)
                                GestureDetector(
                                  onTap: () => _deleteChannel(channel.id),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: const BoxDecoration(
                                      color: NeoBrutalistTheme.red,
                                      shape: BoxShape.circle,
                                      border: Border.fromBorderSide(BorderSide(
                                          color: NeoBrutalistTheme.black,
                                          width: 2)),
                                    ),
                                    child: const Icon(Icons.close,
                                        size: 16,
                                        color: NeoBrutalistTheme.white),
                                  ),
                                )
                              else
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color:
                                        NeoBrutalistTheme.grey.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    l10n.t('systemDefault'),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: NeoBrutalistTheme.black,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  loading: () => const Center(
                      child: CircularProgressIndicator(
                          color: NeoBrutalistTheme.black)),
                  error: (error, stackTrace) =>
                      Center(child: Text(error.toString())),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
