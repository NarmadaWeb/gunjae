class User {
  final String? id;
  final String name;
  final String email;
  final String password;
  final String? avatarUrl;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    this.avatarUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'avatarUrl': avatarUrl,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
      avatarUrl: map['avatarUrl'],
    );
  }
}
