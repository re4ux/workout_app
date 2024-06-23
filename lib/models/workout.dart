class Set {
  int? id;
  int reps;
  int weight;
  bool completed;

  Set({this.id, required this.reps, this.weight = 0, this.completed = false});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'reps': reps,
      'weight': weight,
      'completed': completed ? 1 : 0, // Ensure this converts bool to integer correctly
    };
  }
}

class Workout {
  int? id;
  String name;
  List<Set> sets;

  Workout({this.id, required this.name, this.sets = const []});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}
