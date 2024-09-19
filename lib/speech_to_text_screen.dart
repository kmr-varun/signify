import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
import 'package:signify_isl/language_toggle.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:http/http.dart' as http;
import 'package:translator/translator.dart';
import 'isl_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';


class SpeechToTextScreen extends StatefulWidget {
  @override
  _SpeechToTextScreenState createState() => _SpeechToTextScreenState();
}

class _SpeechToTextScreenState extends State<SpeechToTextScreen> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = "";
  String _confidence = "";
  String _selectedLanguage = 'en-IN';
  String _processedText = "";
  List<stt.LocaleName> _availableLanguages = [];

  final GroupButtonController _controller = GroupButtonController();

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _initializeSpeech();
  }

  void _initializeSpeech() async {
    bool available = await _speech.initialize();

    if (available) {
      var systemLocales = await _speech.locales();

      setState(() {
        _availableLanguages = systemLocales.where((locale) {
          return locale.localeId.contains('IN');
        }).toList();

        if (_availableLanguages.isNotEmpty) {
          _selectedLanguage = _availableLanguages.first.localeId!;
          _controller.selectIndex(0);
        }
      });
    }
  }

  void _startListening() async {
    _text = '';
    _processedText = '';
    if (_availableLanguages.isNotEmpty) {
      bool available = await _speech.initialize(
          onStatus: (val) => print('onStatus: $val'),
          onError: (val) => print('onError: $val'),
          debugLogging: true);

      if (available) {
        setState(() {
          _isListening = true;
        });

        _speech.listen(
          onResult: (val) async {
            print('Recognized Words: ${val.recognizedWords}');
            setState(() {
              _text = val.recognizedWords;
              _confidence = (val.confidence * 100).toStringAsFixed(2) + "%";
            });

            if (val.finalResult) {
              print('Final Result Detected');
              print('Selected Language: $_selectedLanguage');
              _stopListening();
            }
          },
          localeId: _selectedLanguage,
          listenFor: const Duration(seconds: 30),
        );
      }
    }
  }

  void _stopListening() async {
    print("Attempting to stop listening...");

    _speech.stop().then((_) async {
      print("Listening has been stopped");

      setState(() {
        _isListening = false;
      });

      if (_selectedLanguage.startsWith('hi')) {
        final translator = GoogleTranslator();
        try {
          var translation = await translator.translate(
            _text,
            from: 'hi',
            to: 'en',
          );

          setState(() {
            _text = translation.text;
          });

          print('Translated Text: ${translation.text}');
        } catch (e) {
          print('Translation Error: $e');
        }
      } else {
        print('Selected language is not Hindi');
      }

      try {
        final apiService = ApiService();
        final processedText = await apiService.processText(_text);

        setState(() {
          _processedText = processedText;
        });

        print("Processed Text: $_processedText");

      } catch (e) {
        print('API Error: $e');
      }
    }).catchError((e) {
      print('Stop Error: $e');
    });
  }

  void _navigateToISL() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ISLScreen(recognizedText: _processedText == '' ? _text : _processedText),
      ),
    );
  }

  @override
  void dispose() {
    _speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _confidence.isNotEmpty ? "${AppLocalizations.of(context)!.confidence}: $_confidence" : "${AppLocalizations.of(context)!.confidence}: 00",
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 100),
                    child: LanguageToggleButton(),
                  )


                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _text == '' ? AppLocalizations.of(context)!.instruction : _text.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (_processedText.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          constraints: const BoxConstraints(
                            minHeight: 80.0,
                          ),
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Processed Text:',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                _processedText.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Expanded(
                    child: SizedBox(
                      height: 56.0,
                      child: GroupButton<String>(
                        controller: _controller,
                        buttons: _availableLanguages.map((locale) => locale.name).toList(),
                        isRadio: true,
                        options: const GroupButtonOptions(
                          spacing: 0,
                          runSpacing: 0,
                          mainGroupAlignment: MainGroupAlignment.start,
                          buttonHeight: 56.0,
                          buttonWidth: 140.0,
                        ),
                        buttonIndexedBuilder: (selected, index, context) {
                          BorderRadius borderRadius;

                          if (index == 0) {
                            borderRadius = const BorderRadius.only(
                              topLeft: Radius.circular(12.0),
                              bottomLeft: Radius.circular(12.0),
                            );
                          } else if (index == _availableLanguages.length - 1) {
                            borderRadius = const BorderRadius.only(
                              topRight: Radius.circular(12.0),
                              bottomRight: Radius.circular(12.0),
                            );
                          } else {
                            borderRadius = BorderRadius.zero;
                          }

                          return Container(
                            height: 56.0,
                            width: 135.0,
                            decoration: BoxDecoration(
                              borderRadius: borderRadius,
                              color: selected ? Colors.black : Colors.white,
                            ),
                            child: Center(
                              child: Text(
                                _availableLanguages[index].name.contains('English') ? AppLocalizations.of(context)!.english : AppLocalizations.of(context)!.hindi,
                                style: TextStyle(
                                  color: selected ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                        onSelected: (String value, index, isSelected) {
                          setState(() {
                            _selectedLanguage = _availableLanguages[index].localeId!;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  FloatingActionButton(
                    onPressed: _isListening ? _stopListening : _startListening,
                    backgroundColor: Colors.black,
                    child: Icon(
                      _isListening ? Icons.mic_off : Icons.mic,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
              child: ElevatedButton(
                onPressed: _text.isNotEmpty && _processedText.isNotEmpty ? _navigateToISL : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  minimumSize: const Size(double.infinity, 56.0),
                ),
                child: Text(AppLocalizations.of(context)!.convert_text_to_isl),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ApiService {
  final String baseUrl = 'http://192.168.28.227:5001';

  Future<String> processText(String text) async {
    print(text);
    final response = await http.post(
      Uri.parse('$baseUrl/process_text'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'text': text}),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['processed_text'] as String;
    } else {
      throw Exception('Failed to process text');
    }
  }
}
