import 'package:dio/dio.dart';

import '../../../../core/network/dio_client.dart';
import '../models/main_report_model.dart';

abstract class AllReportsRemoteSource {
  Future<Map<String, dynamic>> getAllReports(
    Map<String, dynamic> queryParams, {
    required String token,
  });
}

class AllReportsRemoteSourceImpl implements AllReportsRemoteSource {
  final DioClient dioClient;

  AllReportsRemoteSourceImpl({required this.dioClient});

  @override
  Future<Map<String, dynamic>> getAllReports(
    Map<String, dynamic> queryParams, {
    required String token,
  }) async {
    try {
      final response = await dioClient.get(
        '/reports',
        queryParameters: queryParams,
        header: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response['data'] == null) {
        throw Exception('Invalid response format: data is missing');
      }

      final List<dynamic> data = response['data'] ?? [];
      final int total = response['total']?.toInt() ?? 0;

      final List<MainReportModel> reportList =
          data
              .map(
                (report) => MainReportModel(
                  data: [ReportData.fromJson(report)],
                  total: total,
                ),
              )
              .toList();

      // Return both the status code and the report list
      return {
        'statusCode': 200, // If the request is successful
        'reports': reportList,
      };
    } on DioException catch (e) {
      if (e.response != null) {
        final statusCode = e.response!.statusCode ?? 500;
        final errorMessage = e.response!.data?['message'] ?? e.message;

        // Return status code with an empty list
        return {
          'statusCode': statusCode,
          'reports': [],
          'error': 'HTTP Error $statusCode: $errorMessage',
        };
      } else {
        return {
          'statusCode': 500,
          'reports': [],
          'error': 'Network error: ${e.message}',
        };
      }
    } catch (e) {
      return {
        'statusCode': 500,
        'reports': [],
        'error': 'An unexpected error occurred: $e',
      };
    }
  }
}
