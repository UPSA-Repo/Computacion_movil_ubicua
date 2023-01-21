import 'package:flutter/material.dart';

class SingleTextInputPage extends StatelessWidget {
  SingleTextInputPage({Key? key}) : super(key: key);
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Single text analysis'),
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
              autofocus: false,
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter your text',
              ),
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
                    Navigator.pushNamed(context, '/results',
                        arguments: _controller.text);
                  },
                  child: const Text('Analyze'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
