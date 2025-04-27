// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main_report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MainReportModel _$MainReportModelFromJson(Map<String, dynamic> json) =>
    MainReportModel(
      data: (json['data'] as List<dynamic>)
          .map((e) => ReportData.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$MainReportModelToJson(MainReportModel instance) =>
    <String, dynamic>{
      'data': instance.data,
      'total': instance.total,
    };

ReportData _$ReportDataFromJson(Map<String, dynamic> json) => ReportData(
      id: (json['id'] as num).toInt(),
      post: Post.fromJson(json['post'] as Map<String, dynamic>?),
      createdBy: User.fromJson(json['createdBy'] as Map<String, dynamic>),
      category: Category.fromJson(json['category'] as Map<String, dynamic>),
      status: Status.fromJson(json['status'] as Map<String, dynamic>),
      createdOn: json['createdOn'] as String,
      lastModifiedOn: json['lastModifiedOn'] as String?,
      reason: json['reason'] as String?,
    );

Map<String, dynamic> _$ReportDataToJson(ReportData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'post': instance.post,
      'createdBy': instance.createdBy,
      'category': instance.category,
      'status': instance.status,
      'createdOn': instance.createdOn,
      'lastModifiedOn': instance.lastModifiedOn,
      'reason': instance.reason,
    };

Post _$PostFromJson(Map<String, dynamic> json) => Post(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      createdBy: User.fromJson(json['createdBy'] as Map<String, dynamic>),
      createdOn: json['createdOn'] as String,
      content: json['content'] as String,
    );

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'createdBy': instance.createdBy,
      'createdOn': instance.createdOn,
      'content': instance.content,
    };

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
      id: (json['id'] as num).toInt(),
      titleEn: json['titleEn'] as String,
    );

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'id': instance.id,
      'titleEn': instance.titleEn,
    };

Status _$StatusFromJson(Map<String, dynamic> json) => Status(
      id: (json['id'] as num).toInt(),
      titleEn: json['titleEn'] as String,
    );

Map<String, dynamic> _$StatusToJson(Status instance) => <String, dynamic>{
      'id': instance.id,
      'titleEn': instance.titleEn,
    };

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: (json['id'] as num).toInt(),
      fullName: json['fullName'] as String,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
    };

DetailedReportModel _$DetailedReportModelFromJson(Map<String, dynamic> json) =>
    DetailedReportModel(
      reportDetails:
          ReportDetails.fromJson(json['reportDetails'] as Map<String, dynamic>),
      relatedReports: (json['relatedReports'] as List<dynamic>)
          .map((e) => RelatedReport.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DetailedReportModelToJson(
        DetailedReportModel instance) =>
    <String, dynamic>{
      'reportDetails': instance.reportDetails,
      'relatedReports': instance.relatedReports,
    };

ReportDetails _$ReportDetailsFromJson(Map<String, dynamic> json) =>
    ReportDetails(
      createdBy: User.fromJson(json['createdBy'] as Map<String, dynamic>),
      reason: json['reason'] as String,
      category: Category.fromJson(json['category'] as Map<String, dynamic>),
      status: Status.fromJson(json['status'] as Map<String, dynamic>),
      lastModifiedBy:
          User.fromJson(json['lastModifiedBy'] as Map<String, dynamic>),
      createdOn: json['createdOn'] as String,
      lastModifiedOn: json['lastModifiedOn'] as String,
      post: Post.fromJson(json['post'] as Map<String, dynamic>?),
    );

Map<String, dynamic> _$ReportDetailsToJson(ReportDetails instance) =>
    <String, dynamic>{
      'createdBy': instance.createdBy,
      'reason': instance.reason,
      'category': instance.category,
      'status': instance.status,
      'lastModifiedBy': instance.lastModifiedBy,
      'createdOn': instance.createdOn,
      'lastModifiedOn': instance.lastModifiedOn,
      'post': instance.post,
    };

RelatedReport _$RelatedReportFromJson(Map<String, dynamic> json) =>
    RelatedReport(
      id: (json['id'] as num).toInt(),
      createdBy: User.fromJson(json['createdBy'] as Map<String, dynamic>),
      category: Category.fromJson(json['category'] as Map<String, dynamic>),
      status: Status.fromJson(json['status'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RelatedReportToJson(RelatedReport instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdBy': instance.createdBy,
      'category': instance.category,
      'status': instance.status,
    };
