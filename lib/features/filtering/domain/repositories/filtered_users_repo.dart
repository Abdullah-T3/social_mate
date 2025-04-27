import '../../data/models/filtered_user_model.dart' show UserModel;

abstract class FilteredUsersRepo {
  Future<List<UserModel>> getFilteredUsers({
    required Map<String, dynamic> queryParameters,
    required String token,
  });
}
