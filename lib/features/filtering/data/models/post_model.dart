import '../../domain/entities/filtering_post_entity.dart';

class PostModel {
  final List<PostItemModel> data;
  final int total;

  const PostModel({required this.data, required this.total});

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      data:
          (json['data'] as List?)
              ?.map((post) => PostItemModel.fromJson(post))
              .toList() ??
          [],
      total: json['total'] ?? 0,
    );
  }

  List<FilteringPostEntity> toEntityList() {
    return data.map((postItem) => postItem.toEntity(total)).toList();
  }
}

class PostItemModel {
  final int id;
  final String title;
  final String content;
  final String createdOn;
  final CreatedByModel createdBy;

  const PostItemModel({
    required this.id,
    required this.title,
    required this.content,
    required this.createdOn,
    required this.createdBy,
  });

  factory PostItemModel.fromJson(Map<String, dynamic> json) {
    return PostItemModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      createdOn: json['createdOn'] ?? '',
      createdBy: CreatedByModel.fromJson(json['createdBy'] ?? {}),
    );
  }

  FilteringPostEntity toEntity(int total) {
    return FilteringPostEntity(
      id: id,
      title: title,
      content: content,
      createdOn: createdOn,
      createdBy: createdBy.fullName,
      userId: createdBy.id,
      total: total,
    );
  }
}

class CreatedByModel {
  final int id;
  final String fullName;

  const CreatedByModel({required this.id, required this.fullName});

  factory CreatedByModel.fromJson(Map<String, dynamic> json) {
    return CreatedByModel(
      id: json['id'] ?? 0,
      fullName: json['fullName'] ?? 'Unknown',
    );
  }
}
