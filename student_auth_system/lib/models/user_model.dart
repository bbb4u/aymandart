/// نموذج بيانات الطالب (User Model)
class UserModel {
  final String id;
  final String fullName;
  final String academicId;
  final String email;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.academicId,
    required this.email,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String? ?? '',
      fullName: map['fullName'] as String? ?? '',
      academicId: map['academicId'] as String? ?? '',
      email: map['email'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'academicId': academicId,
      'email': email,
    };
  }

  UserModel copyWith({
    String? id,
    String? fullName,
    String? academicId,
    String? email,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      academicId: academicId ?? this.academicId,
      email: email ?? this.email,
    );
  }

  @override
  String toString() =>
      'UserModel(id: $id, fullName: $fullName, academicId: $academicId, email: $email)';
}
