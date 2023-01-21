import 'package:flutter/material.dart';
import 'package:flutter_speech/flutter_speech.dart';

import '../models/language.dart';

class MicrophonePage extends StatefulWidget {
  MicrophonePage({Key? key}) : super(key: key);

  @override
  State<MicrophonePage> createState() => _MicrophonePageState();
}

const lang = [
  Language('Español', 'es-ES'),
];

class _MicrophonePageState extends State<MicrophonePage> {
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
                    child: Text(
                      transcription,
                      style: TextStyle(
                        fontSize: 48.0,
                      ),
                    ),
                  ),
                ),
                _buildButton(
                  onPressed: _speechRecognitionAvailable && !_isListening
                      ? () => start()
                      : null,
                  label: _isListening
                      ? 'Listening...'
                      : 'Listen (${language.name})',
                ),
                _buildButton(
                  onPressed: _isListening ? () => cancel() : null,
                  label: 'Cancel',
                ),
                _buildButton(
                  onPressed: _isListening ? () => stop() : null,
                  label: 'Stop',
                ),
                _buildButton(
                  label: 'Analyze',
                  onPressed: !_isListening && transcription.isNotEmpty
                      ? () {
                          Navigator.pushNamed(
                            context,
                            '/results',
                            arguments: transcription,
                          );
                        }
                      : null,
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
        transcription = '';
        return _speech.listen().then((result) {
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
    setState(() {
      _isListening = false;
      transcription = text;
    });
  }

  errorHandler() => activateSpeechRecognizer();
}
