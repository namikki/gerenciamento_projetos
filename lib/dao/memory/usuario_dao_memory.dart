import 'dart:io';
import 'package:gerenciamento_projetos/database/database_provider.dart';
import 'package:gerenciamento_projetos/model/classes_projeto.dart';


class UsuarioDao {
  final dbProvider = DatabaseProvider.dbProvider;
  static final usuarioTABLE = 'usuario';

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
            columns: columns, where: 'nome LIKE ?', whereArgs: ["%$query%"]);
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
        await db.delete(usuarioTABLE, where: 'id = ?', whereArgs: [id]);

    return result;
  }
}
