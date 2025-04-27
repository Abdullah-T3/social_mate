//import 'package:social_media/features/filtering/could_be_shared/network_info/network_info.dart';

import '../../../../core/helper/Connectivity/connectivity_helper.dart';
import '../../domain/repositories/filtered_users_repo.dart';
import '../datasources/users_remote_data_source.dart';
import '../models/filtered_user_model.dart';

class FilteredUsersRepoImpl implements FilteredUsersRepo {
  final UserRemoteDataSource filteredUsersRemoteSource;
  // final NetworkInfo networkInfo;

  FilteredUsersRepoImpl({
    required this.filteredUsersRemoteSource,
    // required this.networkInfo
  });
  @override
  Future<List<UserModel>> getFilteredUsers({
    required Map<String, dynamic> queryParameters,
    required String token,
  }) async {
    if (await ConnectivityHelper.isConnected()) {
      try {
        final userModels = await filteredUsersRemoteSource.getFilteredUsers(
          queryParameters: queryParameters,
          token: token,
        );
        if (userModels.isEmpty) {
          return [];
        }
        return userModels;
      } catch (e) {
        throw Exception('Failed to fetch filtered users: $e');
      }
    } else {
      throw Exception('No internet connection');
    }
  }
}
