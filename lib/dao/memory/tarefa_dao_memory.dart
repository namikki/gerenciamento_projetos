import 'package:gerenciamento_projetos/model/classes_projeto.dart';
import 'package:gerenciamento_projetos/dao/classes_dao.dart';

class TarefaDaoMemory implements TarefaDao {
  // Singleton
  static TarefaDaoMemory _instance = TarefaDaoMemory._();
  TarefaDaoMemory._();
  static TarefaDaoMemory get instance => _instance;
  factory TarefaDaoMemory() => _instance;

  List<Tarefa> dados = [
    Tarefa(
        idTarefa: 1,
        descricaoTarefa: 'Tarefa testa',
        usuarioTarefa: Usuario(
          idUsuario: 1,
          nomeUsuario: 'Bianca',
          emailUsuario: 'bianca@email.com',
        ),
        tarefaCompleta: false),
  ];

  @override
  bool alterar(Tarefa tarefa) {
    int ind = dados.indexOf(tarefa);
    if (ind >= 0) {
      dados[ind] = tarefa;
      return true;
    }
    return false;
  }

  @override
  bool excluir(Tarefa tarefa) {
    int ind = dados.indexOf(tarefa);
    if (ind >= 0) {
      dados.removeAt(ind);
      return true;
    }
    return false;
  }

  @override
  bool inserir(Tarefa tarefa) {
    dados.add(tarefa);
    tarefa.idTarefa = dados.length;
    return true;
  }

  @override
  List<Tarefa> listarTodos() {
    return dados;
  }

//Talvez não precise
  @override
  Tarefa? selecionarPorId(int idTarefa) {
    for (int i = 0; i < dados.length; i++) {
      if (dados[i].idTarefa == idTarefa) {
        return dados[i];
      }
    }
    return null;
  }
}
