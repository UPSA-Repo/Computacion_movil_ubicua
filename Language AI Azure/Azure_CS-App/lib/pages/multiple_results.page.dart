import 'package:azurecs_app/models/multiple_analysis.dart';
import 'package:flutter/material.dart';
import '../models/message.dart';
import '../models/new_message.dart';
import '../services/azure.service.dart';
import '../utils/utils.dart';

class MultipleResultsPage extends StatefulWidget {
  MultipleResultsPage({
    Key? key,
    required this.messages,
  }) : super(key: key);

  final MultipleAnalysis messages;

  @override
  State<MultipleResultsPage> createState() => _MultipleResultsPageState();
}

class _MultipleResultsPageState extends State<MultipleResultsPage> {
  bool _isLoading = true;
  List<Message> messages = [];

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
            _isLoading ? CircularProgressIndicator() : loadedWidget(messages),
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
    List<NewMessage> listMessages = [];
    for (var data in widget.messages.messages) {
      listMessages.add(NewMessage(
        message: data,
        id: widget.messages.idDataset,
      ));
    }
    await AzureApi.deleteByDataset(widget.messages.idDataset);
    var msg = await AzureApi.postMessages(listMessages);
    setState(() {
      _isLoading = false;
      messages = msg;
    });
  }

  loadedWidget(data) {
    var positiveAvg = 0.0;
    var neutralAvg = 0.0;
    var negativeAvg = 0.0;

    for (var d in data) {
      positiveAvg += d.positive;
      neutralAvg += d.neutral;
      negativeAvg += d.negative;
    }

    positiveAvg = positiveAvg / data.length;
    neutralAvg = neutralAvg / data.length;
    negativeAvg = negativeAvg / data.length;

    var sentiment = Utils.GetSentiment(positiveAvg, neutralAvg, negativeAvg);

    return Column(
      children: [
        Text(sentiment),
        Text('Positivo: ${double.parse((positiveAvg).toStringAsFixed(2))}%'),
        Text('Neutral: ${double.parse((neutralAvg).toStringAsFixed(2))}%'),
        Text('Negativo: ${double.parse((negativeAvg).toStringAsFixed(2))}%'),
      ],
    );
  }
}
