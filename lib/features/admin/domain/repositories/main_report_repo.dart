
abstract class MainReportRepo {
  Future<Map<String, dynamic>> getAllReports(Map<String, dynamic> queryParams,
      {required String token});
}