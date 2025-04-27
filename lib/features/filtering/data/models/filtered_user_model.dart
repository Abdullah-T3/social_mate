class FilteredUserModel {
  final List<UserModel> data;

  FilteredUserModel({required this.data});

  factory FilteredUserModel.fromJson(Map<String, dynamic> json) {
    return FilteredUserModel(
      data: (json['data'] as List)
          .map((item) => UserModel.fromJson(item))
          .toList(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

class UserModel {
  final int id;
  final String fullName;

  UserModel({required this.id, required this.fullName});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      fullName: json['fullName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
    };
  }
}
