import 'package:gerenciamento_projetos/model/classes_projeto.dart';
import 'package:gerenciamento_projetos/dao/classes_dao.dart';

class ProjetoDaoMemory implements ProjetoDao {
  // Singleton
  static ProjetoDaoMemory _instance = ProjetoDaoMemory._();
  ProjetoDaoMemory._();
  static ProjetoDaoMemory get instance => _instance;
  factory ProjetoDaoMemory() => _instance;

  List<Projeto> dados = [
    Projeto(
      idProjeto: 1,
      nomeProjeto: 'Projeto Teste',
      dataInicioProjeto: DateTime.now(), //alterar
      prazoProjeto: DateTime.now(), //alterar
      descricaoProjeto: 'Isso é um projeto teste',
      donoProjeto: Usuario(
        idUsuario: 1,
        nomeUsuario: 'Bianca',
        emailUsuario: 'bianca@email.com',
      ),
      listaUsuariosProjeto: [],
      listaTarefasProjeto: [],
    ),
  ];

  @override
  bool alterar(Projeto projeto) {
    int ind = dados.indexOf(projeto);
    if (ind >= 0) {
      dados[ind] = projeto;
      return true;
    }
    return false;
  }

  @override
  bool excluir(Projeto projeto) {
    int ind = dados.indexOf(projeto);
    if (ind >= 0) {
      dados.removeAt(ind);
      return true;
    }
    return false;
  }

  @override
  bool inserir(Projeto projeto) {
    dados.add(projeto);
    projeto.idProjeto = dados.length;
    return true;
  }

  @override
  List<Projeto> listarTodos() {
    return dados;
  }

//Talvez não precise
  @override
  Projeto? selecionarPorId(int idProjeto) {
    for (int i = 0; i < dados.length; i++) {
      if (dados[i].idProjeto == idProjeto) {
        return dados[i];
      }
    }
    return null;
  }
}
