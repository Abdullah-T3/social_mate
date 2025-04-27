class PostEntity {
  final int id;
  final String title;
  final String content;
  final UserEntity createdBy;
  final DateTime createdOn;
  final String FormattedDate;

  PostEntity({
    required this.id,
    required this.title,
    required this.content,
    required this.createdBy,
    required this.createdOn,
    required this.FormattedDate
  });
}

class CreatedBy {
  final int id;
  final String fullName;

  CreatedBy({required this.id, required this.fullName});
}

class UserEntity {
  final int id;
  final String fullName;

  UserEntity({required this.id, required this.fullName});
}
