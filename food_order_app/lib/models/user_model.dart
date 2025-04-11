class UserModel {
  final int? id;
  final String? name;
  final String? email;
  final String? password;

  UserModel({this.id, this.name, this.email, this.password});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'email': email, 'password': password};
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
    );
  }
}
