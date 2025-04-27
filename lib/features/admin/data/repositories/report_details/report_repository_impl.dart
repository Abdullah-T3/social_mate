// lib/data/repositories/report_repository_impl.dart


import '../../../domain/repositories/report_details/report_repository.dart';
import '../../datasources/report_details/report_details_remote_data_sourc_impl.dart';
import '../../models/main_report_model.dart';

class ReportDetailsRepositoryImpl implements ReportDetailsRepository {
  final ReportDetailsRemoteDataSourceImpl dataSource;

  ReportDetailsRepositoryImpl({required this.dataSource});

  @override
  Future<DetailedReportModel> getReportDetails(int reportId) {
    return dataSource.getReportDetails(reportId);
  }
  
  @override
  Future<double> getAvgRate(int reportId) {
return dataSource.getAvgRate(reportId);
  }
  
  @override
  Future<int> getCommentsCount(int reportId) {
    return dataSource.getCommentsCount(reportId);
  }
  
  @override
  Future addActionToReport(int reportId, String action, String rejectReason) {
    return dataSource.addActionToReport(reportId, action, rejectReason  );
  }

}
