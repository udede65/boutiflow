import 'package:flutter_test/flutter_test.dart';
import 'package:roompilot_flutter/services/cloud_sync_service.dart';

void main() {
  test('cloud restore reads the linked business id from auth metadata', () {
    expect(
      CloudSyncService.linkedHotelIdFromMetadata({
        'boutiflow_hotel_id': 'business_42',
        'display_name': 'Ferhat',
      }),
      'business_42',
    );

    expect(
      CloudSyncService.linkedHotelIdFromMetadata({
        'boutiflow_hotel_id': '   ',
      }),
      isNull,
    );
    expect(CloudSyncService.linkedHotelIdFromMetadata(null), isNull);
  });

  test('finance cloud rows only use business ids accepted by uuid columns', () {
    expect(
      CloudSyncService.supportsCloudFinanceForHotelId(
        '6b56012d-ad5e-4e8c-a739-c94e60d580d8',
      ),
      isTrue,
    );
    expect(
      CloudSyncService.supportsCloudFinanceForHotelId('1773776394909'),
      isFalse,
    );
  });

  test('cloud login restores full data only for premium access', () {
    expect(
      CloudSyncService.cloudRestoreModeForPremiumAccess(true),
      CloudRestoreMode.fullData,
    );
    expect(
      CloudSyncService.cloudRestoreModeForPremiumAccess(false),
      CloudRestoreMode.profileOnly,
    );
  });

  test('cloud user plan grants premium access only for the same business', () {
    expect(
      CloudSyncService.cloudPlanHasPremiumAccess(
        {'hotel_id': 'business_42', 'plan': 'premium'},
        'business_42',
      ),
      isTrue,
    );
    expect(
      CloudSyncService.cloudPlanHasPremiumAccess(
        {'hotel_id': 'business_42', 'plan': 'monthly'},
        'business_42',
      ),
      isTrue,
    );
    expect(
      CloudSyncService.cloudPlanHasPremiumAccess(
        {'hotel_id': 'other_business', 'plan': 'premium'},
        'business_42',
      ),
      isFalse,
    );
    expect(
      CloudSyncService.cloudPlanHasPremiumAccess(
        {'hotel_id': 'business_42', 'plan': 'free'},
        'business_42',
      ),
      isFalse,
    );
  });

  test('cloud hotel lookup only uses auth-scoped data', () {
    expect(
      CloudSyncService.cloudHotelIdFromAuthScope(
        metadata: {'boutiflow_hotel_id': 'business_42'},
        authUserId: 'auth_1',
      ),
      'business_42',
    );

    expect(
      CloudSyncService.cloudHotelIdFromAuthScope(
        authUserId: 'auth_1',
        hotelsByAuthUser: [
          {'id': 'business_from_hotel_table'},
        ],
      ),
      'business_from_hotel_table',
    );

    expect(
      CloudSyncService.cloudHotelIdFromAuthScope(
        authUserId: 'auth_1',
        legacyRowsByTable: {
          'guests': [
            {'id': 'guest_1', 'hotel_id': 'some_other_business'},
          ],
        },
      ),
      'auth_1',
    );

    expect(
      CloudSyncService.cloudHotelIdFromAuthScope(
        authUserId: null,
        hotelsByAuthUser: [
          {'id': 'should_not_be_used_without_auth'},
        ],
        legacyRowsByTable: {
          'rooms': [
            {'hotel_id': 'should_not_be_used_without_auth'},
          ],
        },
      ),
      isNull,
    );
  });

  test('cloud sync payloads include current auth user id when available', () {
    expect(
      CloudSyncService.cloudHotelPayload(
        hotelId: 'business_42',
        name: 'BoutiFlow',
        currency: 'TRY',
        languageCode: 'tr',
        checkInHour: '14:00',
        checkOutHour: '11:00',
        defaultRoomPrice: 3000,
        authUserId: 'auth_1',
        updatedAt: DateTime.utc(2026, 5, 24),
      ),
      containsPair('user_id', 'auth_1'),
    );

    expect(
      CloudSyncService.cloudGuestPayload(
        id: 'guest_1',
        hotelId: 'business_42',
        name: 'Zeynep',
        languageCode: 'tr',
        authUserId: 'auth_1',
        updatedAt: DateTime.utc(2026, 5, 24),
      ),
      allOf(
        containsPair('user_id', 'auth_1'),
        containsPair('hotel_id', 'business_42'),
        containsPair('full_name', 'Zeynep'),
        containsPair('language_code', 'tr'),
      ),
    );
  });

  test('cloud user payload does not overwrite existing premium plan', () {
    expect(
      CloudSyncService.cloudUserInsertPayload(
        authUserId: 'auth_1',
        email: 'owner@example.com',
        hotelId: 'business_42',
      ),
      {
        'id': 'auth_1',
        'email': 'owner@example.com',
        'password_hash': '',
        'role': 'owner',
        'hotel_id': 'business_42',
        'plan': 'free',
      },
    );

    expect(
      CloudSyncService.cloudUserUpdatePayload(
        email: 'owner@example.com',
        hotelId: 'business_42',
      ),
      isNot(contains('plan')),
    );
  });

  test('cloud restore reads legacy row fields from earlier Supabase schemas',
      () {
    expect(
      CloudSyncService.cloudGuestNameFromRow({'full_name': 'Zeynep'}),
      'Zeynep',
    );
    expect(
      CloudSyncService.cloudGuestLanguageFromRow({'language_code': 'tr'}),
      'tr',
    );
    expect(
      CloudSyncService.cloudGuestIdentityFromRow({'national_id': '123'}),
      '123',
    );
    expect(
      CloudSyncService.cloudBookingPriceFromRow({'total_price': 3000}),
      3000,
    );
  });
}
