import 'package:gerenciamento_projetos/model/classes_projeto.dart';

abstract class ProjetoDao {
  List<Projeto> listarTodos();
  Projeto? selecionarPorId(int idProjeto);
  bool inserir(Projeto projeto);
  bool alterar(Projeto projeto);
  bool excluir(Projeto projeto);
}
