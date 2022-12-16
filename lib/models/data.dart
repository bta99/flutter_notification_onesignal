class Data {
  int? id;
  int? userId;
  String? title;

  Data({required this.id, required this.userId, required this.title});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
  }
}
