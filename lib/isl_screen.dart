import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';

class ISLScreen extends StatefulWidget {
  final String recognizedText;

  ISLScreen({required this.recognizedText});

  @override
  _ISLScreenState createState() => _ISLScreenState();
}

class _ISLScreenState extends State<ISLScreen> {
  late List<String> _characters;
  int _currentIndex = 0;
  Timer? _timer;
  bool _animationStarted = false;
  bool _isBlinking = false; // Track blinking state
  double _opacity = 1.0; // Opacity state

  @override
  void initState() {
    super.initState();
    _characters = widget.recognizedText
        .toLowerCase()
        .split('')
        .where((char) => RegExp(r'[a-z0-9]').hasMatch(char))
        .toList();

    print("Characters: $_characters"); // Debug print
  }

  void _startImageDisplay() {
    _currentIndex = 0; // Reset current index
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (_currentIndex >= _characters.length) {
        timer.cancel();
        setState(() {
          _animationStarted = false; // Allow the animation to start again
        });
      } else {
        // Start blinking effect
        setState(() {
          _isBlinking = true;
        });

        Timer(Duration(milliseconds: 500), () {
          setState(() {
            _isBlinking = false;
            _currentIndex++;
          });
        });
      }
    });
  }

  void _replayAnimation() {
    if (_animationStarted) {
      // If the animation is already running, cancel the current timer
      _timer?.cancel();
    }
    setState(() {
      _animationStarted = true;
    });
    _startImageDisplay();
  }

  @override
  void dispose() {
    _timer?.cancel(); // Safe cancellation with null check
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.convert_text_to_isl),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Display received text

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
                    Text(
                      AppLocalizations.of(context)!.process_text,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      widget.recognizedText.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),
              // Fixed height image container
              Container(
                height: 250,
                child: _currentIndex > 0
                    ? Column(
                        children: <Widget>[
                          Expanded(
                            child: AnimatedOpacity(
                              opacity: _isBlinking ? 0.0 : 1.0,
                              duration: Duration(milliseconds: 200),
                              child: Image.asset(
                                'assets/images2/${_characters[_currentIndex - 1]}.png',
                                width: 250,
                                height: 250,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          AnimatedOpacity(
                            opacity: _isBlinking ? 0.0 : 1.0,
                            duration: Duration(milliseconds: 200),
                            child: Text(
                              _characters[_currentIndex - 1].toUpperCase(),
                              style: TextStyle(fontSize: 24),
                            ),
                          ),
                        ],
                      )
                    : Container(
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!.view_isl_translation,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ), // Empty container if no image is being displayed
              ),
              SizedBox(height: 20),
              // Play Animation Button
              ElevatedButton(
                onPressed: _replayAnimation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Set background to black
                  foregroundColor: Colors.white, // Set text color to white
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 24.0), // Add padding to the button
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(12.0), // Make the button rounded
                  ),
                  minimumSize: Size(double.infinity,
                      56.0), // Set height to 56 and width to fill the container
                ),
                child: Text(AppLocalizations.of(context)!.translate),
              )
            ],
          ),
        ),
      ),
    );
  }
}
