// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProfileModel _$ProfileModelFromJson(Map<String, dynamic> json) =>
    _ProfileModel(
      id: json['id'] as String,
      businessName: json['business_name'] as String?,
      currencySymbol: json['currency_symbol'] as String? ?? '\$',
      appLanguage: json['app_language'] as String? ?? 'tr',
      subscriptionTier: json['subscription_tier'] as String? ?? 'free',
      subscriptionEndDate: json['subscription_end_date'] == null
          ? null
          : DateTime.parse(json['subscription_end_date'] as String),
      isTrialUsed: json['is_trial_used'] as bool? ?? false,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$ProfileModelToJson(_ProfileModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'business_name': instance.businessName,
      'currency_symbol': instance.currencySymbol,
      'app_language': instance.appLanguage,
      'subscription_tier': instance.subscriptionTier,
      'subscription_end_date': instance.subscriptionEndDate?.toIso8601String(),
      'is_trial_used': instance.isTrialUsed,
      'created_at': instance.createdAt?.toIso8601String(),
    };
