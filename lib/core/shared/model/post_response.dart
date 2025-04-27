// data/models/post_response.dart
import 'package:json_annotation/json_annotation.dart';
import '../../helper/format_time_ago.dart';
import '../entities/post_entity.dart';

part 'post_response.g.dart';

@JsonSerializable()
class PostResponse {
  final List<PostData> data;
  final int total;

  PostResponse({required this.data, required this.total});

  factory PostResponse.fromJson(Map<String, dynamic> json) => _$PostResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PostResponseToJson(this);

  List<PostEntity> toEntities() => data.map((e) => e.toEntity()).toList();
}

@JsonSerializable()
class PostData {
  final int id;
  final String title;
  final String content;
  final User createdBy;
  final DateTime createdOn;

  PostData({
    required this.id,
    required this.title,
    required this.content,
    required this.createdBy,
    required this.createdOn,
  });

  factory PostData.fromJson(Map<String, dynamic> json) => _$PostDataFromJson(json);

  Map<String, dynamic> toJson() => _$PostDataToJson(this);

  PostEntity toEntity() {
    // ignore: non_constant_identifier_names
    String FormattedDate = formatTimeAgo(createdOn.toString());
    return PostEntity(id: id, title: title, content: content, createdBy: createdBy.toEntity(), createdOn: createdOn, FormattedDate: FormattedDate);
  }
}
@JsonSerializable()
class CreatePostData {
  final String title;
  final String content;

  CreatePostData({required this.title, required this.content});
  factory CreatePostData.fromJson(Map<String, dynamic> json) => CreatePostData(title: json['title'], content: json['content']);
  Map<String, dynamic> toJson() => {
        'title': title,
        'content': content
      };
}

@JsonSerializable()
class User {
  final int id;
  final String fullName;

  User({required this.id, required this.fullName});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  UserEntity toEntity() => UserEntity(id: id, fullName: fullName);
}
