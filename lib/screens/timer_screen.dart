import 'package:flutter/material.dart';
import 'dart:async';
import 'package:vibration/vibration.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({Key? key}) : super(key: key);

  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  int _time = 120; // 2 minutes
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_time > 0) {
          _time--;
        } else {
          _timer!.cancel();
          Vibration.vibrate();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$_time',
              style: const TextStyle(fontSize: 48),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _startTimer,
              child: const Text('Restart Timer'),
            ),
          ],
        ),
      ),
    );
  }
}
