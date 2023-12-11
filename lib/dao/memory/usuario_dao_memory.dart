import 'dart:io';
import 'package:gerenciamento_projetos/database/database_provider.dart';
import 'package:gerenciamento_projetos/model/classes_projeto.dart';

class UsuarioDao {
  final dbProvider = DatabaseProvider.dbProvider;
  static final usuarioTABLE = 'usuario';
  static final projetoUsuarioTABLE = 'projetoUsuario';
  static final projetoTarefaTABLE = 'projetoTarefa';

  Future<int> createUsuario(Usuario usuario) async {
    final db = await dbProvider.database;
    int result = 0;
    try {
      result = await db.insert(usuarioTABLE, usuario.toDatabaseJson());
      if (result > 0) {
        stdout.write('Usuário inserido com sucesso: ${usuario.nomeUsuario}');
      } else {
        stdout.write('Falha ao inserir usuário: ${usuario.nomeUsuario}');
      }
    } catch (error) {
      stdout.write('Erro ao inserir usuário: $error');
    }
    return result;
  }

  Future<List<Usuario>> getUsuarios(
      {List<String>? columns, String? query}) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result = [];
    if (query != null) {
      if (query.isNotEmpty) {
        result = await db.query(usuarioTABLE,
            columns: columns,
            where: 'nomeUsuario LIKE ?',
            whereArgs: ["%$query%"]);
      }
    } else {
      result = await db.query(usuarioTABLE, columns: columns);
    }

    List<Usuario> usuarios = result.isNotEmpty
        ? result.map((item) => Usuario.fromDatabaseJson(item)).toList()
        : [];
    return usuarios;
  }

  Future<int> updateUsuario(Usuario usuario) async {
    final db = await dbProvider.database;

    var result = await db.update(usuarioTABLE, usuario.toDatabaseJson(),
        where: "id = ?", whereArgs: [usuario.idUsuario]);

    return result;
  }

  Future<int> deleteUsuario(int id) async {
    final db = await dbProvider.database;
    var result =
        await db.delete(usuarioTABLE, where: 'idUsuario = ?', whereArgs: [id]);

    return result;
  }

  Future<int> createProjetoUsuario(int projetoId, int usuarioId) async {
    final db = await dbProvider.database;
    Map<String, dynamic> projetoUsuario = {
      'projetoId': projetoId,
      'usuarioId': usuarioId,
    };

    int result = 0;
    try {
      result = await db.insert(projetoUsuarioTABLE, projetoUsuario);
      if (result > 0) {
        stdout.write(
            'Associação de usuário ao projeto inserida com sucesso: $projetoId - $usuarioId');
      } else {
        stdout.write(
            'Falha ao inserir associação de usuário ao projeto: $projetoId - $usuarioId');
      }
    } catch (error) {
      stdout.write('Erro ao inserir associação de usuário ao projeto: $error');
    }
    return result;
  }

  Future<List<Usuario>> getUsuariosDoProjeto(int projetoId) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result = await db.query(
      usuarioTABLE,
      where:
          'idUsuario IN (SELECT usuarioId FROM $projetoUsuarioTABLE WHERE projetoId = ?)',
      whereArgs: [projetoId],
    );

    List<Usuario> usuarios = result.isNotEmpty
        ? result.map((item) => Usuario.fromDatabaseJson(item)).toList()
        : [];
    return usuarios;
  }

  Future<int> deleteProjetoUsuarios(int projetoId) async {
    final db = await dbProvider.database;

    var result = await db.delete(
      projetoUsuarioTABLE,
      where: 'projetoId = ?',
      whereArgs: [projetoId],
    );

    return result;
  }

  Future<List<Usuario>> getUsuariosDaTarefa(int tarefaId) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result = await db.query(
      usuarioTABLE,
      where:
          'idUsuario IN (SELECT usuarioId FROM $projetoTarefaTABLE WHERE tarefaId = ?)',
      whereArgs: [tarefaId],
    );

    List<Usuario> usuarios = result.isNotEmpty
        ? result.map((item) => Usuario.fromDatabaseJson(item)).toList()
        : [];
    return usuarios;
  }

//fechamento
}
