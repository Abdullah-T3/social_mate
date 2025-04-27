// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostResponse _$PostResponseFromJson(Map<String, dynamic> json) => PostResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => PostData.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$PostResponseToJson(PostResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
      'total': instance.total,
    };

PostData _$PostDataFromJson(Map<String, dynamic> json) => PostData(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      content: json['content'] as String,
      createdBy: User.fromJson(json['createdBy'] as Map<String, dynamic>),
      createdOn: DateTime.parse(json['createdOn'] as String),
    );

Map<String, dynamic> _$PostDataToJson(PostData instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'createdBy': instance.createdBy,
      'createdOn': instance.createdOn.toIso8601String(),
    };

CreatePostData _$CreatePostDataFromJson(Map<String, dynamic> json) =>
    CreatePostData(
      title: json['title'] as String,
      content: json['content'] as String,
    );

Map<String, dynamic> _$CreatePostDataToJson(CreatePostData instance) =>
    <String, dynamic>{
      'title': instance.title,
      'content': instance.content,
    };

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: (json['id'] as num).toInt(),
      fullName: json['fullName'] as String,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
    };
