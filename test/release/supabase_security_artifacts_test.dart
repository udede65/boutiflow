import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Supabase RLS migration protects customer data tables', () {
    final migration =
        File('supabase/migrations/20260524_secure_rls_policies.sql')
            .readAsStringSync();

    expect(
      migration,
      contains("'alter table public.users enable row level security'"),
    );
    expect(
      migration,
      contains("'alter table public.%I enable row level security'"),
    );

    for (final table in const [
      'hotels',
      'rooms',
      'guests',
      'bookings',
      'expenses',
      'finances',
      'payments',
      'room_types',
      'guest_documents',
      'message_templates',
      'messages_log',
    ]) {
      expect(migration, contains("'$table'"));
    }

    expect(migration, contains('auth.uid()'));
    expect(migration, contains('boutiflow_owns_business_row'));
    expect(migration, contains('boutiflow_guard_user_plan_update'));
    expect(migration, contains("auth.role(), '') <> 'service_role'"));
    expect(migration, contains('plan can only be updated by service role'));
    expect(migration, isNot(contains('using (true)')));
    expect(migration, isNot(contains('to anon')));
  });

  test('RevenueCat webhook updates Supabase plan through service role only', () {
    final webhook =
        File('supabase/functions/revenuecat-webhook/index.ts').readAsStringSync();

    expect(webhook, contains('SUPABASE_SERVICE_ROLE_KEY'));
    expect(webhook, contains('REVENUECAT_WEBHOOK_AUTHORIZATION'));
    expect(webhook, contains('authorization'));
    expect(webhook, contains('app_user_id'));
    expect(webhook, contains('original_app_user_id'));
    expect(webhook, contains('aliases'));
    expect(webhook, contains('boutiflow_premium_monthly'));
    expect(webhook, contains('boutiflow_premium_yearly'));
    expect(webhook, contains("return 'premium'"));
    expect(webhook, contains("return 'free'"));
  });
}
