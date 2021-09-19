// @dart=2.9
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wings_hq/pages/timer_progress.dart';

void main() => runApp(TimerApp());

class TimerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meditation Timer', style: TextStyle(color: Colors.black),),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black
        ),
      ),
      body: TimerPage(),
    );
  }
}

class TimerPage extends StatefulWidget {
  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  // Timer
  Timer _timer;

  // Timer Controls
  int _startTime = 0;
  int _currentTime = 0;

  int _progress = 100;

  // Text Field and buttons
  TextEditingController _timerTextController = TextEditingController();
  String _btnText = "Start Timer";

  bool _isTimerRunning = false;
  bool _isTextEnabled = true;

  // Animation Controller
  TimerProgressController _progressController = TimerProgressController();

  void _startTimer() {
    // Set timer start
    _setTimerStart();

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_currentTime > 0) {
        // Change current time
        _currentTime--;

        // Set text field value
        _timerTextController.text = _currentTime.toString();

        // Set timer progress
        _progressController.animateToProgress(
          beginValue: _calcProgress(_currentTime + 1) / 100,
          endValue: _calcProgress(_currentTime) / 100,
        );
      } else {
        // Stop Timer
        _setTimerStop();
      }
    });
    ;
  }

  int _calcProgress(int number) {
    _progress = ((number / _startTime) * 100).round();
    return _progress;
  }

  void _setTimerStart() {
    setState(() {
      _isTimerRunning = true;
      _isTextEnabled = false;

      _btnText = "Stop Timer";
    });
  }

  void _setTimerStop() {
    setState(() {
      _timerTextController.text = "";

      _progressController.animateToProgress(
        beginValue: _calcProgress(_currentTime) / 100,
        endValue: 1,
      );

      _isTimerRunning = false;
      _isTextEnabled = true;

      _btnText = "Start Timer";

      _timer.cancel();
    });
  }

  // @override
  // void dispose() {
  //   _timer.cancel();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff1efe5),
      //backgroundColor: Color(0xFF111111),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image.asset(
          //   "images/meditate.png",
          //   height:150,
          // ),
           Text("Switch on the Timer and medidate.", 
          style: TextStyle( fontSize:24,fontFamily:"SF Pro")),
          SizedBox(height:16),
          // Timer Container, with text field and loading animation
          Stack(
            children: [
              // Loading Animation
             // SizedBox(height:10),
              Center(
                child: TimerProgressLoader(
                  controller: _progressController,
                ),
              ),

              // Timer Text Field
              Center(
                child: Container(
                  
                  height: 300,
                  width: 300,
                  alignment: Alignment.center,
                  child: TextField(
                    enabled: _isTextEnabled,
                    controller: _timerTextController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "0",
                      hintStyle: TextStyle(
                        color: Colors.black.withAlpha(90),
                      ),
                    ),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 56,
                      fontFamily: "SF Pro",
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Spacing
          SizedBox(
            height: 36,
          ),

          // Timer Start/Stop Button
          TextButton(
            onPressed: () {
              // Check if timer is already running
              if (!_isTimerRunning) {
                // Get text from field
                String timerTextValue = _timerTextController.text.toString();
                print("Timer Text: $timerTextValue");
                if (timerTextValue.isNotEmpty) {
                  // Get Time
                  int time = int.parse(timerTextValue);

                  // Set time
                  _startTime = time;
                  _currentTime = time;

                  _startTimer();
                }
              } else {
                _setTimerStop();
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              
              child: Text(
                _btnText,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontFamily: "SF Pro",
                ),
                
              ),
            ),
            
          ),
        ],
      ),
    );
  }
}
