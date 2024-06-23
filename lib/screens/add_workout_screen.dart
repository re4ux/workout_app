import 'package:flutter/material.dart';
import '../models/workout.dart';
import '../database/db_helper.dart';

class AddWorkoutScreen extends StatefulWidget {
  const AddWorkoutScreen({super.key});

  @override
  _AddWorkoutScreenState createState() => _AddWorkoutScreenState();
}

class _AddWorkoutScreenState extends State<AddWorkoutScreen> {
  final _workoutNameController = TextEditingController();
  final List<Set> _sets = [];

  void _addSet() {
    setState(() {
      _sets.add(Set(reps: 0));
    });
  }

  void _saveWorkout() async {
    if (_workoutNameController.text.isEmpty || _sets.isEmpty) return;
    final workout = Workout(name: _workoutNameController.text, sets: _sets);
    await DBHelper().insertWorkout(workout);
    Navigator.pop(context, workout);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Workout'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveWorkout,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _workoutNameController,
              decoration: const InputDecoration(labelText: 'Workout Name'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _sets.length,
                itemBuilder: (ctx, index) {
                  return ListTile(
                    title: Text('Set ${index + 1}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              _sets.removeAt(index);
                            });
                          },
                        ),
                      ],
                    ),
                    subtitle: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'Reps'),
                            onChanged: (value) {
                              _sets[index].reps = int.parse(value);
                            },
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'Weight'),
                            onChanged: (value) {
                              _sets[index].weight = int.parse(value);
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _addSet,
              child: const Text('Add Set'),
            ),
          ],
        ),
      ),
    );
  }
}
