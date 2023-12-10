import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _databaseName = "MyDatabase.db";
  static final _databaseVersion = 1;

  static final table = 'my_table';

  static final columnId = '_id';
  static final columnName = 'name';
  static final columnDescription = 'description';

  // torna esta classe singleton
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // tem somente uma referência ao banco de dados
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // abre o banco de dados e o cria se ele não existir
  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // Código SQL para criar o banco de dados


  static final tableUsuario = 'usuario';
  static final columnIdUsuario = 'idUsuario';
  static final columnNomeUsuario = 'nomeUsuario';
  static final columnEmailUsuario = 'emailUsuario';

  static final tableTarefa = 'tarefa';
  static final columnIdTarefa = 'idTarefa';
  static final columnDescricaoTarefa = 'descricaoTarefa';
  static final columnUsuarioTarefaId = 'usuarioTarefaId';
  static final columnTarefaCompleta = 'tarefaCompleta';

  static final tableProjeto = 'projeto';
  static final columnIdProjeto = 'idProjeto';
  static final columnNomeProjeto = 'nomeProjeto';
  static final columnDataInicioProjeto = 'dataInicioProjeto';
  static final columnPrazoProjeto = 'prazoProjeto';
  static final columnDescricaoProjeto = 'descricaoProjeto';

  static final tableProjetoUsuario = 'projetoUsuario';
  static final columnProjetoId = 'projetoId';
  static final columnUsuarioId = 'usuarioId';

  static final tableProjetoTarefa = 'projetoTarefa';
  static final columnTarefaId = 'tarefaId';

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableUsuario (
        $columnIdUsuario INTEGER PRIMARY KEY,
        $columnNomeUsuario TEXT NOT NULL,
        $columnEmailUsuario TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableTarefa (
        $columnIdTarefa INTEGER PRIMARY KEY,
        $columnDescricaoTarefa TEXT NOT NULL,
        $columnUsuarioTarefaId INTEGER,
        $columnTarefaCompleta INTEGER NOT NULL,
        FOREIGN KEY ($columnUsuarioTarefaId) REFERENCES $tableUsuario ($columnIdUsuario)
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableProjeto (
        $columnIdProjeto INTEGER PRIMARY KEY,
        $columnNomeProjeto TEXT NOT NULL,
        $columnDataInicioProjeto TEXT NOT NULL,
        $columnPrazoProjeto TEXT NOT NULL,
        $columnDescricaoProjeto TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableProjetoUsuario (
        $columnProjetoId INTEGER NOT NULL,
        $columnUsuarioId INTEGER NOT NULL,
        PRIMARY KEY ($columnProjetoId, $columnUsuarioId),
        FOREIGN KEY ($columnProjetoId) REFERENCES $tableProjeto ($columnIdProjeto),
        FOREIGN KEY ($columnUsuarioId) REFERENCES $tableUsuario ($columnIdUsuario)
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableProjetoTarefa (
        $columnProjetoId INTEGER NOT NULL,
        $columnTarefaId INTEGER NOT NULL,
        PRIMARY KEY ($columnProjetoId, $columnTarefaId),
        FOREIGN KEY ($columnProjetoId) REFERENCES $tableProjeto ($columnIdProjeto),
        FOREIGN KEY ($columnTarefaId) REFERENCES $tableTarefa ($columnIdTarefa)
      )
    ''');
  }

  // Métodos CRUD: inserir, consultar, atualizar e excluir
}
