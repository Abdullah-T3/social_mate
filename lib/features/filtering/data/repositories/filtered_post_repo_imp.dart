// i think we need to declare customized exceptions ??

//import 'package:social_media/features/filtering/could_be_shared/network_info/network_info.dart';
//import 'package:social_media/features/filtering/domain/entities/filtering_post_entity.dart';

import '../../../../core/helper/Connectivity/connectivity_helper.dart';
import '../../../../core/shared/entities/post_entity.dart';
import '../../domain/repositories/filtered_post_repo.dart';
import '../datasources/filtered_posts_remote_source.dart';

class FilteredPostRepoImp implements FilteredPostRepo {
  final FilteredPostsRemoteSource filteredPostsRemoteSource;
  // final NetworkInfo networkInfo;

  FilteredPostRepoImp({
    // required this.networkInfo,
    required this.filteredPostsRemoteSource,
  });

  @override
  Future<List<PostEntity>> getFilteredPosts({
    Map<String, dynamic>? queryParameters,
    required String token,
  }) async {
    if (await ConnectivityHelper.isConnected()) {
      try {
        final postModels = await filteredPostsRemoteSource.getFilteredPosts(
          queryParameters: queryParameters,
          token: token,
        );

        // if (postModels.isEmpty) {
        //   print("PostModel data is empty");
        //   return [];
        // }

        // final postEntities = postModels
        //     .map((postModel) => postModel.toEntityList())
        //     .expand((element) => element)
        //     .toList();

        // print("Filtered Posts: ${postEntities.length} items"); // Debug log
        return postModels.toEntities();
      } catch (e) {
        throw Exception('Failed to fetch filtered posts: $e');
      }
    } else {
      throw Exception('No internet connection');
    }
  }
}
