import 'package:dio/dio.dart';
import 'package:social_mate/features/filtering/could_be_shared/fake_end_points/fake_end_points.dart';
import 'package:social_mate/features/filtering/could_be_shared/fake_end_points/real_end_points.dart';
import 'package:social_mate/features/filtering/could_be_shared/network_clients/dio_network_client.dart';

class FakeDioNetworkClient extends DioNetworkClient {
  @override
  FakeDioNetworkClient() : super(RealEndPoints.realPostsBaseUrl) {
    dio.options.baseUrl =
        FakeEndPoints.FakeBaseUrl; // Replace with your Fake base URL
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
