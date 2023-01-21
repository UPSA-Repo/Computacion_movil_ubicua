import 'package:flutter/material.dart';
import 'package:flutter_speech/flutter_speech.dart';

import 'language.dart';

class FSpeechPage extends StatefulWidget {
  FSpeechPage({Key? key}) : super(key: key);

  @override
  State<FSpeechPage> createState() => _FSpeechPageState();
}

const lang = [
  Language('Español', 'es-ES'),
];

class _FSpeechPageState extends State<FSpeechPage> {
  late SpeechRecognition _speech;
  bool _speechRecognitionAvailable = false;
  bool _isListening = false;
  String transcription = '';
  Language language = lang.first;

  @override
  initState() {
    super.initState();
    activateSpeechRecognizer();
  }

  activateSpeechRecognizer() {
    print('_FSpeechPageState.activateSpeechRecognizer');
    _speech = SpeechRecognition();
    _speech.setAvailabilityHandler(onSpeechAvailability);
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    _speech.setErrorHandler(errorHandler);
    _speech.activate('es-ES').then((res) {
      setState(() {
        _speechRecognitionAvailable = res;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SpeechRecognition'),
        actions: [
          PopupMenuButton<Language>(
            onSelected: _selectLangHandler,
            itemBuilder: (BuildContext context) => _buildLanguagesWidgets,
          )
        ],
      ),
      body: Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                    child: Container(
                        padding: const EdgeInsets.all(8.0),
                        color: Colors.grey.shade200,
                        child: Text(transcription))),
                _buildButton(
                  onPressed: _speechRecognitionAvailable && !_isListening
                      ? () => start()
                      : null,
                  label: _isListening
                      ? 'Listening...'
                      : 'Listen (${language.code})',
                ),
                _buildButton(
                  onPressed: _isListening ? () => cancel() : null,
                  label: 'Cancel',
                ),
                _buildButton(
                  onPressed: _isListening ? () => stop() : null,
                  label: 'Stop',
                ),
              ],
            ),
          )),
    );
  }

  List<CheckedPopupMenuItem<Language>> get _buildLanguagesWidgets => lang
      .map((l) => CheckedPopupMenuItem<Language>(
            value: l,
            checked: language == l,
            child: Text(l.name),
          ))
      .toList();

  Widget _buildButton({required String label, VoidCallback? onPressed}) =>
      Padding(
        padding: const EdgeInsets.all(12.0),
        child: ElevatedButton(
          onPressed: onPressed,
          child: Text(
            label,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );

  _selectLangHandler(Language lang) {
    setState(() => language = lang);
  }

  start() => _speech.activate(language.code).then((_) {
        return _speech.listen().then((result) {
          print('_MyAppState.start => result $result');
          setState(() {
            _isListening = result;
          });
        });
      });

  cancel() =>
      _speech.cancel().then((_) => setState(() => _isListening = false));

  stop() => _speech.stop().then((_) {
        setState(() => _isListening = false);
      });

  onSpeechAvailability(bool result) => setState(() {
        _speechRecognitionAvailable = result;
      });

  onRecognitionStarted() {
    setState(() {
      _isListening = true;
    });
  }

  onRecognitionResult(String text) {
    setState(() {
      transcription = text;
    });
  }

  onRecognitionComplete(String text) {
    print('Completed: $text');
    setState(() {
      _isListening = false;
    });
  }

  errorHandler() => activateSpeechRecognizer();
}
