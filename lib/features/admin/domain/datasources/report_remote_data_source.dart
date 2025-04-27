import '../../data/models/main_report_model.dart';

abstract class ReportDetailsRemoteDataSource {
  Future<DetailedReportModel> getReportDetails(int reportId);
  Future<double> getAvgRate(int reportId);
  Future<int> getCommentsCount(int reportId);
  Future addActionToReport(int reportId, String action, String rejectReason);
}
