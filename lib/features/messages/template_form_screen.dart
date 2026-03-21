import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/localization/app_localizations.dart';
import '../../services/providers.dart';
import '../../core/models/entities.dart';
import '../../state/app_state.dart';

class TemplateFormScreen extends ConsumerStatefulWidget {
  const TemplateFormScreen({super.key, this.templateId});

  final String? templateId;

  @override
  ConsumerState<TemplateFormScreen> createState() => _TemplateFormScreenState();
}

class _TemplateFormScreenState extends ConsumerState<TemplateFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  String _languageCode = 'en';
  bool _isLoading = false;
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit && widget.templateId != null) {
      _loadTemplate();
      _isInit = false;
    } else if (_isInit) {
      _languageCode = Localizations.localeOf(context).languageCode;
      _isInit = false;
    }
  }

  Future<void> _loadTemplate() async {
    try {
      final templates =
          await ref.read(boutiFlowServiceProvider).fetchTemplates();
      final template = templates.firstWhere((t) => t.id == widget.templateId);
      setState(() {
        _titleController.text = template.title;
        _bodyController.text = template.body;
        _languageCode = template.language;
      });
    } catch (_) {
      // Template not found
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = context.l10n;
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final service = ref.read(boutiFlowServiceProvider);

        if (widget.templateId != null) {
          // Update
          final templates = await service.fetchTemplates();
          final original =
              templates.firstWhere((t) => t.id == widget.templateId);

          // We need a copyWith on MessageTemplate entity, assuming it exists or we create a new one
          // Since entities are immutable, we should add copyWith to MessageTemplate if not present.
          // Checking entities.dart later. For now assuming we can pass updated fields to updateTemplate
          // actually updateTemplate takes an entity. I need to check if MessageTemplate has copyWith.
          // If not, I'll construct a new one.

          final updated = MessageTemplate(
            id: original.id,
            title: _titleController.text,
            body: _bodyController.text,
            language: _languageCode,
            isCustom: original.isCustom,
          );

          await service.updateTemplate(updated);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.t('templateUpdated'))),
            );
          }
        } else {
          // Create
          final hotelId = ref.read(appStateProvider).user?.hotelId ?? '';
          await service.createTemplate(
            hotelId: hotelId,
            title: _titleController.text,
            body: _bodyController.text,
            language: _languageCode,
          );
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.t('templateAdded'))),
            );
          }
        }

        if (mounted) {
          context.pop();
          // Invalidate provider to refresh list
          // ref.invalidate(templatesProvider); // Assuming templatesProvider is available globally or we rely on auto-refresh
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
  }

  Future<void> _delete() async {
    if (widget.templateId == null) return;
    final l10n = context.l10n;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.t('deleteTemplateTitle')),
        content: Text(l10n.t('deleteTemplateConfirmation')),
        actions: [
          TextButton(
            onPressed: () => context.pop(false),
            child: Text(l10n.t('cancel')),
          ),
          TextButton(
            onPressed: () => context.pop(true),
            child: Text(
              l10n.t('delete'),
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isLoading = true);
      try {
        await ref
            .read(boutiFlowServiceProvider)
            .deleteTemplate(widget.templateId!);
        if (mounted) {
          context.pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.tf('errorWithMessage', {'error': e}))),
          );
        }
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.templateId != null
            ? l10n.t('editTemplate')
            : l10n.t('addTemplate')),
        actions: [
          if (widget.templateId != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _isLoading ? null : _delete,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: l10n.t('templateTitle')),
                validator: (value) => value == null || value.isEmpty
                    ? l10n.t('templateTitleRequired')
                    : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _languageCode,
                decoration: InputDecoration(labelText: l10n.t('language')),
                items: ['en', 'tr', 'de', 'ru', 'fr', 'es'].map((code) {
                  return DropdownMenuItem(
                    value: code,
                    child: Text(code.toUpperCase()),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _languageCode = val!),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: TextFormField(
                  controller: _bodyController,
                  decoration: InputDecoration(
                    labelText: l10n.t('messageBody'),
                    alignLabelWithHint: true,
                    helperText: l10n.t('messagePlaceholdersHint'),
                  ),
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  validator: (value) => value == null || value.isEmpty
                      ? l10n.t('messageBodyRequired')
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isLoading ? null : _submit,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : Text(
                          widget.templateId != null
                              ? l10n.t('update')
                              : l10n.t('save'),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
