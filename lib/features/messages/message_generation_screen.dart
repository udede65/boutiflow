import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/models/entities.dart';
import '../../services/providers.dart';
import '../../state/app_state.dart';

class MessageGenerationScreen extends ConsumerStatefulWidget {
  const MessageGenerationScreen({super.key, required this.template});

  final MessageTemplate template;

  @override
  ConsumerState<MessageGenerationScreen> createState() =>
      _MessageGenerationScreenState();
}

class _MessageGenerationScreenState
    extends ConsumerState<MessageGenerationScreen> {
  String? _selectedGuestId;
  String _generatedMessage = '';
  final TextEditingController _messageController = TextEditingController();
  List<Guest> _guests = [];
  bool _isLoadingGuests = true;

  @override
  void initState() {
    super.initState();
    _generatedMessage = widget.template.body;
    _messageController.text = _generatedMessage;
    _loadGuests();
  }

  Future<void> _loadGuests() async {
    try {
      final user = ref.read(appStateProvider).user;
      final hotelId = user?.hotelId ?? '';
      if (hotelId.isEmpty) {
        if (mounted) setState(() => _isLoadingGuests = false);
        return;
      }
      final guests =
          await ref.read(boutiFlowServiceProvider).fetchGuests(hotelId);
      if (mounted) {
        setState(() {
          _guests = guests;
          _isLoadingGuests = false;
        });
      }
    } catch (e) {
      // Handle error
      if (mounted) setState(() => _isLoadingGuests = false);
    }
  }

  void _generateMessage() {
    if (_selectedGuestId == null) return;

    final guest = _guests.firstWhere((g) => g.id == _selectedGuestId);
    final hotelName = ref.read(appStateProvider).user?.hotelName ?? 'BoutiFlow';

    String message = widget.template.body;
    message = message.replaceAll('{{guest_name}}', guest.name);
    message = message.replaceAll('{{hotel_name}}', hotelName);

    setState(() {
      _generatedMessage = message;
      _messageController.text = message;
    });
  }

  Future<void> _copyToClipboard() async {
    final l10n = context.l10n;
    await Clipboard.setData(ClipboardData(text: _messageController.text));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.t('copiedToClipboard'))),
      );
    }
  }

  Future<void> _sendViaWhatsapp() async {
    final l10n = context.l10n;
    if (_selectedGuestId == null) return;
    final guest = _guests.firstWhere((g) => g.id == _selectedGuestId);

    if (guest.phone == null || guest.phone!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.t('guestNoPhone'))),
      );
      return;
    }

    // Basic cleanup of phone number
    String phone = guest.phone!.replaceAll(RegExp(r'[^\d+]'), '');
    final message = Uri.encodeComponent(_messageController.text);
    final url = Uri.parse('https://wa.me/$phone?text=$message');

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.t('whatsappLaunchError'))),
        );
      }
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.template.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_isLoadingGuests)
              const LinearProgressIndicator()
            else
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: l10n.t('selectGuest'),
                  border: const OutlineInputBorder(),
                ),
                value: _selectedGuestId,
                items: _guests.map((g) {
                  return DropdownMenuItem(
                    value: g.id,
                    child: Text(g.name),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() => _selectedGuestId = val);
                  _generateMessage();
                },
              ),
            const SizedBox(height: 24),
            Expanded(
              child: TextField(
                controller: _messageController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  labelText: l10n.t('messagePreview'),
                  border: const OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _copyToClipboard,
                    icon: const Icon(Icons.copy),
                    label: Text(l10n.t('copy')),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FilledButton.icon(
                    onPressed:
                        _selectedGuestId != null ? _sendViaWhatsapp : null,
                    icon: const Icon(Icons.send), // WhatsApp icon ideally
                    label: Text(l10n.t('whatsapp')),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
