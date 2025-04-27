import 'package:json_annotation/json_annotation.dart';

import '../../../../../core/helper/format_time_ago.dart';
import '../../../../../core/shared/model/post_response.dart';
import '../../../presentation/postDetails/presentation/logic/post_details_cubit.dart';
import '../entities/commentEntity.dart';

part 'Comments_response.g.dart';

@JsonSerializable()
class PostCommentsModel {
  final List<Comment> data;

  PostCommentsModel({required this.data});

  factory PostCommentsModel.fromJson(Map<String, dynamic> json) =>
      _$PostCommentsModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostCommentsModelToJson(this);

  toEntities() => data.map((e) => e.toEntity()).toList();
}

@JsonSerializable()
class Comment {
  final int id;
  final String content;
  final User createdBy;
  final DateTime createdOn;
  final int numOfLikes;
  final int numOfDisLikes;
  final ReactionType? currentUserReaction;
  Comment({
    required this.id,
    required this.content,
    required this.createdBy,
    required this.createdOn,
    required this.currentUserReaction,
    required this.numOfLikes,
    required this.numOfDisLikes,
  });

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);

  Map<String, dynamic> toJson() => _$CommentToJson(this);

  CommentEntity toEntity() {
    String FormattedDate = formatTimeAgo(createdOn.toString());

    return CommentEntity(
      id: id,
      content: content,
      createdBy: createdBy.toEntity(),
      createdOn: createdOn,
      FormattedDate: FormattedDate,
      currentUserReaction: currentUserReaction,
      numOfLikes: numOfLikes,
      numOfDisLikes: numOfDisLikes,
    );
  }
}
