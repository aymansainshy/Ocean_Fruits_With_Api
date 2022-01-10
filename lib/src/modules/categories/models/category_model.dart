class Category {
  final String id;
  final String arName;
  final String enName;

  Category({
    this.id,
    this.arName,
    this.enName,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json["id"].toString(),
      arName: json["name_ar"],
      enName: json["name_en"],
    );
  }

  @override
  String toString() {
    return "$id - $enName";
  }
}
