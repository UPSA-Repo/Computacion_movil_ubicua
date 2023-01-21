import 'package:azurecs_app/services/azure.service.dart';
import 'package:azurecs_app/widgets/dataset.widget.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../models/message.dart';

class DatasetSelectionPage extends StatefulWidget {
  const DatasetSelectionPage({Key? key}) : super(key: key);

  @override
  State<DatasetSelectionPage> createState() => _DatasetSelectionPageState();
}

class _DatasetSelectionPageState extends State<DatasetSelectionPage> {
  bool _isLoading = true;
  late List<List<Message>> messages;

  @override
  void initState() {
    super.initState();
    _loadDataset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dataset selection'),
      ),
      body: Center(
        child: _isLoading ? CircularProgressIndicator() : _dataList(messages),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.plus_one),
        backgroundColor: Colors.green,
        onPressed: () {
          Navigator.pushNamed(context, '/new-dataset');
        },
      ),
    );
  }

  _loadDataset() async {
    var list = await AzureApi.getMessages();
    var splinted = groupBy(list, (Message msg) {
      return msg.idDataset;
    });
    setState(() {
      _isLoading = false;
      messages = splinted.values.toList();
    });
  }

  _dataList(data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: DatasetWidget(
            textToShow: 'Dataset: ${data[index][0].idDataset.toString()}',
            messages: data[index],
          ),
        );
      },
    );
  }
}
