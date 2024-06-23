import 'package:flutter/material.dart';
import '../screens/workout_detail_screen.dart';
import '../database/db_helper.dart';
import '../models/workout.dart';

class WorkoutListScreen extends StatefulWidget {
  @override
  _WorkoutListScreenState createState() => _WorkoutListScreenState();
}

class _WorkoutListScreenState extends State<WorkoutListScreen> {
  late Future<List<Workout>> _workouts;

  @override
  void initState() {
    super.initState();
    _fetchWorkouts();
  }

  void _fetchWorkouts() {
    setState(() {
      _workouts = DBHelper().getWorkouts();
    });
  }

  void _deleteWorkout(int id) async {
    await DBHelper().deleteWorkout(id);
    _fetchWorkouts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workouts'),
      ),
      body: FutureBuilder<List<Workout>>(
        future: _workouts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No Workouts Found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final workout = snapshot.data![index];
                return ListTile(
                  title: Text(workout.name),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WorkoutDetailScreen(workout: workout),
                    ),
                  ).then((_) => _fetchWorkouts()), // Refresh after returning from detail screen
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteWorkout(workout.id!),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
