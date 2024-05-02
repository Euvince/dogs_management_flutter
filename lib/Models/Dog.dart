import 'package:sqflite/sqflite.dart';


final String columnId = "id";
final String columnOld = "old";
final String columnName = "name";
final String tableName = "dogs";

class Dog {
  int? id;
  late String old;
  late String name;

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      columnOld : old,
      columnName : name,
    };
    if (id != null) map[columnId] = id;
    return map;
  }

  Dog();

  Dog.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    old = map[columnOld];
    name = map[columnName];
  }

}

class DogProvider {
  Database? database;

  Future<void> open () async {
    var databasePath = await getDatabasesPath();
    String path = databasePath + "dogs.db";
    database = await openDatabase(
      path,
      onCreate: (Database db, int version) async {
        await db.execute(
            "CREATE TABLE $tableName($columnId INTEGER PRIMARY KEY AUTOINCREMENT, $columnName VARCHAR(255) NOT NULL, $columnOld VARCHAR(255) NOT NULL)"
        );
      },
      version: 1
    );
  }

  Future<void> close () async => database!.close();

  Future<List<Dog>> getDogs () async {
    List<Dog> dogs = [];
    await open();
    List<Map<String, dynamic>> maps = await database!.query(
      tableName,
      columns: [columnId, columnOld, columnName],
    );
    await close();
    maps.forEach((element) {
      dogs.add(Dog.fromMap(element));
    });
    return dogs;
  }

  Future<Dog?> getDog (int id) async {
    await open();
    List<Map<String, dynamic>> maps = await database!.query(
      tableName,
      columns: [columnId, columnOld, columnName],
      where: "$columnId = ?",
      whereArgs: [id]
    );
    await close();
    if (maps.length > 0) return Dog.fromMap(maps.first);
    return null;
  }

  Future<Dog> insertDog (Dog dog) async {
    await open();
    dog.id = await database!.insert(tableName, dog.toMap()/*, conflictAlgorithm: ConflictAlgorithm.replace*/);
    await close();
    return dog;
  }

  Future<int> updateDog (Dog dog) async {
    await open();
    int result = await database!.update(tableName, dog.toMap(), where: "$columnId = ?", whereArgs: [dog.id]);
    await close();
    return result;
  }

  Future<int> deleteDog (int id) async {
    await open();
    int result = await database!.delete(tableName, where: "$columnId = ?", whereArgs: [id]);
    await close();
    return result;
  }

}