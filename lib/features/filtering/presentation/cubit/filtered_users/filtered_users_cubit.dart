import 'package:bloc/bloc.dart';

import '../../../data/models/filtered_user_model.dart';
import '../../../domain/repositories/filtered_users_repo.dart';

part 'filtered_users_state.dart';

class FilteredUsersCubit extends Cubit<FilteredUsersState> {
  final FilteredUsersRepo filteredUsersRepo;
  FilteredUsersCubit({required this.filteredUsersRepo})
    : super(FilteredUsersInitial());

  Future<void> loadFilteredUsers({
    required Map<String, dynamic> queryParameters,
    required String token,
  }) async {
    emit(FilteredUsersLoading());
    try {
      final filteredUsers = await filteredUsersRepo.getFilteredUsers(
        queryParameters: queryParameters,
        token: token,
      );
      emit(FilteredUsersLoaded(filteredUsers: filteredUsers));
    } catch (e) {
      emit(FilteredUsersError(message: e.toString()));
    }
  }
}
