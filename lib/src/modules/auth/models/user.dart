class User {
  final String id;
  final String name;
  final String email;
  final String password;
  final String address;
  final String phoneNumber;
  final String token;

  User({
    this.id,
    this.name,
    this.email,
    this.password,
    this.address,
    this.phoneNumber,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
      // id: json["id"] == null ? null : json["id"],
      // name: json["name"] == null ? "" : json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "password": password,
        "email": email,
        "phoneNumber": phoneNumber,
        "token": token,
        "address": address,
      };
}
