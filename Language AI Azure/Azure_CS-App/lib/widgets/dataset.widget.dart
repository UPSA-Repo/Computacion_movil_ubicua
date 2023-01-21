import 'package:flutter/material.dart';

import '../models/message.dart';

class DatasetWidget extends StatelessWidget {
  final String textToShow;
  final List<Message> messages;
  const DatasetWidget(
      {Key? key, required this.textToShow, required this.messages})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/list-dataset', arguments: messages);
      },
      child: Container(
        height: 100,
        width: 350,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(3, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              textToShow,
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
