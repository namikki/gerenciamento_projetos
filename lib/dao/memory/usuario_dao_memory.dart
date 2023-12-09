import 'package:gerenciamento_projetos/model/classes_projeto.dart';
import 'package:gerenciamento_projetos/dao/classes_dao.dart';

class UsuarioDaoMemory implements UsuarioDao {
  // Singleton
  static UsuarioDaoMemory _instance = UsuarioDaoMemory._();
  UsuarioDaoMemory._();
  static UsuarioDaoMemory get instance => _instance;
  factory UsuarioDaoMemory() => _instance;

  List<Usuario> dados = [
    Usuario(
        idUsuario: 1, nomeUsuario: 'Bianca', emailUsuario: 'bianca@email.com'),
  ];

  @override
  bool alterar(Usuario usuario) {
    int ind = dados.indexOf(usuario);
    if (ind >= 0) {
      dados[ind] = usuario;
      return true;
    }
    return false;
  }

  @override
  bool excluir(Usuario usuario) {
    int ind = dados.indexOf(usuario);
    if (ind >= 0) {
      dados.removeAt(ind);
      return true;
    }
    return false;
  }

  @override
  bool inserir(Usuario usuario) {
    dados.add(usuario);
    usuario.idUsuario = dados.length;
    return true;
  }

  @override
  List<Usuario> listarTodos() {
    return dados;
  }

//Talvez não precise
  @override
  Usuario? selecionarPorId(int idUsuario) {
    for (int i = 0; i < dados.length; i++) {
      if (dados[i].idUsuario == idUsuario) {
        return dados[i];
      }
    }
    return null;
  }
}
