import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:social_mate/features/filtering/could_be_shared/fake_end_points/real_end_points.dart'
    show RealEndPoints;

class DioNetworkClient {
  late Dio dio;

  DioNetworkClient(String baseUrl) {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: Duration(seconds: 5),
        sendTimeout: Duration(seconds: 5),
        receiveTimeout: Duration(seconds: 5),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    // Add logging interceptor for debugging
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        error: true,
        requestBody: true,
        requestHeader: true,
        responseBody: true,
        responseHeader: true,
      ),
    );
  }

  // Factory constructors to create separate instances
  factory DioNetworkClient.posts() =>
      DioNetworkClient(RealEndPoints.realPostsBaseUrl);
  factory DioNetworkClient.userMgt() =>
      DioNetworkClient(RealEndPoints.realUserBaseUrl);

  // Generic GET request with token and query parameters
  Future<Response> get(
    String path, {
    required String token, // Add token parameter
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await dio.get(
        path,
        queryParameters: queryParameters,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ), // Add token dynamically
      );
      return response;
    } catch (e) {
      handleError(e);
      rethrow;
    }
  }

  // Generic POST request with token and data
  Future<Response> post(
    String path, {
    // Add token parameter
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await dio.post(
        path,
        data: data,
        // Add token dynamically
      );
      return response;
    } catch (e) {
      handleError(e);
      rethrow;
    }
  }

  // Generic PUT request with token and data
  Future<Response> put(
    String path, {
    required String token, // Add token parameter
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await dio.put(
        path,
        data: data,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ), // Add token dynamically
      );
      return response;
    } catch (e) {
      handleError(e);
      rethrow;
    }
  }

  // Generic DELETE request with token
  Future<Response> delete(
    String path, {
    required String token, // Add token parameter
  }) async {
    try {
      final response = await dio.delete(
        path,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ), // Add token dynamically
      );
      return response;
    } catch (e) {
      handleError(e);
      rethrow;
    }
  }

  // Error handling method
  void handleError(Object error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          if (kDebugMode) {
            print('Connection timeout');
          }
          break;
        case DioExceptionType.sendTimeout:
          if (kDebugMode) {
            print('Send timeout');
          }
          break;
        case DioExceptionType.receiveTimeout:
          if (kDebugMode) {
            print('Receive timeout');
          }
          break;
        case DioExceptionType.badResponse:
          if (kDebugMode) {
            print(
              'Response error: ${error.response?.statusCode} - ${error.response?.statusMessage}',
            );
          }
          break;
        case DioExceptionType.cancel:
          if (kDebugMode) {
            print('Request canceled');
          }
          break;
        case DioExceptionType.unknown:
          if (kDebugMode) {
            print('Unexpected error: ${error.message}');
          }
          break;
        default:
          if (kDebugMode) {
            print('Unhandled DioExceptionType: ${error.type}');
          }
          break;
      }
    } else {
      if (kDebugMode) {
        print('Unknown error: $error');
      }
    }
  }
}
