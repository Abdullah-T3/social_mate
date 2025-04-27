import '../../../../../core/di/di.dart';
import '../../../../../core/helper/dotenv/dot_env_helper.dart';
import '../../../../../core/network/dio_client.dart';
import '../../../../../core/userMainDetails/userMainDetails_cubit.dart';
import '../../../../admin/data/models/main_report_model.dart';
import '../../../domain/data_source/post_remote_data_source.dart';
import '../../../../../core/shared/model/create_report_model.dart';
import '../../../../../core/shared/model/post_response.dart';

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final DioClient dio;
  final DioClient dioRep;
  final userMainDetailsCubit userMainDetails;
  final token = getIt<userMainDetailsCubit>().state.token;

  PostRemoteDataSourceImpl({
    required this.dio,
    required this.dioRep,
    required this.userMainDetails,
  });

  final String reportBaseUrl = EnvHelper.getString('report_Base_url');

  @override
  Future<PostResponse> getPosts(int pageOffset, int pageSize) async {
    try {
      final response = await dio.get(
        "/posts?",
        header: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${userMainDetails.state.token ?? token}',
        },
        queryParameters: {'pageOffset': pageOffset, 'pageSize': pageSize},
      );
      return PostResponse.fromJson(response);
    } catch (e) {
      throw Exception("Error fetching posts: ${e.toString()}");
    }
  }

  @override
  Future<void> createPost(CreatePostData post) async {
    final postData = post.toJson();
    try {
      await dio.post(
        "/posts",
        body: postData,
        header: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${userMainDetails.state.token ?? token}',
        },
      );
    } catch (e) {
      throw Exception("Error creating post: ${e.toString()}");
    }
  }

  @override
  Future<void> deletePost(int postId) async {
    await dio.delete(
      "/posts/$postId",
      header: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${userMainDetails.state.token ?? token}',
      },
    );
  }

  @override
  Future<void> reportPost(
    int postId,
    CreateReportModel createReportModel,
  ) async {
    try {
      await dioRep.post(
        "/posts/$postId/reports",
        header: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: createReportModel.toJson(),
      );
    } catch (e) {
      throw Exception("Error reporting post: ${e.toString()}");
    }
  }

  @override
  Future<List<Category>> getCategories() async {
    try {
      final response = await dioRep.get(
        "/lookups/categories/report/post",
        header: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      return (response['data'] as List)
          .map((e) => Category.fromJson(e))
          .toList();
    } catch (e) {
      throw Exception("Error fetching categories: ${e.toString()}");
    }
  }
}
