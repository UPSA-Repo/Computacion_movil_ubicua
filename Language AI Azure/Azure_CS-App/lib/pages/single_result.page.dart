import 'package:azurecs_app/models/new_message.dart';
import 'package:azurecs_app/services/azure.service.dart';
import 'package:flutter/material.dart';

import '../models/message.dart';

class SingleResultPage extends StatefulWidget {
  const SingleResultPage({Key? key, required this.messageContent})
      : super(key: key);
  final String messageContent;
  @override
  State<SingleResultPage> createState() => _SingleResultPageState();
}

class _SingleResultPageState extends State<SingleResultPage> {
  bool _isLoading = true;
  Message? message;
  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Results'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/faceid.png'),
                ),
              ),
            ),
            _isLoading ? CircularProgressIndicator() : loadedWidget(),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).popUntil(ModalRoute.withName('/'));
              },
              child: Text(
                'Inicio',
              ),
            ),
          ],
        ),
      ),
    );
  }

  loadData() async {
    var msg = await AzureApi.postMessage(NewMessage(
      message: widget.messageContent,
      id: -1,
    ));
    setState(() {
      message = msg;
      _isLoading = false;
    });
  }

  loadedWidget() {
    return Column(
      children: [
        Text('${message?.sentiment}'),
        Text('Positivo: ${message?.positive}%'),
        Text('Neutral: ${message?.neutral}%'),
        Text('Negativo: ${message?.negative}%'),
      ],
    );
  }
}
