// PostRepository interface

import '../../../../core/shared/entities/post_entity.dart';
import '../../../../core/shared/model/post_response.dart';
import '../../../admin/data/models/main_report_model.dart';
import '../../domain/data_source/post_remote_data_source.dart';
import '../../domain/repository/post_repository.dart';
import '../../../../core/shared/model/create_report_model.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remoteDataSource;

  PostRepositoryImpl({required this.remoteDataSource});

  @override
  Future<(List<PostEntity>, int)> getPosts(int pageOffset, int pageSize) async {
    final response = await remoteDataSource.getPosts(pageOffset, pageSize);
    return (response.toEntities(), response.total);
  }

  @override
  Future<PostEntity> createPost(CreatePostData post) async {
    final response = await remoteDataSource.createPost(post);
    return response as PostEntity;
  }

  @override
  Future<void> deletePost(int postId) {
    return remoteDataSource.deletePost(postId);
  }

  @override
  Future<void> reportPost(int postId, CreateReportModel createReportModel) {
    return remoteDataSource.reportPost(postId, createReportModel);
  }

  @override
  Future<List<Category>> getCategories() {
    return remoteDataSource.getCategories();
  }
}
