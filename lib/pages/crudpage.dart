import 'package:flutter/material.dart';
import 'package:uts_crud_flutter/helper/database_helper.dart';
import 'package:uts_crud_flutter/model/mydata.dart';

class CrudPage extends StatefulWidget {
  @override
  _CrudPageState createState() => _CrudPageState();
}

class _CrudPageState extends State<CrudPage> {
  // Di dalam _CrudPageState
  final namaMakananController = TextEditingController();
  final resepMakananController = TextEditingController();

  // Fungsi untuk menambahkan data
  Future<void> addData() async {
    final nama_makanan = namaMakananController.text;
    final resep_makanan = resepMakananController.text;

    if (nama_makanan.isNotEmpty && resep_makanan.isNotEmpty) {
      final data = MyData(nama_makanan: nama_makanan, resep_makanan: resep_makanan);
      await DatabaseHelper.instance.insertData(data);
      // Refresh UI to show updated data
      setState(() {});
    }
  }

// Fungsi untuk mendapatkan data
  Future<List<MyData>> getData() async {
    return await DatabaseHelper.instance.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CRUD Resep Makanan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: namaMakananController,
              decoration: InputDecoration(labelText: 'Nama Makanan'),
            ),
            TextFormField(
              controller: resepMakananController,
              decoration: InputDecoration(labelText: 'Resep Makanan'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: addData,
              child: Text('Tambah Resep Baru'),
            ),
            SizedBox(height: 20),
            Center(child: Text("List Resep Makanan"),),
            SizedBox(height: 20,),
            Container(
              height: 200,
              decoration: BoxDecoration(border: Border.all(color: Colors.black12), borderRadius: BorderRadius.circular(4)),
              child: FutureBuilder(
                future: getData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('No data available.');
                  } else {
                    final dataList = snapshot.data as List<MyData>;
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: dataList.length,
                      itemBuilder: (context, index) {
                        final data = dataList[index];
                        return ListTile(
                          title: Text(data.nama_makanan),
                          subtitle: Text(data.resep_makanan),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      final namaMakananController =
                                          TextEditingController(text: data.nama_makanan);
                                      final resepMakananController =
                                          TextEditingController(text: data.resep_makanan);
            
                                      return AlertDialog(
                                        title: Text('Edit Data Resep Makanan'),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextFormField(
                                              controller: namaMakananController,
                                              decoration: InputDecoration(
                                                  labelText: 'Nama Makanan'),
                                            ),
                                            TextFormField(
                                              controller: resepMakananController,
                                              decoration: InputDecoration(
                                                  labelText: 'Resep Makanan'),
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          ElevatedButton(
                                            onPressed: () async {
                                              // Ambil nilai yang diubah dari TextEditingController
                                              final newNamaMakanan = namaMakananController.text;
                                              final newResepMakanan =
                                                  resepMakananController.text;
            
                                              // Buat objek MyData baru dengan perubahan
                                              final updatedData = MyData(
                                                id: data
                                                    .id, // Pastikan untuk menyertakan ID
                                                nama_makanan: newNamaMakanan,
                                                resep_makanan: newResepMakanan,
                                              );
            
                                              // Implementasi untuk menyimpan perubahan ke database
                                              await DatabaseHelper.instance
                                                  .updateData(updatedData);
                                              Navigator.of(context)
                                                  .pop(); // Tutup dialog
                                              setState(() {}); // Refresh UI
                                            },
                                            child: Text('Save'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(); // Tutup dialog tanpa menyimpan perubahan
                                            },
                                            child: Text('Cancel'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Konfirmasi Hapus'),
                                        content: Text(
                                            'Apakah Anda yakin ingin menghapus data ini?'),
                                        actions: [
                                          ElevatedButton(
                                            onPressed: () async {
                                              // Implementasi untuk menghapus data dari database
                                              await DatabaseHelper.instance
                                                  .deleteData(data.id);
                                              Navigator.of(context)
                                                  .pop(); // Tutup dialog konfirmasi
                                              setState(() {}); // Refresh UI
                                            },
                                            child: Text('Ya'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(); // Tutup dialog konfirmasi
                                            },
                                            child: Text('Tidak'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                          // Implement edit and delete functionality here
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
