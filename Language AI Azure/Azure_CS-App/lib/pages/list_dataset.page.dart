import 'package:azurecs_app/models/multiple_analysis.dart';
import 'package:azurecs_app/widgets/text_container.widget.dart';
import 'package:flutter/material.dart';

import '../models/message.dart';

class ListDatasetPage extends StatelessWidget {
  ListDatasetPage({Key? key, required this.messages}) : super(key: key);
  List<Message> messages;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List dataset'),
      ),
      body: Center(
        child: ListView.separated(
          physics: BouncingScrollPhysics(),
          separatorBuilder: (context, index) => const SizedBox(
            height: 5,
          ),
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: TextContainerWidget(
                textToShow: messages[index].text,
              ),
            );
          },
          itemCount: messages.length,
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          MultipleAnalysis multipleAnalysis = MultipleAnalysis(
            idDataset: messages.first.idDataset!,
            messages: messages.map((e) => e.text).toList(),
          );
          Navigator.pushNamed(
            context,
            '/multiple-results',
            arguments: multipleAnalysis,
          );
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        backgroundColor: Colors.amber,
        label: Text(
          'Analyze',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
