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
              // width: 200,
              decoration: BoxDecoration(border: Border.all(color: Colors.black26)),
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
