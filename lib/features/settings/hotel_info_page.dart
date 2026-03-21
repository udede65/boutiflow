import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../services/providers.dart';
import '../../state/app_state.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/neo_brutalist_theme.dart';

class HotelInfoPage extends ConsumerStatefulWidget {
  const HotelInfoPage({super.key});

  @override
  ConsumerState<HotelInfoPage> createState() => _HotelInfoPageState();
}

class _HotelInfoPageState extends ConsumerState<HotelInfoPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _checkInController;
  late TextEditingController _checkOutController;
  late TextEditingController _priceController;
  String _selectedCurrency = 'TRY';
  bool _isLoading = false;
  bool _isLoadingData = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _checkInController = TextEditingController();
    _checkOutController = TextEditingController();
    _priceController = TextEditingController();
    _loadHotelData();
  }

  Future<void> _loadHotelData() async {
    try {
      final hotel = await ref.read(boutiFlowServiceProvider).getHotel();
      if (hotel != null && mounted) {
        setState(() {
          _nameController.text = hotel['name'] ?? '';
          _checkInController.text = hotel['checkInHour'] ?? '14:00';
          _checkOutController.text = hotel['checkOutHour'] ?? '11:00';
          _priceController.text =
              (hotel['defaultRoomPrice'] ?? 0.0).toStringAsFixed(0);
          _selectedCurrency = hotel['currency'] ?? 'TRY';
          _isLoadingData = false;
        });
      } else {
        // Fallback to appStateProvider
        final user = ref.read(appStateProvider).user;
        if (mounted) {
          setState(() {
            _nameController.text = user?.hotelName ?? '';
            _checkInController.text = user?.checkInHour ?? '14:00';
            _checkOutController.text = user?.checkOutHour ?? '11:00';
            _priceController.text =
                user?.defaultRoomPrice.toStringAsFixed(0) ?? '0';
            _selectedCurrency = user?.currency ?? 'TRY';
            _isLoadingData = false;
          });
        }
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingData = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _checkInController.dispose();
    _checkOutController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = context.l10n;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final parsedDefaultPrice =
        double.tryParse(_priceController.text.trim()) ?? 0.0;

    try {
      final user = ref.read(appStateProvider).user;
      if (user != null) {
        await ref.read(boutiFlowServiceProvider).updateHotelProfile(
              name: _nameController.text.trim(),
              languageCode: user.languageCode,
              currency: _selectedCurrency,
              checkInHour: _checkInController.text.trim(),
              checkOutHour: _checkOutController.text.trim(),
              defaultRoomPrice: parsedDefaultPrice,
            );
        ref.read(appStateProvider.notifier).updateUserProfile(
              user.copyWith(
                currency: _selectedCurrency,
                checkInHour: _checkInController.text.trim(),
                checkOutHour: _checkOutController.text.trim(),
                defaultRoomPrice: parsedDefaultPrice,
              ),
            );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.t('hotelInfoUpdated'))),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.tf('errorWithMessage', {'error': e}))),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  InputDecoration _neoInputDecoration(String label, {String? hint}) {
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

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: NeoBrutalistTheme.cream,
      appBar: AppBar(
        backgroundColor: NeoBrutalistTheme.cream,
        foregroundColor: NeoBrutalistTheme.black,
        elevation: 0,
        title: Text(l10n.upper('hotelInfoPageTitle'),
            style: NeoBrutalistTheme.titleLarge),
      ),
      body: _isLoadingData
          ? const Center(
              child: CircularProgressIndicator(color: NeoBrutalistTheme.black),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hotel Name Card
                    NeoCard(
                      color: NeoBrutalistTheme.white,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.upper('hotelName'),
                              style: NeoBrutalistTheme.labelLarge),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _nameController,
                            style: NeoBrutalistTheme.bodyLarge,
                            decoration:
                                _neoInputDecoration(l10n.t('hotelName')),
                            validator: (v) => v?.isEmpty == true
                                ? l10n.t('requiredField')
                                : null,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Currency Card
                    NeoCard(
                      color: NeoBrutalistTheme.white,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.upper('currency'),
                              style: NeoBrutalistTheme.labelLarge),
                          const SizedBox(height: 12),
                          DropdownButtonFormField<String>(
                            value: _selectedCurrency,
                            style: NeoBrutalistTheme.bodyLarge,
                            decoration: _neoInputDecoration(l10n.t('currency')),
                            items: [
                              _currencyItem('TRY', '₺'),
                              _currencyItem('EUR', '€'),
                              _currencyItem('USD', '\$'),
                              _currencyItem('GBP', '£'),
                              _currencyItem('RUB', '₽'),
                            ],
                            onChanged: (val) {
                              if (val != null)
                                setState(() => _selectedCurrency = val);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Check-in/out Card
                    NeoCard(
                      color: NeoBrutalistTheme.white,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.upper('checkInOutHours'),
                              style: NeoBrutalistTheme.labelLarge),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: NeoBrutalistTheme.blue,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                            color: NeoBrutalistTheme.black,
                                            width: 2),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.login_rounded,
                                              color: NeoBrutalistTheme.white,
                                              size: 18),
                                          const SizedBox(width: 8),
                                          Text(l10n.upper('checkInLabel'),
                                              style: NeoBrutalistTheme
                                                  .labelLarge
                                                  .copyWith(
                                                      color: NeoBrutalistTheme
                                                          .white,
                                                      fontSize: 11)),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    TextFormField(
                                      controller: _checkInController,
                                      style: NeoBrutalistTheme.bodyLarge,
                                      decoration: _neoInputDecoration('',
                                          hint: '14:00'),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: NeoBrutalistTheme.red,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                            color: NeoBrutalistTheme.black,
                                            width: 2),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.logout_rounded,
                                              color: NeoBrutalistTheme.white,
                                              size: 18),
                                          const SizedBox(width: 8),
                                          Text(l10n.upper('checkOutLabel'),
                                              style: NeoBrutalistTheme
                                                  .labelLarge
                                                  .copyWith(
                                                      color: NeoBrutalistTheme
                                                          .white,
                                                      fontSize: 11)),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    TextFormField(
                                      controller: _checkOutController,
                                      style: NeoBrutalistTheme.bodyLarge,
                                      decoration: _neoInputDecoration('',
                                          hint: '11:00'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Default Price Card
                    NeoCard(
                      color: NeoBrutalistTheme.white,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.upper('defaultRoomPrice'),
                              style: NeoBrutalistTheme.labelLarge),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _priceController,
                            keyboardType: TextInputType.number,
                            style: NeoBrutalistTheme.bodyLarge,
                            decoration: _neoInputDecoration(
                                l10n.t('defaultPrice'),
                                hint: '0'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Save Button
                    GestureDetector(
                      onTap: _isLoading ? null : _save,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: NeoBrutalistTheme.cardDecoration(
                          _isLoading
                              ? NeoBrutalistTheme.grey
                              : NeoBrutalistTheme.green,
                        ),
                        child: Center(
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: NeoBrutalistTheme.white)
                              : Text(
                                  l10n.upper('save'),
                                  style: NeoBrutalistTheme.titleMedium
                                      .copyWith(color: NeoBrutalistTheme.white),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
    );
  }

  DropdownMenuItem<String> _currencyItem(String code, String symbol) {
    return DropdownMenuItem(
      value: code,
      child: Text('$code ($symbol)'),
    );
  }
}
