/*Pensando se deixo todas as classes juntas ou separadas*/

class Usuario {
  int idUsuario;
  String nomeUsuario;
  String emailUsuario;

  Usuario(
      {required this.idUsuario,
      required this.nomeUsuario,
      required this.emailUsuario});
}

class Tarefa {
  int idTarefa;
  String descricaoTarefa;
  Usuario usuarioTarefa;
  bool tarefaCompleta;

  Tarefa(
      {required this.idTarefa,
      required this.descricaoTarefa,
      required this.usuarioTarefa,
      required this.tarefaCompleta});
}

class Projeto {
  int idProjeto;
  String nomeProjeto;
  DateTime dataInicioProjeto;
  DateTime prazoProjeto;
  String descricaoProjeto;
  Usuario donoProjeto;
  List<Usuario> listaUsuariosProjeto;
  List<Tarefa> listaTarefasProjeto;

  Projeto(
      {required this.idProjeto,
      required this.nomeProjeto,
      required this.dataInicioProjeto,
      required this.prazoProjeto,
      required this.descricaoProjeto,
      required this.donoProjeto,
      required this.listaUsuariosProjeto,
      required this.listaTarefasProjeto});
}
