import '../../could_be_shared/network_clients/dio_network_client.dart';
import '../models/filtered_user_model.dart';

abstract class UserRemoteDataSource {
  Future<List<UserModel>> getFilteredUsers({
    required Map<String, dynamic> queryParameters,
    required String token,
  });
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final DioNetworkClient dioNetworkClient;

  UserRemoteDataSourceImpl({required this.dioNetworkClient});

  @override
  Future<List<UserModel>> getFilteredUsers({
    required Map<String, dynamic> queryParameters,
    required String token,
  }) async {
    try {
      // Fetch the response from the API
      final response = await dioNetworkClient.get(
        '/users',
        queryParameters: queryParameters,
        token: token,
      );

      // Validate the response structure
      if (response.data == null || response.data is! Map<String, dynamic>) {
        throw FormatException('Invalid response format');
      }

      // Extract the 'data' array from the response
      final data = response.data['data'];
      if (data == null || data is! List) {
        throw FormatException('Missing or invalid "data" field in response');
      }

      // Map each item in the 'data' array to a UserModel
      final users = (data).map((item) => UserModel.fromJson(item)).toList();

      return users;
    } catch (e) {
      // Re-throw the exception with additional context
      rethrow;
    }
  }
}
