// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

// Controller, required to control progress animation
class TimerProgressController {
  void Function({double beginValue, double endValue}) animateToProgress;
  void Function() resetProgress;
}

class TimerProgressLoader extends StatefulWidget {
  TimerProgressLoader({this.controller});
  final TimerProgressController controller;

  @override
  _TimerProgressLoaderState createState() =>
      _TimerProgressLoaderState(controller);
}

class _TimerProgressLoaderState extends State<TimerProgressLoader>
    with SingleTickerProviderStateMixin {
  _TimerProgressLoaderState(TimerProgressController _controller) {
    _controller.animateToProgress = animateToProgress;
    _controller.resetProgress = resetProgress;
  }

  // Animation
  Animation<double> _animation;
  AnimationController _animationController;

  // Values
  double _animationValue = 0;
  double _beginValue = 0;
  double _endValue = 1;

  // Dimens
  double _loaderSize = 300;

  // Rive
  final _animationFileRive = "images/timer-loader.riv";
  Artboard _riveArtboard;

  // Not private, so we can access it from, Homepage.
  void animateToProgress({double beginValue, double endValue}) {
    _beginValue = beginValue;
    _endValue = endValue;

    _animationController.reset();
    _assignAnimation();
    _animationController.forward();
  }

  void resetProgress() {}

  void _loadAnimationFile() async {
    final bytes = await rootBundle.load(_animationFileRive);
    final file = RiveFile();

    if (file.import(bytes)) {
      setState(() {
        _riveArtboard = file.mainArtboard
          ..addController(
            SimpleAnimation('loading-animation'),
          );
      });
    }
  }

  @override
  void initState() {
    // Load Rive file
    _loadAnimationFile();

    super.initState();

    // Initialize Animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    // Assign animation
    _assignAnimation();

    // Start animation, when page loads
    _animationController.forward();
  }

  void _assignAnimation() {
    _animation = Tween<double>(begin: _beginValue, end: _endValue)
        .animate(_animationController)

          // Add Listeners if required
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {});
  }

  @override
  Widget build(BuildContext context) {
    // Update animation value, when page updates or state updates
    _animationValue = _animation.value;

    // Loading Wrapper
    return RotatedBox(
      quarterTurns: 3,
      child: Container(
        width: _loaderSize,
        height: _loaderSize,
        child: ShaderMask(
          shaderCallback: (rect) {
            return SweepGradient(
              stops: [_animationValue, _animationValue],
              center: Alignment.center,
              colors: [
                Colors.blue,
                Colors.white.withAlpha(10),
              ],
            ).createShader(rect);
          },
          child: Container(
            width: _loaderSize,
            height: _loaderSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              /*
              image: DecorationImage(
                image: AssetImage("images/progress-bar.png"),
              ),
              */
            ),
            child: _riveArtboard != null
                ? Rive(
                    artboard: _riveArtboard,
                    fit: BoxFit.cover,
                  )
                : Container(),
          ),
        ),
      ),
    );
  }
}
