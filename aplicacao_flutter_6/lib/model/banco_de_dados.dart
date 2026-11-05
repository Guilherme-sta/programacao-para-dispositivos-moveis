import 'dart:async';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';
import 'contato.dart';

class BancoDeDados {
  BancoDeDados._();
  static final BancoDeDados instancia = BancoDeDados._();
  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    final caminho = path.join(await getDatabasesPath(), 'contatos.db');
    _database = await openDatabase(
      caminho,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          '''
          CREATE TABLE contatos(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT NOT NULL,
            email TEXT NOT NULL)
          '''
        );
      },
      );
    return _database!;
  }

  Future<int>inserir(Contato contato) async {
    final db = await database;
    return db.insert('contatos', {
      'nome': contato.nome,
      'email': contato.email,
    });
  }

  Future<List<Contato>>consultar() async {
    final db = await database;
    final retorno = await db.query('contatos', orderBy: 'nome COLLATE NOCASE');
    return retorno.map(Contato.fromMap).toList();
  }

  Future<int>atualizar(Contato contato) async {
    final db = await database;
    return db.update('contatos',
    {'nome': contato.nome, 'email': contato.email},
    where: 'id = ?',
    whereArgs: [contato.id],
    );
  }

  Future<int>excluir(int id) async {
    final db = await database;
    return db.delete('contatos',
    where: 'id = ?',
    whereArgs: [id]);
  }

}