// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Comments_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostCommentsModel _$PostCommentsModelFromJson(Map<String, dynamic> json) =>
    PostCommentsModel(
      data: (json['data'] as List<dynamic>)
          .map((e) => Comment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PostCommentsModelToJson(PostCommentsModel instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
      id: (json['id'] as num).toInt(),
      content: json['content'] as String,
      createdBy: User.fromJson(json['createdBy'] as Map<String, dynamic>),
      createdOn: DateTime.parse(json['createdOn'] as String),
      currentUserReaction: $enumDecodeNullable(
          _$ReactionTypeEnumMap, json['currentUserReaction']),
      numOfLikes: (json['numOfLikes'] as num).toInt(),
      numOfDisLikes: (json['numOfDisLikes'] as num).toInt(),
    );

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'createdBy': instance.createdBy,
      'createdOn': instance.createdOn.toIso8601String(),
      'numOfLikes': instance.numOfLikes,
      'numOfDisLikes': instance.numOfDisLikes,
      'currentUserReaction':
          _$ReactionTypeEnumMap[instance.currentUserReaction],
    };

const _$ReactionTypeEnumMap = {
  ReactionType.LIKE: 'LIKE',
  ReactionType.DIS_LIKE: 'DIS_LIKE',
};
