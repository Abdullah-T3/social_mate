// can't use failure class and dio handle error method together , it's nonsense

//import 'package:social_media/features/filtering/could_be_shared/network_clients/dio_network_client.dart';
//import 'package:social_media/features/filtering/data/models/post_model.dart';

import '../../../../core/network/dio_client.dart';
import '../../../../core/shared/model/post_response.dart';

abstract class FilteredPostsRemoteSource {
  Future<PostResponse> getFilteredPosts({
    Map<String, dynamic>? queryParameters,
    required String token,
  });
}

class FilteredPostsRemoteSourceImpl implements FilteredPostsRemoteSource {
  final DioClient dioNetworkClient;

  FilteredPostsRemoteSourceImpl({required this.dioNetworkClient});

  @override
  Future<PostResponse> getFilteredPosts({
    Map<String, dynamic>? queryParameters,
    required String token,
  }) async {
    final response = await dioNetworkClient.get(
      '/posts',
      queryParameters: queryParameters,
      header: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    //final postModel = PostModel.fromJson(response.data);
    // return [postModels]
    return PostResponse.fromJson(response);
  }
}
