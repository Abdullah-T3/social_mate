import 'package:json_annotation/json_annotation.dart';

import '../../../../core/helper/format_time_ago.dart';
import '../../domain/entities/main_report_entity.dart';

part 'main_report_model.g.dart'; // Generated file for JsonSerializable

@JsonSerializable()
class MainReportModel {
  final List<ReportData> data;
  final int total;

  const MainReportModel({required this.data, required this.total});

  factory MainReportModel.fromJson(Map<String, dynamic> json) =>
      _$MainReportModelFromJson(json);

  Map<String, dynamic> toJson() => _$MainReportModelToJson(this);

  List<MainReportEntity> toReportEntities() {
    return data.map((reportData) {
      return MainReportEntity(
        reportId: reportData.id,
        postId: reportData.post.id,
        postTitle:
            reportData.post.title.isNotEmpty
                ? reportData.post.title
                : 'No Title',
        reportedBy:
            reportData.createdBy.fullName.isNotEmpty
                ? reportData.createdBy.fullName
                : 'Unknown',
        reportedOn: formatTimeAgo(reportData.createdOn),
        status:
            reportData.status.titleEn.isNotEmpty
                ? reportData.status.titleEn
                : 'Unknown',
        category:
            reportData.category.titleEn.isNotEmpty
                ? reportData.category.titleEn
                : 'Uncategorized',
        total: total,
      );
    }).toList();
  }
}

@JsonSerializable()
class ReportData {
  final int id;
  final Post post;
  final User createdBy;
  final Category category;
  final Status status;
  final String createdOn;
  final String? lastModifiedOn;
  final String? reason;

  const ReportData({
    required this.id,
    required this.post,
    required this.createdBy,
    required this.category,
    required this.status,
    required this.createdOn,
    required this.lastModifiedOn,
    required this.reason,
  });

  factory ReportData.fromJson(Map<String, dynamic> json) =>
      _$ReportDataFromJson(json);

  Map<String, dynamic> toJson() => _$ReportDataToJson(this);
}

@JsonSerializable()
class Post {
  final int id;
  final String title;
  final User createdBy;
  final String createdOn;
  final String content;

  const Post({
    required this.id,
    required this.title,
    required this.createdBy,
    required this.createdOn,
    required this.content,
  });

