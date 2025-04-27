part of 'post_details_cubit.dart';

@immutable
sealed class PostDetailsState {}

final class PostDetailsInitial extends PostDetailsState {}

final class PostDetailsLoading extends PostDetailsState {}

final class PostDetailsLoaded extends PostDetailsState {
  final PostEntity postDetails;
  PostDetailsLoaded(this.postDetails);
}

final class PostDetailsError extends PostDetailsState {
  final String message;
  PostDetailsError(this.message);
}

// comments Count
final class CommentsCountLoading extends PostDetailsState {}
final class CommentsCountLoaded extends PostDetailsState {}

// Rate Average
final class RatePostAverageLoading extends PostDetailsState {}
final class RatePostAverageLoaded extends PostDetailsState {}

final class SuccessPostRate extends PostDetailsState {}
final class FailPostRate extends PostDetailsState {}
final class SetPostRateLoading extends PostDetailsState {}


// Comments
final class CommentsLoading extends PostDetailsState {}
final class CommentsLoaded extends PostDetailsState {}

final class CommentsCreated extends PostDetailsState {}
final class CommentsCreationLoading extends PostDetailsState {}
final class CommentsError extends PostDetailsState {
  final String message;
  CommentsError(this.message);
}


//Give Reaction
// final class GiveReactionLoading extends PostDetailsState {}
// final class GiveReactionSuccess extends PostDetailsState {}
// final class GiveReactionFail extends PostDetailsState {
//    final String message;
//   GiveReactionFail(this.message);
// }

final class deleteCommentLoading extends PostDetailsState {}
final class deleteCommentSuccess extends PostDetailsState {
  int deletedCommentId = 0;
  deleteCommentSuccess(this.deletedCommentId);
}
final class deleteCommentFail extends PostDetailsState {
   final String message;
  deleteCommentFail(this.message);
}
