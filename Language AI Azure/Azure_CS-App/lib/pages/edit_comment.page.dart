import 'package:flutter/material.dart';

class EditCommentPage extends StatelessWidget {
  String comment;
  EditCommentPage({Key? key, required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _commentController =
        TextEditingController(text: comment);
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit comment'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 20.0,
            ),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Enter your text',
              ),
              controller: _commentController,
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
