class UserData {
  final int id;
  final String login;
  final String pass;
  final String role;

  UserData({
    required this.id,
    required this.login,
    required this.pass,
    required this.role,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: int.parse(json['id']),
      login: json['login'],
      pass: json['pass'],
      role: json['role'],
    );
  }
}
