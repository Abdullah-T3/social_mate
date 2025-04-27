part of 'comment_cubit.dart';

@immutable
sealed class CommentState {}

final class CommentInitial extends CommentState {}


final class GiveReactionLoading extends CommentState {}
final class GiveReactionSuccess extends CommentState {}
final class GiveReactionFail extends CommentState {
  final String message;
  GiveReactionFail(this.message);
}

