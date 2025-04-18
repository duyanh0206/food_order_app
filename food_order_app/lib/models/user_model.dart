class UserModel {
  final int? id;
  final String name;
  final String email;
  final String password;
  final DateTime? createdAt;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    this.createdAt,
  });

  // Chuyển đổi từ đối tượng UserModel thành Map để lưu vào DB
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'created_at':
          createdAt?.toIso8601String(), // Chuyển DateTime thành String (nếu có)
    };
  }

  // Tạo đối tượng UserModel từ Map (khi lấy dữ liệu từ DB)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      // Xử lý nullable 'created_at'
      createdAt:
          map['created_at'] != null
              ? DateTime.parse(map['created_at'] as String)
              : null,
    );
  }

  // Hàm copyWith để tạo đối tượng UserModel mới từ đối tượng hiện tại
  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? password,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
