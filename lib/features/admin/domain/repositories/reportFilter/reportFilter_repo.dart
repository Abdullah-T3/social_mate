import '../../entities/main_report_entity.dart' show MainReportEntity;

abstract class reportFilterRepository {
  Future<(List<MainReportEntity>, int)> getReports({
    Map<String, dynamic>? queryParams,
  });
}
