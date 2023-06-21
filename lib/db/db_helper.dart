import 'package:sqflite/sqflite.dart' as sql;

class DbHelper {
  static const String _patientsTable = 'patients';
  static const String _exercisesTable = 'exercises';
  static const String _patientExerciseTable = 'patient_exercise';

  static Future<void> createTables(sql.Database database) async {
    await database.execute('''
  CREATE TABLE IF NOT EXISTS $_exercisesTable (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    description TEXT NOT NULL,
    startTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  )
''');

    await database.execute('''
  CREATE TABLE IF NOT EXISTS $_patientExerciseTable (
    patient_id INTEGER NOT NULL,
    exercise_id INTEGER NOT NULL,
    isProgrammed INTEGER NOT NULL DEFAULT 0,
    isDone INTEGER NOT NULL DEFAULT 0,
    FOREIGN KEY (patient_id) REFERENCES $_patientsTable (id),
    FOREIGN KEY (exercise_id) REFERENCES $_exercisesTable (id),
    PRIMARY KEY (patient_id, exercise_id)
  )
''');

    await database.execute('''
  CREATE TABLE IF NOT EXISTS $_patientsTable (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    age INTEGER NOT NULL,
    disease TEXT NOT NULL,
    isActive INTEGER NOT NULL DEFAULT 0
  )
''');
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'mypatientsapp.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<int> insert(String table, Map<String, Object?> data) async {
    final sql.Database database = await db();
    return database.insert(table, data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final sql.Database database = await db();
    return database.query(table);
  }

  static Future delete(String table, int? id) async {
    final sql.Database database = await db();
    return database.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  static Future deleteExercise(int? id) async {
    final sql.Database database = await db();
    database.rawDelete('''
      DELETE FROM $_exercisesTable
      WHERE id = $id
    ''');
  }

  static Future getActivePatients() async {
    final sql.Database database = await db();
    return database.rawQuery('''
      SELECT * FROM $_patientsTable
      WHERE isActive = 1
    ''');
  }

  static Future<int> update(
      String table, Map<String, Object?> data, int? id) async {
    final sql.Database database = await db();
    return database.update(table, data, where: 'id = ?', whereArgs: [id]);
  }

  static Future setPatientIsActive(int id, int isActive) async {
    final sql.Database database = await db();
    return database.rawUpdate('''
      UPDATE $_patientsTable
      SET isActive = $isActive
      WHERE id = $id
    ''');
  }

  static Future setExerciseIsDone(int id, int isDone) async {
    final sql.Database database = await db();
    return database.rawUpdate('''
      UPDATE $_patientExerciseTable
      SET isDone = $isDone
      WHERE id = $id
    ''');
  }

  static Future setExerciseIsProgrammed(
      int patientId, int exerciseId, int isProgrammed) async {
    final sql.Database database = await db();
    return database.rawUpdate('''
      UPDATE $_patientExerciseTable
      SET isProgrammed = $isProgrammed
      WHERE patient_id = $patientId AND exercise_id = $exerciseId
    ''');
  }

  static Future<List<Map<String, dynamic>>> getPatientExercises(
      int patientId) async {
    final sql.Database database = await db();
    return database.rawQuery('''
      SELECT * FROM $_exercisesTable
      INNER JOIN $_patientExerciseTable
      ON $_exercisesTable.id = $_patientExerciseTable.exercise_id
      WHERE $_patientExerciseTable.patient_id = $patientId
    ''');
  }

  static Future<List<Map<String, dynamic>>> getPatientCompletedExercises(
      int patientId) async {
    final sql.Database database = await db();
    return database.rawQuery('''
      SELECT * FROM $_exercisesTable
      INNER JOIN $_patientExerciseTable
      ON $_exercisesTable.id = $_patientExerciseTable.exercise_id
      WHERE $_patientExerciseTable.patient_id = $patientId
      AND $_exercisesTable.endTime IS NOT NULL
    ''');
  }

  static Future getPatientExerciseId(int patientId, int exerciseId) async {
    final sql.Database database = await db();
    return database.rawQuery('''
      SELECT * FROM $_patientExerciseTable
      WHERE patient_id = $patientId AND exercise_id = $exerciseId
    ''');
  }

  static Future<List<Map<String, dynamic>>> getPatientExercisesByDate(
      int patientId, String date) async {
    final sql.Database database = await db();
    return database.rawQuery('''
      SELECT * FROM $_exercisesTable
      INNER JOIN $_patientExerciseTable
      ON $_exercisesTable.id = $_patientExerciseTable.exercise_id
      WHERE $_patientExerciseTable.patient_id = $patientId
      AND $_exercisesTable.endTime IS NOT NULL
      AND $_exercisesTable.endTime LIKE '$date%'
    ''');
  }

  static Future<int> deletePatientExercise(
      int patientId, int exerciseId) async {
    final sql.Database database = await db();
    return database.rawDelete('''
      DELETE FROM $_patientExerciseTable
      WHERE patient_id = $patientId AND exercise_id = $exerciseId
    ''');
  }

  static Future<int> updatePatientExercise(
      int patientId, int exerciseId, String column, String value) async {
    final sql.Database database = await db();
    return database.rawUpdate('''
      UPDATE $_exercisesTable
      SET $column = '$value'
      WHERE id = $exerciseId
    ''');
  }

  static Future getPatientProgrammedExercises(int patientId) async {
    final sql.Database database = await db();
    return database.rawQuery('''
      SELECT * FROM $_exercisesTable
      INNER JOIN $_patientExerciseTable
      ON $_exercisesTable.id = $_patientExerciseTable.exercise_id
      WHERE $_patientExerciseTable.patient_id = $patientId
      AND $_patientExerciseTable.isProgrammed = 1
    ''');
  }
}