  factory Post.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Post(
        id: -1,
        title: 'No Title',
        createdBy: User(id: -1, fullName: 'Unknown'),
        createdOn: '',
        content: '',
      );
    }

    return Post(
      id: (json['id'] as num?)?.toInt() ?? -1,
      title: json['title'] as String? ?? 'No Title',
      createdBy:
          (json['createdBy'] as Map<String, dynamic>?) != null
              ? User.fromJson(json['createdBy'] as Map<String, dynamic>)
              : User(id: -1, fullName: 'Unknown'),
      createdOn: formatTimeAgo(json['createdOn'].toString()) as String? ?? '',
      content: json['content'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => _$PostToJson(this);
}

@JsonSerializable()
class Category {
  final int id;
  final String titleEn;

  const Category({required this.id, required this.titleEn});

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}

@JsonSerializable()
class Status {
  final int id;
  final String titleEn;

  const Status({required this.id, required this.titleEn});

  factory Status.fromJson(Map<String, dynamic> json) => _$StatusFromJson(json);

  Map<String, dynamic> toJson() => _$StatusToJson(this);
}

@JsonSerializable()
class User {
  final int id;
  final String fullName;

  const User({required this.id, required this.fullName});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

// Extended Model for Detailed Report Information
@JsonSerializable()
class DetailedReportModel {
  final ReportDetails reportDetails;
  final List<RelatedReport> relatedReports;

  const DetailedReportModel({
    required this.reportDetails,
    required this.relatedReports,
  });

  factory DetailedReportModel.fromJson(Map<String, dynamic> json) {
    final post =
        (json['post'] as Map<String, dynamic>?) != null
            ? Post.fromJson(json['post'] as Map<String, dynamic>)
            : Post(
              id: -1,
              title: 'No Title',
              createdBy: User(id: -1, fullName: 'Unknown'),
              createdOn: '',
              content: '',
            );

    return DetailedReportModel(
      reportDetails: ReportDetails(
        createdBy:
            (json['reportDetails']['createdBy'] as Map<String, dynamic>?) !=
                    null
                ? User.fromJson(
                  json['reportDetails']['createdBy'] as Map<String, dynamic>,
                )
                : User(id: -1, fullName: 'Unknown'),
        reason: json['reportDetails']['reason'] as String? ?? 'No Reason',
        category:
            (json['reportDetails']['category'] as Map<String, dynamic>?) != null
                ? Category.fromJson(
                  json['reportDetails']['category'] as Map<String, dynamic>,
                )
                : Category(id: -1, titleEn: 'Uncategorized'),
        status:
            (json['reportDetails']['status'] as Map<String, dynamic>?) != null
                ? Status.fromJson(
                  json['reportDetails']['status'] as Map<String, dynamic>,
                )
                : Status(id: -1, titleEn: 'Unknown'),
        lastModifiedBy:
            (json['reportDetails']['lastModifiedBy']
                        as Map<String, dynamic>?) !=
                    null
                ? User.fromJson(
                  json['reportDetails']['lastModifiedBy']
                      as Map<String, dynamic>,
                )
                : User(id: -1, fullName: ''),
        createdOn: formatTimeAgo(json['reportDetails']['createdOn'].toString()),
        lastModifiedOn:
            json['reportDetails']['lastModifiedOn'] as String? ?? '',
        post: post,
      ),
      relatedReports: List<RelatedReport>.from(
        (json['relatedReports'] as List<dynamic>? ?? []).map(
          (item) => RelatedReport.fromJson(item as Map<String, dynamic>),
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() => _$DetailedReportModelToJson(this);
}

@JsonSerializable()
class ReportDetails {
  final User createdBy;
  final String reason;
  final Category category;
  final Status status;
  final User lastModifiedBy;
  final String createdOn;
  final String lastModifiedOn;
  final Post post;

  const ReportDetails({
    required this.createdBy,
    required this.reason,
    required this.category,
    required this.status,
    required this.lastModifiedBy,
    required this.createdOn,
    required this.lastModifiedOn,
    required this.post,
  });

  factory ReportDetails.fromJson(Map<String, dynamic> json) {
    return ReportDetails(
      createdBy:
          (json['createdBy'] as Map<String, dynamic>?) != null
              ? User.fromJson(json['createdBy'] as Map<String, dynamic>)
              : User(id: -1, fullName: 'Unknown'),
      reason: json['reason'] as String? ?? 'No Reason',
      category:
          (json['category'] as Map<String, dynamic>?) != null
              ? Category.fromJson(json['category'] as Map<String, dynamic>)
              : Category(id: -1, titleEn: 'Uncategorized'),
      status:
          (json['status'] as Map<String, dynamic>?) != null
              ? Status.fromJson(json['status'] as Map<String, dynamic>)
              : Status(id: -1, titleEn: 'Unknown'),
      lastModifiedBy:
          (json['lastModifiedBy'] as Map<String, dynamic>?) != null
              ? User.fromJson(json['lastModifiedBy'] as Map<String, dynamic>)
              : User(id: -1, fullName: ''),
      createdOn: formatTimeAgo(json['createdOn'].toString()),
      lastModifiedOn: formatTimeAgo(json['lastModifiedOn'].toString()),
      post:
          (json['post'] as Map<String, dynamic>?) != null
              ? Post.fromJson(json['post'] as Map<String, dynamic>)
              : Post(
                id: -1,
                title: 'No Title',
                createdBy: User(id: -1, fullName: 'Unknown'),
                createdOn: '',
                content: '',
              ),
    );
  }
  Map<String, dynamic> toJson() => _$ReportDetailsToJson(this);
}

@JsonSerializable()
class RelatedReport {
  final int id;
  final User createdBy;
  final Category category;
  final Status status;

  const RelatedReport({
    required this.id,
    required this.createdBy,
    required this.category,
    required this.status,
  });

  factory RelatedReport.fromJson(Map<String, dynamic> json) =>
      _$RelatedReportFromJson(json);

  Map<String, dynamic> toJson() => _$RelatedReportToJson(this);
}
