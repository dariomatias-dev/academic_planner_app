class ActivityTable {
  static String get tableName => 'activities';

  static String get createTableQuery =>
      '''
  CREATE TABLE $tableName(
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    notes TEXT,
    disciplineId INTEGER NOT NULL,
    dueDate TEXT,
    category TEXT,
    tags TEXT,
    reminders TEXT,
    status TEXT,
    createdAt TEXT NOT NULL,
    updatedAt TEXT NOT NULL
  )
  ''';
}
