import 'package:flutter/material.dart';
import '../models/workout.dart';
import '../database/db_helper.dart';
import 'timer_screen.dart';  // Add this line to import TimerScreen

class WorkoutDetailScreen extends StatefulWidget {
  final Workout workout;

  const WorkoutDetailScreen({super.key, required this.workout});

  @override
  _WorkoutDetailScreenState createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen> {
void _toggleSetCompletion(Set set) async {
  if (set.id != null) {
    set.completed = !set.completed;
    await DBHelper().updateSetCompletion(set.id!, set.completed);
    setState(() {});
  } else {
    print('Error: Attempted to toggle completion on a null set.');
    // Handle error or show message to the user
  }
}


  void _startTimer(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TimerScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workout.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Workout: ${widget.workout.name}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Sets:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.workout.sets.length,
                itemBuilder: (ctx, index) {
                  final set = widget.workout.sets[index];
                  return ListTile(
                    title: Text('Set ${index + 1}'),
                    subtitle: Text('Reps: ${set.reps}, Weight: ${set.weight}'),
                    trailing: Checkbox(
                      value: set.completed,
                      onChanged: (value) {
                        _toggleSetCompletion(set);
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () => _startTimer(context),
                child: const Text('Start Timer'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
