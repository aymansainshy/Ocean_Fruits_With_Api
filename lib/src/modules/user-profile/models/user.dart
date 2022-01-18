class User {
  final String id;
  final String name;
  final String email;
  final String address;
  final String phoneNumber;
  final String token;

  // final bool isVarified = false;
  // final int otp;

  User({
    this.id,
    this.name,
    this.email,
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
        "email": email,
        "phoneNumber": phoneNumber,
        "token": token,
        "address": address,
      };
}
