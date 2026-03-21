import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../../core/widgets/premium_gate.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/models/entities.dart';
import '../../core/services/interstitial_ad_service.dart';
import '../../services/providers.dart';
import '../../providers/booking_providers.dart' show guestsProvider;
import 'presentation/providers/guest_providers.dart' show guestListProvider;
import '../../state/app_state.dart';
import '../../core/theme/neo_brutalist_theme.dart';

class GuestFormScreen extends ConsumerStatefulWidget {
  const GuestFormScreen({super.key, this.guestId});

  final String? guestId;

  @override
  ConsumerState<GuestFormScreen> createState() => _GuestFormScreenState();
}

class _GuestFormScreenState extends ConsumerState<GuestFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _notesController = TextEditingController();
  String _languageCode = 'en';
  double _totalSpent = 0.0;
  int _visitCount = 0;
  bool _isLoading = false;

  List<GuestDocument> _documents = [];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveGuest() async {
    final l10n = context.l10n;
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.t('nameRequired'))),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final service = ref.read(boutiFlowServiceProvider);
      final guest = Guest(
        id: widget.guestId ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        phone: _phoneController.text.isEmpty ? null : _phoneController.text,
        email: _emailController.text.isEmpty ? null : _emailController.text,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
        languageCode: _languageCode,
        visitCount: _visitCount,
        totalSpent: _totalSpent,
      );

      if (widget.guestId != null) {
        await service.updateGuest(guest);
      } else {
        final hotelId = ref.read(appStateProvider).user?.hotelId ?? '';
        await service.createGuest(
          hotelId: hotelId,
          id: guest.id,
          name: guest.name,
          languageCode: guest.languageCode,
          email: guest.email,
          phone: guest.phone,
          notes: guest.notes,
        );
      }

      // Invalidate the providers so that Booking Form and Guests Page update
      ref.invalidate(guestsProvider);
      ref.invalidate(guestListProvider);

      if (mounted) {
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

  Future<void> _loadGuest() async {
    try {
      final user = ref.read(appStateProvider).user;
      final hotelId = user?.hotelId ?? '';
      if (hotelId.isEmpty) return;

      final service = ref.read(boutiFlowServiceProvider);
      final guests = await service.fetchGuests(hotelId);
      final guest = guests.firstWhere((g) => g.id == widget.guestId);

      final docs = await service.fetchGuestDocuments(widget.guestId!);

      setState(() {
        _nameController.text = guest.name;
        _phoneController.text = guest.phone ?? '';
        _emailController.text = guest.email ?? '';
        _notesController.text = guest.notes ?? '';
        _languageCode = guest.languageCode;
        _totalSpent = guest.totalSpent;
        _visitCount = guest.visitCount;
        _documents = docs;
      });
    } catch (_) {}
  }

  Future<void> _pickDocument() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null && result.files.single.path != null) {
      setState(() => _isLoading = true);
      try {
        final sourceFile = File(result.files.single.path!);
        final appDir = await getApplicationDocumentsDirectory();
        final fileName =
            '${DateTime.now().millisecondsSinceEpoch}_${path.basename(sourceFile.path)}';
        final targetPath = path.join(appDir.path, 'guest_docs', fileName);

        await Directory(path.dirname(targetPath)).create(recursive: true);
        await sourceFile.copy(targetPath);

        await ref.read(boutiFlowServiceProvider).createGuestDocument(
              guestId: widget.guestId!,
              filePath: targetPath,
              description: 'ID Photo',
            );

        await _loadGuest();

        if (mounted) {
          final l10n = context.l10n;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.t('documentAdded'))),
          );
        }
      } catch (e) {
        if (mounted) {
          final l10n = context.l10n;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.tf('errorWithMessage', {'error': e}))),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _deleteDocument(String docId) async {
    try {
      await ref.read(boutiFlowServiceProvider).deleteGuestDocument(docId);
      await _loadGuest();
    } catch (e) {
      if (mounted) {
        final l10n = context.l10n;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.tf('errorWithMessage', {'error': e}))),
        );
      }
    }
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
        title: Text(
          widget.guestId == null
              ? l10n.upper('addGuest')
              : l10n.upper('editGuest'),
          style: NeoBrutalistTheme.titleLarge,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: _saveGuest,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration:
                    NeoBrutalistTheme.cardDecoration(NeoBrutalistTheme.green),
                child: Row(
                  children: [
                    const Icon(Icons.check_rounded,
                        color: NeoBrutalistTheme.white, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      l10n.upper('save'),
                      style: NeoBrutalistTheme.labelLarge
                          .copyWith(color: NeoBrutalistTheme.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: NeoBrutalistTheme.black))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Main Info Card
                  NeoCard(
                    color: NeoBrutalistTheme.white,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        TextField(
                          controller: _nameController,
                          style: NeoBrutalistTheme.bodyLarge,
                          decoration: _neoInputDecoration(l10n.t('name')),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _phoneController,
                          style: NeoBrutalistTheme.bodyLarge,
                          decoration: _neoInputDecoration(l10n.t('phone')),
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _emailController,
                          style: NeoBrutalistTheme.bodyLarge,
                          decoration: _neoInputDecoration(l10n.t('email')),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _notesController,
                          style: NeoBrutalistTheme.bodyLarge,
                          decoration: _neoInputDecoration(l10n.t('notes')),
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),

                  // Documents Section (only for edit mode)
                  if (widget.guestId != null) ...[
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(l10n.upper('documents'),
                            style: NeoBrutalistTheme.titleMedium),
                        PremiumGate(
                          message: l10n.t('guestDocumentsPremiumMessage'),
                          child: GestureDetector(
                            onTap: _pickDocument,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: NeoBrutalistTheme.cardDecoration(
                                  NeoBrutalistTheme.purple),
                              child: const Icon(Icons.add_a_photo_rounded,
                                  color: NeoBrutalistTheme.white, size: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (_documents.isEmpty)
                      NeoCard(
                        color: NeoBrutalistTheme.white,
                        padding: const EdgeInsets.all(24),
                        child: Center(
                          child: Text(
                            l10n.t('noDocumentsYet'),
                            style: NeoBrutalistTheme.bodyMedium
                                .copyWith(color: NeoBrutalistTheme.grey),
                          ),
                        ),
                      )
                    else
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: _documents.length,
                        itemBuilder: (context, index) {
                          final doc = _documents[index];
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: NeoBrutalistTheme.black, width: 2),
                            ),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    File(doc.filePath),
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const Center(
                                        child: Icon(Icons.broken_image,
                                            color: NeoBrutalistTheme.grey)),
                                  ),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: GestureDetector(
                                    onTap: () => _deleteDocument(doc.id),
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: NeoBrutalistTheme.red,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.close,
                                          size: 14,
                                          color: NeoBrutalistTheme.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                  ],
                ],
              ),
            ),
    );
  }
}
