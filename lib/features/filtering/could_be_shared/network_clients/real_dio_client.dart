import 'package:dio/dio.dart';
import 'package:social_mate/features/filtering/could_be_shared/fake_end_points/real_end_points.dart';
import 'package:social_mate/features/filtering/could_be_shared/network_clients/dio_network_client.dart'
    show DioNetworkClient;

class RealDioNetworkClient extends DioNetworkClient {
  @override
  RealDioNetworkClient() : super(RealEndPoints.realPostsBaseUrl) {
    dio.options.baseUrl =
        RealEndPoints.realPostsBaseUrl; // Replace with your Fake base URL
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
}

class UserDioNetworkClient extends DioNetworkClient {
  @override
  UserDioNetworkClient() : super(RealEndPoints.realUserBaseUrl) {
    dio.options.baseUrl =
        RealEndPoints.realUserBaseUrl; // Replace with your Fake base URL
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
}
