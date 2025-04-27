import '../../../../../core/network/dio_client.dart';
import '../../../../../core/shared/model/post_response.dart';
import '../../../../../core/userMainDetails/userMainDetails_cubit.dart';
import '../../../domain/data_source/postDetails/postDetails_remoteDataSource.dart';
import '../../../presentation/postDetails/presentation/logic/post_details_cubit.dart';
import '../../model/postDetails/Comments_response.dart';

class PostDetailsRemoteDataSourceImpl implements PostDetailsRemoteDataSource {
  final DioClient dio;
  final userMainDetailsCubit userMainDetails;

  PostDetailsRemoteDataSourceImpl({
    required this.dio,
    required this.userMainDetails,
  });

  @override
  Future<PostData> getPostDetails(int postId) async {
    try {
      final response = await dio.get(
        "/posts/$postId",
        header: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${userMainDetails.state.token}',
        },
      );

      return PostData.fromJson(response);
    } catch (e) {
      throw Exception("Error fetching posts: ${e.toString()}");
    }
  }

  @override
  Future<PostCommentsModel> getPostComments({
    required int postId,
    required int pageOffset,
    required int pageSize,
  }) async {
    try {
      final response = await dio.get(
        "/posts/$postId/comments?",
        header: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${userMainDetails.state.token}',
        },
        queryParameters: {'pageOffset': pageOffset, 'pageSize': pageSize},
      );

      return PostCommentsModel.fromJson(response);
    } catch (e) {
      throw Exception("Error fetching Comments: ${e.toString()}");
    }
  }

  @override
  Future<int?> getPostCommentsCount(int postId) async {
    try {
      final response = await dio.get(
        '/posts/$postId/comments/count',
        header: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${userMainDetails.state.token}',
        },
      );

      return response['data'];
    } catch (e) {
      throw Exception("Error fetching Comments Count: ${e.toString()}");
    }
  }

  @override
  Future<double?> getPostRateAverage(int postId) async {
    try {
      final response = await dio.get(
        '/posts/$postId/rates/average',
        header: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${userMainDetails.state.token}',
        },
      );

      return response['data'].toString().isEmpty ? 0 : response['data'];
    } catch (e) {
      throw Exception("Error fetching Rate Average: ${e.toString()}");
    }
  }

  @override
  Future<dynamic> RatePost(int postId, int rate) async {
    try {
      final response = await dio.put(
        '/posts/$postId/rate',
        {"value": rate},
        header: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${userMainDetails.state.token}',
        },
      );

      return response;
    } catch (e) {
      throw Exception("Error fetching Rate Average: ${e.toString()}");
    }
  }

  @override
  Future GiveReaction(
    int postId,
    int commentId,
    ReactionType reactionType,
  ) async {
    final response = await dio.post(
      '/posts/$postId/comments/$commentId/${reactionType.name}',
      header: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${userMainDetails.state.token}',
      },
    );
    return response;
  }

  @override
  Future deleteComment(int postId, int commentId) async {
    final response = await dio.delete(
      '/posts/$postId/comments/$commentId',
      header: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${userMainDetails.state.token}',
      },
    );

    return response;
  }

  @override
  Future createComment(int postId, String comment) async {
    final response = await dio.post(
      '/posts/$postId/comments',
      header: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${userMainDetails.state.token}',
      },
      body: {"content": comment},
    );

    return response;
  }
}
