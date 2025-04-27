// lib/data/datasources/report_data_source.dart

import '../../../../../core/di/di.dart';
import '../../../../../core/network/dio_client.dart';
import '../../../../../core/userMainDetails/userMainDetails_cubit.dart';
import '../../../domain/datasources/report_remote_data_source.dart';
import '../../models/main_report_model.dart';

class ReportDetailsRemoteDataSourceImpl
    implements ReportDetailsRemoteDataSource {
  final DioClient reportDio;
  final DioClient postsDio;

  final userMainDetailsCubit userMainDetails;
  final token = getIt<userMainDetailsCubit>().state.token;
  ReportDetailsRemoteDataSourceImpl(
    this.userMainDetails, {
    required this.postsDio,
    required this.reportDio,
  });

  @override
  Future<DetailedReportModel> getReportDetails(int reportId) async {
    final response = await reportDio.get(
      '/posts/reports/$reportId',
      header: {'Authorization': 'Bearer $token'},
    );
    return DetailedReportModel.fromJson(response);
  }

  @override
  Future<double> getAvgRate(int postId) async {
    final response = await postsDio.get(
      '/posts/$postId/rates/average',
      header: {'Authorization': 'Bearer $token'},
    );
    if (response['data'] == null) {
      return 0;
    }
    return response['data'];
  }

  @override
  Future<int> getCommentsCount(int postId) async {
    final response = await postsDio.get(
      '/posts/$postId/comments/count',
      header: {'Authorization': 'Bearer $token'},
    );
    if (response['data'] == null) {
      return 0;
    }
    return response['data'];
  }

  @override
  Future addActionToReport(
    int reportId,
    String action,
    String rejectReason,
  ) async {
    final response = await reportDio.put(
      '/reports/$reportId/actions/$action',
      action == "APPROVE"
          ? {'rejectReason': null}
          : {'rejectReason': rejectReason},
      header: {'Authorization': 'Bearer $token'},
    );
    return response;
  }
}
