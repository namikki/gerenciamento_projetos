import 'package:gerenciamento_projetos/model/classes_projeto.dart';
import 'package:gerenciamento_projetos/dao/projeto_dao.dart';

class ProjetoDaoMemory implements ProjetoDao {
  // Singleton
  static ProjetoDaoMemory _instance = ProjetoDaoMemory._();
  ProjetoDaoMemory._();
  static ProjetoDaoMemory get instance => _instance;
  factory ProjetoDaoMemory() => _instance;

  @override
  bool alterar(Projeto projeto) {
    // TODO: implement alterar
    throw UnimplementedError();
  }

  @override
  bool excluir(Projeto projeto) {
    // TODO: implement excluir
    throw UnimplementedError();
  }

  @override
  bool inserir(Projeto projeto) {
    // TODO: implement inserir
    throw UnimplementedError();
  }

  @override
  List<Projeto> listarTodos() {
    // TODO: implement listarTodos
    throw UnimplementedError();
  }

//Talvez não precise
  @override
  Projeto? selecionarPorId(int idProjeto) {
    // TODO: implement selecionarPorId
    throw UnimplementedError();
  }
}
