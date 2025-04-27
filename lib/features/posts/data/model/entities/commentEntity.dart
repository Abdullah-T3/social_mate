import '../../../../../core/shared/entities/post_entity.dart';
import '../../../presentation/postDetails/presentation/logic/post_details_cubit.dart';

class CommentEntity {
  final int id;
  final String content;
  final UserEntity createdBy;
  final DateTime createdOn;
  final String FormattedDate;
  ReactionType? currentUserReaction;
  int numOfLikes;
  int numOfDisLikes;

  CommentEntity({
    required this.id,
    required this.content,
    required this.createdBy,
    required this.createdOn,
    required this.FormattedDate,
    required this.currentUserReaction,
    required this.numOfLikes,
    required this.numOfDisLikes,
  });
}
