import 'package:gerenciamento_projetos/model/classes_projeto.dart';

abstract class ProjetoDao {
  List<Projeto> listarTodos();
  Projeto? selecionarPorId(int idProjeto);
  bool inserir(Projeto projeto);
  bool alterar(Projeto projeto);
  bool excluir(Projeto projeto);
}

abstract class TarefaDao {
  List<Tarefa> listarTodos();
  Tarefa? selecionarPorId(int idTarefa);
  bool inserir(Tarefa tarefa);
  bool alterar(Tarefa tarefa);
  bool excluir(Tarefa tarefa);
}

abstract class UsuarioDaoo {
  List<Usuario> listarTodos();
  Usuario? selecionarPorId(int idUsuario);
  bool inserir(Usuario usuario);
  bool alterar(Usuario usuario);
  bool excluir(Usuario usuario);
}
