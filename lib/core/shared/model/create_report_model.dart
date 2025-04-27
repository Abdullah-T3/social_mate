// lib/features/admin/report_details/data/model/create_report_model.dart

import 'package:json_annotation/json_annotation.dart';

part 'create_report_model.g.dart';

@JsonSerializable()
class CreateReportModel {
  final int categoryId;
  final String reason;

  CreateReportModel({
    required this.categoryId,
    required this.reason,
  });

  factory CreateReportModel.fromJson(Map<String, dynamic> json) => _$CreateReportModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreateReportModelToJson(this);
}
