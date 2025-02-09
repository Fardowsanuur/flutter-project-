class Blog {
  final String id;
  final String title;
  final String story;
  final String image;
  final User user;
  final String createdAt;
  final String updatedAt;

  Blog({
    required this.id,
    required this.title,
    required this.story,
    required this.image,
    required this.user,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      story: json['story'] ?? '',
      image: json['image'] ?? '',
      user: User.fromJson(json['user'] ?? {}),
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'story': story,
      'image': image,
      'user': user.toJson(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class User {
  final String id;
  final String email;

  User({
    required this.id,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      email: json['name'] ?? '',
    );
  }

  ///
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': email,
    };
  }
}
////////
//////