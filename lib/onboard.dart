
import 'package:animated_introduction/animated_introduction.dart';
import 'package:flutter/material.dart';
import 'package:signify_isl/isl_screen.dart';
import 'package:signify_isl/speech_to_text_screen.dart';


class OnBoardScreen extends StatelessWidget {

  final List<SingleIntroScreen> pages = [
    const SingleIntroScreen(
      title: 'Express Yourself Effortlessly with Signify! ✌️',
      description: 'Begin on engaging, immersive experience learning new languages️',
      imageAsset: 'assets/onboard/1.jpg',
      mainCircleBgColor: Colors.white,
      sideDotsBgColor: Colors.black,
    ),
    const SingleIntroScreen(
      title: 'Breaking Language\n Barriers 🌍✋',
      description: 'This platform offers multilingual content support, allowing seamless communication in both English and Hindi for diverse user needs.',
      imageAsset: 'assets/onboard/2.jpg',
      sideDotsBgColor: Colors.black,
      mainCircleBgColor: Colors.white,
    ),
    const SingleIntroScreen(
      title: 'Text to Sign: Bridging Communication 🌐🤟',
      description: 'Seamlessly convert text into Indian Sign Language, making your words accessible to everyone.  ',
      imageAsset: 'assets/onboard/3.jpg',
      sideDotsBgColor: Colors.black,
      mainCircleBgColor: Colors.white,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return AnimatedIntroduction(
      slides: pages,
      textColor: Colors.white,
      footerBgColor: Colors.black,
      indicatorType: IndicatorType.line,
      isFullScreen: true,
      skipText: 'Skip',
      nextText: 'Next',
      doneText: 'Start',
      topHeightForFooter: 600,
      onDone: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SpeechToTextScreen(),
          ),
        );
      },
    );
  }
}
