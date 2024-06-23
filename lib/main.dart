import 'package:flutter/material.dart';
import 'screens/add_workout_screen.dart';
import 'screens/timer_screen.dart';
import 'screens/workout_detail_screen.dart';
import 'models/workout.dart';
import 'database/db_helper.dart';

void main() {
  runApp(WorkoutApp());
}

class WorkoutApp extends StatelessWidget {
  const WorkoutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workout App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WorkoutHomePage(),
    );
  }
}

class WorkoutHomePage extends StatefulWidget {
  const WorkoutHomePage({super.key});

  @override
  _WorkoutHomePageState createState() => _WorkoutHomePageState();
}

class _WorkoutHomePageState extends State<WorkoutHomePage> {
  List<Workout> _workouts = [];

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
  }

  void _loadWorkouts() async {
    final workouts = await DBHelper().getWorkouts();
    setState(() {
      _workouts = workouts;
    });
  }

  void _addWorkout(BuildContext context) async {
    final newWorkout = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddWorkoutScreen()),
    );

    if (newWorkout != null) {
      setState(() {
        _workouts.add(newWorkout);
      });
    }
  }

  void _deleteWorkout(int id) async {
    await DBHelper().deleteWorkout(id);
    _loadWorkouts();
  }

  void _openWorkoutDetail(BuildContext context, Workout workout) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkoutDetailScreen(workout: workout),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout App'),
      ),
      body: ListView.builder(
        itemCount: _workouts.length,
        itemBuilder: (ctx, index) {
          final workout = _workouts[index];
          return ListTile(
            title: Text(workout.name),
            onTap: () => _openWorkoutDetail(context, workout),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _deleteWorkout(workout.id!),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addWorkout(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
