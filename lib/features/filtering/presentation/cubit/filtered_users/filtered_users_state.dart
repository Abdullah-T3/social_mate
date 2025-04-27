part of 'filtered_users_cubit.dart';

abstract class FilteredUsersState {
  const FilteredUsersState();
}

class FilteredUsersInitial extends FilteredUsersState {}

class FilteredUsersLoading extends FilteredUsersState {}

class FilteredUsersLoaded extends FilteredUsersState {
  final List<UserModel> filteredUsers;

  FilteredUsersLoaded({required this.filteredUsers});
}

class FilteredUsersError extends FilteredUsersState {
  final String message;

  FilteredUsersError({required this.message});
}
