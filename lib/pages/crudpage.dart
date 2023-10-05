import 'package:flutter/material.dart';
import 'package:uts_crud_flutter/helper/database_helper.dart';
import 'package:uts_crud_flutter/model/mydata.dart';

class CrudPage extends StatefulWidget {
  @override
  _CrudPageState createState() => _CrudPageState();
}

class _CrudPageState extends State<CrudPage> {
  // Di dalam _CrudPageState
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  // Fungsi untuk menambahkan data
  Future<void> addData() async {
    final name = nameController.text;
    final email = emailController.text;

    if (name.isNotEmpty && email.isNotEmpty) {
      final data = MyData(name: name, email: email);
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
        title: Text('CRUD Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: addData,
              child: Text('Add Data'),
            ),
            SizedBox(height: 20),
            Container(
              height: 125,
              decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
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
                          title: Text(data.name),
                          subtitle: Text(data.email),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      final nameController =
                                          TextEditingController(text: data.name);
                                      final emailController =
                                          TextEditingController(text: data.email);
            
                                      return AlertDialog(
                                        title: Text('Edit Data'),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextFormField(
                                              controller: nameController,
                                              decoration: InputDecoration(
                                                  labelText: 'Name'),
                                            ),
                                            TextFormField(
                                              controller: emailController,
                                              decoration: InputDecoration(
                                                  labelText: 'Email'),
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          ElevatedButton(
                                            onPressed: () async {
                                              // Ambil nilai yang diubah dari TextEditingController
                                              final newName = nameController.text;
                                              final newEmail =
                                                  emailController.text;
            
                                              // Buat objek MyData baru dengan perubahan
                                              final updatedData = MyData(
                                                id: data
                                                    .id, // Pastikan untuk menyertakan ID
                                                name: newName,
                                                email: newEmail,
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
