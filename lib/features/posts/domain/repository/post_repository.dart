// domain/repositories/post_repository.dart

import '../../../../core/shared/entities/post_entity.dart';
import '../../../../core/shared/model/create_report_model.dart';
import '../../../../core/shared/model/post_response.dart';
import '../../../admin/data/models/main_report_model.dart';

abstract class PostRepository {
  Future<
      (
        List<PostEntity>,
        int
      )> getPosts(int pageOffset, int pageSize);
  Future<PostEntity> createPost(CreatePostData post);
  Future<void> deletePost(int postId);
  Future<void> reportPost(int postId, CreateReportModel createReportModel);
  Future<List<Category>> getCategories();
}
