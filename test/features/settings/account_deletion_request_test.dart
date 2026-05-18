import 'package:flutter_test/flutter_test.dart';
import 'package:roompilot_flutter/core/models/entities.dart';
import 'package:roompilot_flutter/features/settings/account_deletion_request.dart';

void main() {
  test('buildAccountDeletionRequestUri includes account identifiers', () {
    final uri = buildAccountDeletionRequestUri(
      const UserProfile(
        email: 'owner@example.com',
        displayName: 'Owner',
        hotelId: 'hotel_123',
        hotelName: 'Bouti Hotel',
        languageCode: 'tr',
        plan: PlanType.free,
      ),
    );

    expect(uri.scheme, 'mailto');
    expect(uri.path, accountDeletionSupportEmail);
    expect(
      uri.queryParameters['subject'],
      'BoutiFlow Account Deletion Request',
    );
    expect(uri.queryParameters['body'], contains('owner@example.com'));
    expect(uri.queryParameters['body'], contains('hotel_123'));
    expect(uri.queryParameters['body'], contains('Bouti Hotel'));
  });
}
