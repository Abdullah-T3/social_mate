part of 'sharing_data_cubit.dart';

class SharingDataState {
  final Map<String, dynamic> queryParams;
  final List<FilteringPostEntity> posts;

  SharingDataState({
    this.queryParams = const {},
    this.posts = const [],
  });

  SharingDataState copyWith({
    Map<String, dynamic>? queryParams,
    List<FilteringPostEntity>? posts,
  }) {
    return SharingDataState(
      queryParams: queryParams ?? this.queryParams,
      posts: posts ?? this.posts,
    );
  }
}
