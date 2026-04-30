class UserModel {
  final String id;
  final String name;
  final String phone;
  final String role; // 'client', 'driver', 'admin'
  final bool isActive;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.role,
    this.isActive = true,
  });

  Map<String, dynamic> toMap() => {
    'id': id, 'name': name, 'phone': phone,
    'role': role, 'isActive': isActive,
  };

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
    id: map['id'], name: map['name'], phone: map['phone'],
    role: map['role'], isActive: map['isActive'] ?? true,
  );
}
