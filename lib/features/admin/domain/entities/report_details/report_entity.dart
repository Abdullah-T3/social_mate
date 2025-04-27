// lib/domain/entities/report_entity.dart

class ReportEntity {
  final String reason;
  final String categoryTitle;
  final String statusTitle;

  ReportEntity({
    required this.reason,
    required this.categoryTitle,
    required this.statusTitle,
  });
}