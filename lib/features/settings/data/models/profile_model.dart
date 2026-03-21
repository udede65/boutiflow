import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_model.freezed.dart';
part 'profile_model.g.dart';

/// Profile model representing user/business settings from Supabase `profiles` table.
@freezed
abstract class ProfileModel with _$ProfileModel {
  const factory ProfileModel({
    required String id,
    @JsonKey(name: 'business_name') String? businessName,
    @JsonKey(name: 'currency_symbol') @Default('\$') String currencySymbol,
    @JsonKey(name: 'app_language') @Default('tr') String appLanguage,
    @JsonKey(name: 'subscription_tier') @Default('free') String subscriptionTier,
    @JsonKey(name: 'subscription_end_date') DateTime? subscriptionEndDate,
    @JsonKey(name: 'is_trial_used') @Default(false) bool isTrialUsed,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _ProfileModel;

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);
}
