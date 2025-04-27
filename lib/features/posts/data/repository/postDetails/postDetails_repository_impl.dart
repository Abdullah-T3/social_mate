// PostRepository interface

import '../../../../../core/shared/entities/post_entity.dart';
import '../../../domain/data_source/postDetails/postDetails_remoteDataSource.dart';
import '../../../domain/repository/postDetails/postDetails_repository.dart';
import '../../../presentation/postDetails/presentation/logic/post_details_cubit.dart';
import '../../model/entities/commentEntity.dart';

class PostDetailsRepositoryImpl implements PostDetailsRepository {
  PostDetailsRemoteDataSource postDetailsRemoteDataSource;

  PostDetailsRepositoryImpl({required this.postDetailsRemoteDataSource});

  @override
  Future<PostEntity> getPostDetails(int postId) async {
    final response = await postDetailsRemoteDataSource.getPostDetails(postId);

    return response.toEntity();
  }

  @override
  Future<int?> getPostCommentsCount(int postId) async {
    final response = await postDetailsRemoteDataSource.getPostCommentsCount(
      postId,
    );

    return response;
  }

  @override
  Future<double?> getPostRateAverage(int postId) async {
    final response = await postDetailsRemoteDataSource.getPostRateAverage(
      postId,
    );

    return response;
  }

  @override
  Future<List<CommentEntity>> getPostComments({
    required int postId,
    required int pageOffset,
    required int pageSize,
  }) async {
    final response = await postDetailsRemoteDataSource.getPostComments(
      postId: postId,
      pageOffset: pageOffset,
      pageSize: pageSize,
    );

    return response.toEntities();
  }

  @override
  Future<dynamic> RatePost(int postId, int rate) async {
    final response = await postDetailsRemoteDataSource.RatePost(postId, rate);

    return response;
  }

  @override
  Future GiveReaction(
    int postId,
    int commentId,
    ReactionType reactionType,
  ) async {
    final response = await postDetailsRemoteDataSource.GiveReaction(
      postId,
      commentId,
      reactionType,
    );

    return response;
  }

  @override
  Future deleteComment(int postId, int commentId) {
    final response = postDetailsRemoteDataSource.deleteComment(
      postId,
      commentId,
    );

    return response;
  }

  @override
  Future createComment(int postId, String comment) async {
    final response = await postDetailsRemoteDataSource.createComment(
      postId,
      comment,
    );
    return response;
  }
}
