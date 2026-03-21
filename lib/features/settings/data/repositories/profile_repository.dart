import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/profile_model.dart';

/// Repository for managing user profiles in Supabase.
class ProfileRepository {
  final SupabaseClient _client;

  ProfileRepository(this._client);

  static const String _tableName = 'profiles';

  /// Get the current user's profile
  Future<ProfileModel?> getProfile() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return null;

    final response = await _client
        .from(_tableName)
        .select()
        .eq('id', userId)
        .maybeSingle();

    if (response == null) return null;
    return ProfileModel.fromJson(response);
  }

  /// Update or insert (upsert) the current user's profile
  Future<ProfileModel?> upsertProfile(ProfileModel profile) async {
    final response = await _client
        .from(_tableName)
        .upsert(profile.toJson())
        .select()
        .single();

    return ProfileModel.fromJson(response);
  }

  /// Update specific fields of the profile
  Future<ProfileModel?> updateProfile({
    String? currencySymbol,
    String? appLanguage,
    String? subscriptionTier,
    DateTime? subscriptionEndDate,
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return null;

    final updates = <String, dynamic>{};
    if (currencySymbol != null) updates['currency_symbol'] = currencySymbol;
    if (appLanguage != null) updates['app_language'] = appLanguage;
    if (subscriptionTier != null) updates['subscription_tier'] = subscriptionTier;
    if (subscriptionEndDate != null) {
      updates['subscription_end_date'] = subscriptionEndDate.toIso8601String();
    }
    updates['updated_at'] = DateTime.now().toUtc().toIso8601String();

    if (updates.isEmpty) return getProfile();

    final response = await _client
        .from(_tableName)
        .update(updates)
        .eq('id', userId)
        .select()
        .single();

    return ProfileModel.fromJson(response);
  }
}
