import 'package:flutter/material.dart';

class NewDatasetPage extends StatelessWidget {
  const NewDatasetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _datasetNameController = TextEditingController();
    TextEditingController _datasetMessageController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('New dataset'),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Dataset name',
                ),
                controller: _datasetNameController,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'New message',
                ),
                controller: _datasetMessageController,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Messages: 7'),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Add message'),
                ),
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/list-dataset');
        },
        child: Icon(Icons.search),
      ),
    );
  }
}
