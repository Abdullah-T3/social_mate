import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import '../../../../../../core/error/errorResponseModel.dart';
import '../../../../../../core/shared/entities/post_entity.dart';
import '../../../../data/model/entities/commentEntity.dart';
import '../../../../domain/repository/postDetails/postDetails_repository.dart';

part 'post_details_state.dart';

enum ReactionType { LIKE, DIS_LIKE }

class PostDetailsCubit extends Cubit<PostDetailsState> {
  PostDetailsRepository postDetailsRepository;

  PostDetailsCubit(this.postDetailsRepository) : super(PostDetailsInitial());

  TextEditingController createCommentController = TextEditingController();

  FocusNode commentfocusNode = FocusNode();

  PostEntity? post;
  List<CommentEntity>? comments;
  static int _postId = 0;
  double? rateAverage;
  double selectedRatingValue = 0;

  // Pagination
  int? commentsCount;
  int _currentPage = 0;
  int _pageSize = 3;
  bool hasMoreComments = true;
  bool isLoading = false;

  static void setSelectedPost(int postId) {
    _postId = postId;
  }

  Future<void> setRateAverage(int value) async {
    selectedRatingValue = value.toDouble();
    emit(SetPostRateLoading());
    try {
      final response = await postDetailsRepository.RatePost(_postId, value);
      if (response['statusCode'] == 204) {
        emit(SuccessPostRate());
      } else {
        selectedRatingValue = rateAverage ?? 0;
        emit(FailPostRate());
      }
    } catch (e) {
      selectedRatingValue = rateAverage ?? 0;
      emit(FailPostRate());
    }
  }

  Future<void> getPostDetails() async {
    try {
      emit(PostDetailsLoading());

      post = await postDetailsRepository.getPostDetails(_postId);

      emit(PostDetailsLoaded(post!));
    } catch (e) {
      emit(PostDetailsError(e.toString()));
    }
  }

  Future<void> getPostCommentsCount() async {
    try {
      emit(CommentsCountLoading());
      commentsCount = await postDetailsRepository.getPostCommentsCount(_postId);

      emit(CommentsCountLoaded());
    } catch (e) {
      emit(PostDetailsError(e.toString()));
    }
  }

  Future<void> getPostRateAverage() async {
    try {
      emit(RatePostAverageLoading());
      rateAverage = await postDetailsRepository.getPostRateAverage(_postId);

      rateAverage ??= 0;

      selectedRatingValue = rateAverage!;

      emit(RatePostAverageLoaded());
    } catch (e) {
      if (e.toString().contains('null')) {
        rateAverage = 0;
        selectedRatingValue = 0;
        emit(RatePostAverageLoaded());
      }
      emit(PostDetailsError(e.toString()));
    }
  }

  Future<void> getPostComments({
    int? pageOffset = null,
    int? pageSize = null,
  }) async {
    if (!hasMoreComments || isLoading) return;

    isLoading = true;
    try {
      emit(CommentsLoading());
      final newComments = await postDetailsRepository.getPostComments(
        postId: _postId,
        pageOffset: pageOffset ?? _currentPage,
        pageSize: pageSize ?? _pageSize,
      );

      // print('comments length ${comments!.length} $_currentPage $commentsCount ${newComments.length}');

      if (newComments.isEmpty) {
        hasMoreComments = false;
        comments ??= [];
      } else {
        comments ??= [];
        comments!.addAll(newComments);

        _currentPage++;
        hasMoreComments = (_currentPage * _pageSize) < commentsCount!;
      }

      emit(CommentsLoaded());
    } catch (e) {
      emit(PostDetailsError(e.toString()));
    } finally {
      isLoading = false;
    }
  }

  Future<void> deleteComment(int commentId) async {
    commentfocusNode.unfocus();
    try {
      emit(deleteCommentLoading());
      final response = await postDetailsRepository.deleteComment(
        _postId,
        commentId,
      );

      if (response['statusCode'] == 204) {
        comments!.removeWhere((comment) => comment.id == commentId);
        emit(deleteCommentSuccess(commentId));
      } else {
        emit(deleteCommentFail('Failed to Delete to The post'));
      }
    } catch (e) {
      if (e is ErrorResponseModel) {
        emit(deleteCommentFail(e.message.toString()));
      } else {
        emit(deleteCommentFail(e.toString()));
      }
    }
  }

  Future<void> createComment(BuildContext context) async {
    if (createCommentController.text.isNotEmpty) {
      try {
        emit(CommentsCreationLoading());
        final response = await postDetailsRepository.createComment(
          _postId,
          createCommentController.text,
        );

        if (response['data'] is int) {
          commentfocusNode.unfocus();
          createCommentController.clear();
          emit(CommentsCreated());
        } else {
          emit(CommentsError('Failed to send Your Comment'));
        }
      } catch (e) {
        if (e is ErrorResponseModel) {
          emit(CommentsError(e.message.toString()));
        } else {
          emit(CommentsError(e.toString()));
        }
      }
    } else {
      emit(CommentsError('Please Enter Your Comment'));
    }
  }

  Future<void> refreshPostDetails() async {
    try {
      _currentPage = 0;
      comments = null;
      commentsCount = null;
      rateAverage = null;
      hasMoreComments = true;
      post = null;
      selectedRatingValue = 0;

      await getPostDetails();
    } catch (e) {
      emit(PostDetailsError(e.toString()));
    }
  }
}
