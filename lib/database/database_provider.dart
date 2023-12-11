import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  static final DatabaseProvider dbProvider = DatabaseProvider();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await createDatabase();
    return _database!;
  }

  createDatabase() async {
    String databasesPath = await getDatabasesPath();
    String dbPath = join(databasesPath, 'gerenciamento_projetos.db');

    var database = await openDatabase(dbPath, version: 1, onCreate: populateDb);
    return database;
  }


  void populateDb(Database database, int version) async {
  await database.execute('''
    CREATE TABLE usuario (
      idUsuario INTEGER PRIMARY KEY,
      nomeUsuario TEXT NOT NULL,
      emailUsuario TEXT NOT NULL
    )
  ''');

  await database.execute('''
    CREATE TABLE tarefa (
      idTarefa INTEGER PRIMARY KEY,
      descricaoTarefa TEXT NOT NULL,
      usuarioTarefaId INTEGER,
      tarefaCompleta INTEGER NOT NULL,
      FOREIGN KEY (usuarioTarefaId) REFERENCES usuario (idUsuario)
    )
  ''');

  await database.execute('''
    CREATE TABLE projeto (
      idProjeto INTEGER PRIMARY KEY,
      nomeProjeto TEXT NOT NULL,
      dataInicioProjeto TEXT NOT NULL,
      prazoProjeto TEXT NOT NULL,
      descricaoProjeto TEXT NOT NULL
    )
  ''');

  await database.execute('''
    CREATE TABLE projetoUsuario (
      projetoId INTEGER NOT NULL,
      usuarioId INTEGER NOT NULL,
      PRIMARY KEY (projetoId, usuarioId),
      FOREIGN KEY (projetoId) REFERENCES projeto (idProjeto),
      FOREIGN KEY (usuarioId) REFERENCES usuario (idUsuario)
    )
  ''');

  await database.execute('''
    CREATE TABLE projetoTarefa (
      projetoId INTEGER NOT NULL,
      tarefaId INTEGER NOT NULL,
      PRIMARY KEY (projetoId, tarefaId),
      FOREIGN KEY (projetoId) REFERENCES projeto (idProjeto),
      FOREIGN KEY (tarefaId) REFERENCES tarefa (idTarefa)
    )
  ''');
}

}
