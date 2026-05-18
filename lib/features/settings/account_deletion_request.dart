import '../../core/models/entities.dart';

const accountDeletionSupportEmail = 'support@boutiflow.com';

Uri buildAccountDeletionRequestUri(UserProfile user) {
  final subject = Uri.encodeComponent('BoutiFlow Account Deletion Request');
  final body = Uri.encodeComponent(
    [
      'Hello BoutiFlow Support,',
      '',
      'I want to request deletion of my BoutiFlow account and associated cloud-synced data.',
      '',
      'Account email: ${user.email}',
      'Hotel ID: ${user.hotelId}',
      'Hotel name: ${user.hotelName}',
      '',
      'Please confirm when the deletion process is complete.',
    ].join('\n'),
  );

  return Uri.parse(
    'mailto:$accountDeletionSupportEmail?subject=$subject&body=$body',
  );
}
