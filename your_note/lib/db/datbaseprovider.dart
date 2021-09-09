import 'dart:async'; 
import 'dart:io'; 
import 'package:path_provider/path_provider.dart'; 
import 'package:sqflite/sqflite.dart';
import 'package:your_note/models/notes.dart'; 

class DatabaseProvider {
  static DatabaseProvider _databaseProvider; 
  static Database _database; 

  String nTable =
      'note_table'; 
  String nId = 'id';
  String nTitle = 'title';
  String nDesc = 'description';
  String nPrior = 'priority';
  String nDate = 'date';

  DatabaseProvider._createInstance();

  factory DatabaseProvider() {
    
    if (_databaseProvider == null) {
      _databaseProvider = DatabaseProvider._createInstance();
    }
    return _databaseProvider; 
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDataBase();
    }
    return _database;
  }

  Future<Database> initializeDataBase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'your_note.database';

    var notesdatabase =
        await openDatabase(path, version: 1, onCreate: _createdatabase);
    return notesdatabase;
  }

  void _createdatabase(Database database, int newVersion) async {
    await database
        .execute('CREATE TABLE $nTable($nId INTEGER PRIMARY KEY AUTOINCREMENT,'
            '$nTitle TEXT, $nDesc TEXT, $nDate TEXT, $nPrior INTEGER)');
  }

  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database database = await this.database;
    
    var result = await database.query(nTable, orderBy: '$nPrior ASC');
    return result;
  }

  Future<int> insertNote(Note note) async {
    Database database = await this.database;
    var result = await database.insert(nTable, note.toMap());
    return result;
  }

  Future<int> updateNote(Note note) async {
    Database database = await this.database;
    var result = await database
        .update(nTable, note.toMap(), where: '$nId = ?', whereArgs: [note.id]);
    return result;
  }

  Future<int> deleteNote(int id) async {
    var database = await this.database;
    var result =
        await database.rawDelete('DELETE FROM $nTable WHERE $nId = $id');
    return result;
  }

  Future<int> getCount() async {
    Database database = await this.database;
    List<Map<String, dynamic>> list =
        await database.rawQuery('SELECT COUNT(*) FROM $nTable');
    int result = Sqflite.firstIntValue(list);
    return result;
  }

  Future<List<Note>> getNoteList() async {
    var noteMapList = await getNoteMapList();
    int count = noteMapList.length;

    List<Note> noteList = <Note>[];
    for (int i = 0; i < count; i++) {
      noteList.add(Note.fromMapObject(noteMapList[i]));
    }

    return noteList;
  }
}
