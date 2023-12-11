import 'dart:io';
import 'package:gerenciamento_projetos/database/database_provider.dart';
import 'package:gerenciamento_projetos/model/classes_projeto.dart';

class TarefaDao {
  final dbProvider = DatabaseProvider.dbProvider;
  static final tarefaTABLE = 'tarefa';
  static final projetoTarefaTABLE = 'projetoTarefa';

  Future<int> createTarefa(Tarefa tarefa, int projetoId) async {
    final db = await dbProvider.database;
    int result = 0;
    try {
      result = await db.insert(tarefaTABLE, tarefa.toDatabaseJson());
      if (result > 0) {
        stdout.write('Tarefa inserida com sucesso: ${tarefa.descricaoTarefa}');
        await createProjetoTarefa(projetoId, tarefa.idTarefa);
      } else {
        stdout.write('Falha ao inserir tarefa: ${tarefa.descricaoTarefa}');
      }
    } catch (error) {
      stdout.write('Erro ao inserir tarefa: $error');
    }
    return result;
  }

  Future<List<Tarefa>> getTarefas(
      {List<String>? columns, String? query}) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result = [];
    if (query != null) {
      if (query.isNotEmpty) {
        result = await db.query(tarefaTABLE,
            columns: columns,
            where: 'descricaoTarefa LIKE ?',
            whereArgs: ["%$query%"]);
      }
    } else {
      result = await db.query(tarefaTABLE, columns: columns);
    }

    List<Tarefa> tarefas = result.isNotEmpty
        ? result.map((item) => Tarefa.fromDatabaseJson(item)).toList()
        : [];
    return tarefas;
  }

  Future<int> updateTarefa(Tarefa tarefa) async {
    final db = await dbProvider.database;

    var result = await db.update(tarefaTABLE, tarefa.toDatabaseJson(),
        where: "idTarefa = ?", whereArgs: [tarefa.idTarefa]);

    return result;
  }

  Future<int> deleteTarefa(int id) async {
    final db = await dbProvider.database;
    var result =
        await db.delete(tarefaTABLE, where: 'idTarefa = ?', whereArgs: [id]);

    return result;
  }

  Future<List<Tarefa>> getTarefasDoProjeto(int projetoId) async {
    final db = await dbProvider.database;
    final List<Map<String, dynamic>> result = await db.query(
      projetoTarefaTABLE,
      columns: ['tarefaId'],
      where: 'projetoId = ?',
      whereArgs: [projetoId],
    );

    final List<Tarefa> tarefas = [];
    for (final item in result) {
      final tarefaId = item['tarefaId'];
      final tarefaData = await db.query(
        tarefaTABLE,
        where: 'idTarefa = ?',
        whereArgs: [tarefaId],
      );
      final tarefa = Tarefa.fromDatabaseJson(tarefaData.first);
      tarefas.add(tarefa);
    }

    return tarefas;
  }

  Future<int> createProjetoTarefa(int projetoId, int tarefaId) async {
    final db = await dbProvider.database;
    final Map<String, dynamic> row = {
      'projetoId': projetoId,
      'tarefaId': tarefaId,
    };
    final result = await db.insert(projetoTarefaTABLE, row);
    return result;
  }

//fechamento
}
