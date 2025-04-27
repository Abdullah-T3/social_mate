// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';

import '../../../../core/helper/Connectivity/connectivity_helper.dart'
    show ConnectivityHelper;
import '../../../../core/shared/entities/post_entity.dart';
import '../../domain/repositories/filtered_post_repo.dart';
//import 'package:social_media/core/helper/Connectivity/connectivity_helper.dart';
//import 'package:social_media/features/filtering/domain/entities/filtering_post_entity.dart';

part 'filtering_state.dart';

class FilteringCubit extends Cubit<FilteringState> {
  final FilteredPostRepo filteredPostRepo;
  int _pageOffset = 0;
  final int _pageSize = 5;
  bool _hasMore = true;

  FilteringCubit(this.filteredPostRepo) : super(FilteringInitial());

  Future<void> getFilteredPosts({
    Map<String, dynamic>? queryParameters,
    required String token,
  }) async {
    bool isConnected = await ConnectivityHelper.isConnected();
    if (!isConnected) {
      emit(FilteredPostsNetworkError());
      return;
    }
    if (state is FilteredPostsIsLoading) return;
    _pageOffset = 0;
    _hasMore = true;
    emit(FilteredPostsIsLoading());

    try {
      final filteredPosts = await filteredPostRepo.getFilteredPosts(
        queryParameters: {
          ...?queryParameters,
          'pageOffset': _pageOffset,
          'pageSize': _pageSize,
        },
        token: token,
      );

      if (filteredPosts.isEmpty) {
        emit(FilteredPostsIsEmpty(filteredPosts));
      } else {
        _hasMore = filteredPosts.length == _pageSize;
        emit(FilteredPostsIsLoaded(filteredPosts, _hasMore));
      }
    } catch (e) {
      emit(FilteredPostsHasError(e.toString()));
    }
  }

  Future<void> loadMoreFilteredPosts({
    Map<String, dynamic>? queryParameters,
    required String token,
  }) async {
    bool isConnected = await ConnectivityHelper.isConnected();
    if (!isConnected) {
      emit(FilteredPostsNetworkError());
      return;
    }
    if (state is! FilteredPostsIsLoaded || !_hasMore) return;

    final currentState = state as FilteredPostsIsLoaded;
    emit(
      currentState.copyWith(hasMore: false),
    ); // Disable loading more temporarily

    try {
      _pageOffset += _pageSize;
      final newPosts = await filteredPostRepo.getFilteredPosts(
        queryParameters: {
          ...?queryParameters,
          'pageOffset': _pageOffset,
          'pageSize': _pageSize,
        },
        token: token,
      );

      _hasMore = newPosts.length == _pageSize;
      final updatedPosts = [...currentState.filteredPosts, ...newPosts];
      emit(
        currentState.copyWith(filteredPosts: updatedPosts, hasMore: _hasMore),
      );
    } catch (e) {
      emit(FilteredPostsHasError(e.toString()));
    }
  }
}
