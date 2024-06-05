class User {
  final String username;
  final String profilePictureUrl;

  User({
    required this.username,
    required this.profilePictureUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      profilePictureUrl: json['profile_picture_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'profile_picture_url': profilePictureUrl,
    };
  }
}
