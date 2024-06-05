class User {
  final String username;
  final String profilePictureUrl;
  final String email;
  final String password;

  User({
    required this.username,
    required this.profilePictureUrl,
    required this.email,
    required this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      profilePictureUrl: json['profile_picture_url'],
      email: json['email'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'profile_picture_url': profilePictureUrl,
      'email': email,
      'password': password,
    };
  }
}

// Extension to add `firstWhereOrNull` method
extension IterableExtensions<E> on Iterable<E> {
  E? firstWhereOrNull(bool Function(E element) test) {
    for (E element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
