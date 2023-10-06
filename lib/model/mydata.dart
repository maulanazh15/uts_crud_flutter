class MyData {
  int ? id;
  String nama_makanan;
  String resep_makanan;

  MyData({this.id, required this.nama_makanan, required this.resep_makanan});

  Map<String, dynamic> toMap() {
    return {'id': id, 'nama_makanan': nama_makanan, 'resep_makanan': resep_makanan};
  }
}
