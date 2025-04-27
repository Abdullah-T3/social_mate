// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';
import '../../../../../../core/shared/entities/post_entity.dart';
import '../../../../../../core/shared/model/create_report_model.dart';
import '../../../../../../core/shared/model/post_response.dart';
import '../../../../../admin/data/models/main_report_model.dart';
import '../../../../domain/repository/post_repository.dart';
part 'home_cubit_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this.postRepository) : super(HomeCubitInitial());

  final PostRepository postRepository;

  int _currentPage = 0;
  final int _pageSize = 4;
  bool hasMorePosts = true;
  bool isLoadingMore = false;

  Future<void> getPosts() async {
    if (state is PostLoading || state is PostLoaded) return;

    emit(PostLoading());

    try {
      final (posts, total) = await postRepository.getPosts(
        _currentPage,
        _pageSize,
      );
      hasMorePosts = _currentPage < total;
      _currentPage += 4;
      emit(PostLoaded(posts, total));
    } catch (e) {
      emit(PostError(e.toString()));
    }
  }

  // Load more posts
  Future<void> loadMorePosts() async {
    if (isLoadingMore || state is! PostLoaded || !hasMorePosts) return;
    isLoadingMore = true;

    final currentState = state as PostLoaded;
    emit(PostLoadingMore(currentState.posts, currentState.total));

    try {
      final (newPosts, total) = await postRepository.getPosts(
        _currentPage,
        _pageSize,
      );

      if (newPosts.isEmpty) {
        hasMorePosts = false;
      } else {
        _currentPage += 4;
        final updatedPosts = List<PostEntity>.from(currentState.posts)
          ..addAll(newPosts);
        hasMorePosts = _currentPage < total;
        emit(PostLoaded(updatedPosts, total));
      }
    } catch (e) {
      emit(PostError(e.toString()));
    } finally {
      isLoadingMore = false;
    }
  }

  // Handle refresh action
  Future<void> onRefresh() async {
    _currentPage = 0;
    hasMorePosts = true;
    emit(HomeCubitInitial());
    await getPosts();
  }

  // Create a new post
  Future<void> createPost(String title, String content) async {
    final post = CreatePostData(title: title, content: content);
    try {
      emit(PostCreateLoading()); // Emit loading state
      await postRepository.createPost(post);
      emit(PostCreated()); // Emit success state
    } catch (e) {
      emit(PostError(e.toString())); // Emit error state
    }
  }

  Future<void> deletePost(int postId) async {
    try {
      emit(PostDeletedLoading());
      await postRepository.deletePost(postId);
      emit(PostDeleted());
    } catch (e) {
      emit(PostDeleteFailed(e.toString()));
    }
  }

  Future<void> reportPost(
    int postId,
    CreateReportModel createReportModel,
  ) async {
    try {
      await postRepository.reportPost(postId, createReportModel);
      emit(PostReported());
    } catch (e) {
      emit(PostReportedFailed(e.toString()));
    }
  }

  Future<void> reportCategories() async {
    try {
      emit(PostReportedLoading());
      final reportCategories = await postRepository.getCategories();
      emit(LoadedReportCategories(reportCategories));
    } catch (e) {
      emit(PostReportedFailed(e.toString()));
    }
  }
}
