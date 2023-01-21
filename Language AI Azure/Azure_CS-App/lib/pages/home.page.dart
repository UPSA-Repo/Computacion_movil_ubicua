import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _launch(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Language Mood Analyzer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 275,
              height: 50,
              child: ElevatedButton(
                child: const Text('Comentario único'),
                onPressed: () {
                  Navigator.pushNamed(context, '/single-text-input');
                },
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            SizedBox(
              width: 275,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/microphone');
                },
                child: const Text('Analizar audio'),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _launch(Uri(
              scheme: 'https',
              host: 'app.powerbi.com',
              path:
                  '/groups/me/reports/5d0bfe1e-4b34-4856-bacc-43b697312bff/ReportSection',
            ));
          });
        },
        child: const Icon(Icons.analytics_outlined),
      ),
    );
  }
}
