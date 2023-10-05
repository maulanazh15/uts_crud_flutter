class MyData {
  int ? id;
  String name;
  String email;

  MyData({this.id, required this.name, required this.email});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'email': email};
  }
}
