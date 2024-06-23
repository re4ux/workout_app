import 'package:flutter/material.dart';
import '../models/workout.dart';
import '../database/db_helper.dart';
import 'timer_screen.dart'; // Import the TimerScreen

class WorkoutDetailScreen extends StatefulWidget {
  final Workout workout;

  WorkoutDetailScreen({required this.workout});

  @override
  _WorkoutDetailScreenState createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen> {
  late Workout _workout;

  @override
  void initState() {
    super.initState();
    _workout = widget.workout;
  }

  void _toggleSetCompletion(Set set) async {
    if (set.id != null) {
      set.completed = !set.completed;
      await DBHelper().updateSetCompletion(set.id!, set.completed);
      setState(() {});
    } else {
      print('Error: Attempted to toggle completion on a null set.');
    }
  }

  void _startTimerScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TimerScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_workout.name),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _workout.sets.length,
              itemBuilder: (context, index) {
                final set = _workout.sets[index];
                return ListTile(
                  title: Text('Reps: ${set.reps}, Weight: ${set.weight}'),
                  trailing: Checkbox(
                    value: set.completed,
                    onChanged: (bool? value) {
                      _toggleSetCompletion(set);
                    },
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: _startTimerScreen,
            child: const Text('Start Timer'),
          ),
        ],
      ),
    );
  }
}
