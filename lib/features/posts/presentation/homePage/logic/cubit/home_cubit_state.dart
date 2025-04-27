part of 'home_cubit_cubit.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeCubitInitial extends HomeState {}

class PostLoading extends HomeState {}

class PostCreateLoading extends HomeState {}

class PostLoaded extends HomeState {
  final List<PostEntity> posts;

  final int total;

  const PostLoaded(this.posts, this.total);

  @override
  List<Object> get props => [posts, total];
}

class PostCreated extends HomeState {}

class CreatePostFailed extends HomeState {}

class PostUpdated extends HomeState {}

class PostLoadingMore extends HomeState {
  final List<PostEntity> posts; // Include the current posts here
  final int total;

  const PostLoadingMore(this.posts, this.total);
}

class LoadedMorePosts extends HomeState {
  final List<PostEntity> posts;
  final int totalPosts;

  const LoadedMorePosts({required this.posts, required this.totalPosts});
}

class PostDeleted extends HomeState {}

class PostDeleteFailed extends HomeState {
  final String message;

  const PostDeleteFailed(this.message);
}

class PostDeletedLoading extends HomeState {}

class PostUpdatedFailed extends HomeState {}

class PostUpdatedSuccessfully extends HomeState {}

class PostReported extends HomeState {}

class LoadedReportCategories extends HomeState {
  final List<Category> categories;

  const LoadedReportCategories(this.categories);
}

class PostReportedFailed extends HomeState {
  final String message;

  const PostReportedFailed(this.message);
}

class PostReportedLoading extends HomeState {}

class PostError extends HomeState {
  final String message;

  const PostError(this.message);

  @override
  List<Object> get props => [message];
}
