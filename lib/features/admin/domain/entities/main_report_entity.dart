class MainReportEntity {
  final int reportId;
  final int postId;
  final String postTitle;
  final String reportedBy;
  final String reportedOn;
  final String status;
  final String category;
  final int total;

  const MainReportEntity( {
    required this.reportId,
    required this.postId, 
    required this.postTitle,
    required this.reportedBy,
    required this.reportedOn,
    required this.status,
    required this.category,
    required this.total,
  });
}
