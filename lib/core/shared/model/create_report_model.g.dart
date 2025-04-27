// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateReportModel _$CreateReportModelFromJson(Map<String, dynamic> json) =>
    CreateReportModel(
      categoryId: (json['categoryId'] as num).toInt(),
      reason: json['reason'] as String,
    );

Map<String, dynamic> _$CreateReportModelToJson(CreateReportModel instance) =>
    <String, dynamic>{
      'categoryId': instance.categoryId,
      'reason': instance.reason,
    };
