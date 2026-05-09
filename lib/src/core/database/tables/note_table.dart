class NoteTable {
  static String get tableName => 'notes';

  static String get createTableQuery =>
      '''
  CREATE TABLE $tableName(
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    disciplineId INTEGER NOT NULL,
    createdAt TEXT NOT NULL,
    updatedAt TEXT NOT NULL
  )
  ''';
}
