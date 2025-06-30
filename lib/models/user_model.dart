class UserModel {
  final String id;
  final String username;
  final String email;
  final DateTime dateNaissance;
  final DateTime dateCreation;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.dateNaissance,
    required this.dateCreation,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      dateNaissance: DateTime.parse(map['dateNaissance']),
      dateCreation: DateTime.parse(map['dateCreation']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'dateNaissance': dateNaissance.toIso8601String(),
      'dateCreation': dateCreation.toIso8601String(),
    };
  }

  String get initiale => username.isNotEmpty ? username[0].toUpperCase() : '?';
} 