import '../../../../core/shared/entities/post_entity.dart';
//import 'package:social_media/features/filtering/domain/entities/filtering_post_entity.dart';

abstract class FilteredPostRepo {
  Future<List<PostEntity>> getFilteredPosts({
    Map<String, dynamic>? queryParameters,
    required String token,
  });
}
