import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/paywall/paywall_page.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/models/entities.dart';
import '../../core/services/plan_limits.dart';
import '../../services/providers.dart';
import '../../state/app_state.dart';
import 'message_generation_screen.dart';

final templatesProvider = FutureProvider<List<MessageTemplate>>((ref) {
  final service = ref.watch(boutiFlowServiceProvider);
  return service.fetchTemplates();
});

final messageLogsProvider = FutureProvider<List<MessageLogEntry>>((ref) async {
  final service = ref.watch(boutiFlowServiceProvider);
  return service.fetchMessageLogs();
});

class MessagesPage extends ConsumerWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final templates = ref.watch(templatesProvider);
    final logs = ref.watch(messageLogsProvider);
    final l10n = context.l10n;
    final userPlan = ref.watch(appStateProvider).user?.plan ?? PlanType.free;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.t('generateMessage'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                final templateCount = templates.value?.length ?? 0;

                if (!PlanLimits.canAddTemplate(userPlan, templateCount)) {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const PaywallPage()),
                  );
                  return;
                }

                context.push('/messages/templates/add');
              },
              tooltip: 'Add Template',
            ),
          ],
        ),
        const SizedBox(height: 12),
        templates.when(
          data: (items) => Column(
            children: items
                .map(
                  (template) => Card(
                    child: ListTile(
                      title: Text(template.title),
                      subtitle: Text(
                        template.body,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () => _showTemplate(context, template),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, size: 20),
                            onPressed: () => context
                                .push('/messages/templates/${template.id}'),
                          ),
                          const Icon(Icons.arrow_forward_ios, size: 16),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          loading: () =>
              const Center(child: CircularProgressIndicator.adaptive()),
          error: (error, stackTrace) => Text(error.toString()),
        ),
        const SizedBox(height: 24),
        Text(
          l10n.t('messageLog'),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        logs.when(
          data: (items) => Column(
            children: items
                .map(
                  (log) => Card(
                    child: ListTile(
                      leading: const Icon(Icons.chat_bubble_outline),
                      title: Text(log.receiver),
                      subtitle: Text(log.preview),
                      trailing: Text(
                        '${log.sentAt.hour.toString().padLeft(2, '0')}:${log.sentAt.minute.toString().padLeft(2, '0')}',
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          loading: () =>
              const Center(child: CircularProgressIndicator.adaptive()),
          error: (error, stackTrace) => Text(error.toString()),
        ),
      ],
    );
  }

  void _showTemplate(BuildContext context, MessageTemplate template) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MessageGenerationScreen(template: template),
      ),
    );
  }
}
