import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main () async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = openDatabase(
    join(await getDatabasesPath(), "dogs.db"),
    onCreate: (Database db, int version) {
      return db.execute(
          "CREATE TABLE dogs(id INTEGER PRIMARY KEY AUTOINCREMENT, name VARCHAR(255) NOT NULL, old VARCHAR(255) NOT NULL)"
      );
    },
    version: 1
  );


  Future<List<Dog>> getDogs () async {
    final db = await database;
    List<Map<String, dynamic>> dogs = await db.query(
        "dogs",
        columns: ['id', 'old', 'name']
    );
    return List.generate(dogs.length, (index) {
      return Dog(
          id: dogs[index]['id'] as int,
          old: dogs[index]['old'] as String,
          name: dogs[index]['name'] as String
      );
    });
  }

  /* Future<Dog> getDog (Dog dog) async {
    final db = await database;
    List<Map<String, dynamic>> map = await db.query(
        "dogs",
        columns: ['id', 'old', 'name'],
        where: 'id = ?',
        whereArgs: [dog.id]
    );
    if (map.length > 0) return map.first;
    return null;
  } */

  Future<void> getDog (Dog dog) async {
    final db = await database;
    await db.query(
      "dogs", columns: ['id', 'old', 'name'], where: 'id = ?', whereArgs: [dog.id]
    );
  }

  Future<void> insertDog (Dog dog) async {
    final db = await database;
    await db.insert("dogs", dog.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateDog (Dog dog) async {
    final db = await database;
    await db.update(
      "dogs",
      dog.toMap(),
      where: 'id = ?',
      whereArgs: [dog.id]
    );
  }

  Future<void> deleteDog (Dog dog) async {
    final db = await database;
    await db.delete(
        "dogs",
        where: 'id = ?',
        whereArgs: [dog.id]
    );
  }

}


class Dog {
  final int id;
  final String old;
  final String name;

  const Dog({required this.id, required this.old, required this.name});

  Map<String, dynamic> toMap () {
    return {'id' : this.id, 'old' : this.old, 'name' : this.name};
  }

  String toString () {
    return '{ Id : $this.id, Âge : $this.old, Nom : $this.name }';
  }

}