class User {
  String id;
  String nickname;
  String email;

  User({this.id, this.nickname, this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    User user = new User();
    user.email = json['email'];
    user.id = json['id'];
    user.nickname = json['nickname'];
    return user;
  }
}
