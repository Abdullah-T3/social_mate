import '../../../data/models/main_report_model.dart';

abstract class ReportFilterRemoteDataSource {
  Future<MainReportModel> getReports({Map<String, dynamic>? queryParams});
}
