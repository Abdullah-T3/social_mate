import '../../../domain/datasources/reportFilter/reportFilter_remoteDataSource.dart';
import '../../../domain/entities/main_report_entity.dart' show MainReportEntity;
import '../../../domain/repositories/reportFilter/reportFilter_repo.dart';

class reportFilterRepoImpl extends reportFilterRepository {
  final ReportFilterRemoteDataSource reportFilterRemoteDataSource;

  reportFilterRepoImpl({required this.reportFilterRemoteDataSource});

  @override
  Future<(List<MainReportEntity>, int)> getReports({
    Map<String, dynamic>? queryParams,
  }) async {
    final response = await reportFilterRemoteDataSource.getReports(
      queryParams: queryParams,
    );

    return (response.toReportEntities(), response.total);
  }
}
