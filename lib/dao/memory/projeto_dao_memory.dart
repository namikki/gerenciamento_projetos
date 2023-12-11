import 'dart:io';
import 'package:gerenciamento_projetos/database/database_provider.dart';
import 'package:gerenciamento_projetos/model/classes_projeto.dart';

class ProjetoDao {
  final dbProvider = DatabaseProvider.dbProvider;
  static final projetoTABLE = 'projeto';
  static final projetoUsuarioTABLE = 'projetoUsuario';

  Future<int> createProjeto(Projeto projeto) async {
    final db = await dbProvider.database;
    int result = 0;
    try {
      result = await db.insert(projetoTABLE, projeto.toDatabaseJson());
      if (result > 0) {
        stdout.write('Projeto inserido com sucesso: ${projeto.nomeProjeto}');
        for (var usuario in projeto.usuarios) {
          await db.insert(projetoUsuarioTABLE, {
            'projetoId': projeto.idProjeto,
            'usuarioId': usuario,
          });
        }
      } else {
        stdout.write('Falha ao inserir projeto: ${projeto.nomeProjeto}');
      }
    } catch (error) {
      stdout.write('Erro ao inserir projeto: $error');
    }
    return result;
  }

  Future<List<Projeto>> getProjetos(
      {List<String>? columns, String? query}) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result = [];
    if (query != null) {
      if (query.isNotEmpty) {
        result = await db.query(projetoTABLE,
            columns: columns,
            where: 'nomeProjeto LIKE ?',
            whereArgs: ["%$query%"]);
      }
    } else {
      result = await db.query(projetoTABLE, columns: columns);
    }

    List<Projeto> projetos = result.isNotEmpty
        ? result.map((item) => Projeto.fromDatabaseJson(item)).toList()
        : [];
    return projetos;
  }

  Future<int> updateProjeto(Projeto projeto) async {
    final db = await dbProvider.database;

    var result = await db.update(projetoTABLE, projeto.toDatabaseJson(),
        where: "idProjeto = ?", whereArgs: [projeto.idProjeto]);

    return result;
  }

  Future<int> deleteProjeto(int id) async {
    final db = await dbProvider.database;
    var result =
        await db.delete(projetoTABLE, where: 'idProjeto = ?', whereArgs: [id]);

    return result;
  }
}
