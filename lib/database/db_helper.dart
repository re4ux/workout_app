import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/workout.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._();
  static Database? _database;

  DBHelper._();

  factory DBHelper() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('workouts.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2, // Increment version number to apply changes
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE workouts(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE sets(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            workoutId INTEGER,
            reps INTEGER,
            weight INTEGER,
            completed INTEGER DEFAULT 0,
            FOREIGN KEY (workoutId) REFERENCES workouts (id)
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE sets ADD COLUMN completed INTEGER DEFAULT 0');
        }
      },
    );
  }

  Future<int> insertWorkout(Workout workout) async {
    final db = await database;
    int workoutId = await db.insert('workouts', {'name': workout.name});

    for (Set set in workout.sets) {
      await db.insert('sets', {
        'workoutId': workoutId,
        'reps': set.reps,
        'weight': set.weight,
        'completed': set.completed ? 1 : 0,
      });
    }
    return workoutId;
  }

  Future<void> deleteWorkout(int id) async {
    final db = await database;
    await db.delete('sets', where: 'workoutId = ?', whereArgs: [id]);
    await db.delete('workouts', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateSetCompletion(int id, bool completed) async {
    final db = await database;
    await db.update(
      'sets',
      {'completed': completed ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Workout>> getWorkouts() async {
    final db = await database;
    final workoutMaps = await db.query('workouts');
    final setMaps = await db.query('sets');

    List<Workout> workouts = [];

    for (var workoutMap in workoutMaps) {
      int workoutId = workoutMap['id'] as int;
      List<Set> sets = setMaps
          .where((setMap) => setMap['workoutId'] == workoutId)
          .map((setMap) => Set(
                id: setMap['id'] as int,
                reps: setMap['reps'] as int,
                weight: setMap['weight'] as int,
                completed: setMap['completed'] == 1,
              ))
          .toList();
      workouts.add(Workout(
        id: workoutMap['id'] as int,
        name: workoutMap['name'] as String,
        sets: sets,
      ));
    }

    return workouts;
  }
}
