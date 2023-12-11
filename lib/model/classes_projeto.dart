/*Pensando se deixo todas as classes juntas ou separadas*/

class Usuario {
  int idUsuario;
  String nomeUsuario;
  String emailUsuario;

  Usuario(
      {required this.idUsuario,
      required this.nomeUsuario,
      required this.emailUsuario});

  // Método para converter o usuário em um formato adequado para o SharedPreferences
  Map<String, dynamic> toMap() {
    return {
      'idUsuario': idUsuario,
      'nomeUsuario': nomeUsuario,
      'emailUsuario': emailUsuario,
    };
  }

  factory Usuario.fromDatabaseJson(Map<String, dynamic> data) => Usuario(
        idUsuario: data['idUsuario'],
        nomeUsuario: data['nomeUsuario'],
        emailUsuario: data['emailUsuario'],
      );

  Map<String, dynamic> toDatabaseJson() => {
        "idUsuario": idUsuario,
        "nomeUsuario": nomeUsuario,
        "emailUsuario": emailUsuario,
      };
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
  final int idProjeto;
  final String nomeProjeto;
  final DateTime dataInicioProjeto;
  final DateTime prazoProjeto;
  final String descricaoProjeto;
  final List<int> usuarios;

  Projeto({
    required this.idProjeto,
    required this.nomeProjeto,
    required this.dataInicioProjeto,
    required this.prazoProjeto,
    required this.descricaoProjeto,
    required this.usuarios,
  });

  Map<String, dynamic> toDatabaseJson() => {
        "idProjeto": idProjeto,
        "nomeProjeto": nomeProjeto,
        "dataInicioProjeto": dataInicioProjeto.toIso8601String(),
        "prazoProjeto": prazoProjeto.toIso8601String(),
        "descricaoProjeto": descricaoProjeto,
      };

  factory Projeto.fromDatabaseJson(Map<String, dynamic> data) => Projeto(
        idProjeto: data['idProjeto'],
        nomeProjeto: data['nomeProjeto'],
        dataInicioProjeto: DateTime.parse(data['dataInicioProjeto']),
        prazoProjeto: DateTime.parse(data['prazoProjeto']),
        descricaoProjeto: data['descricaoProjeto'],
        usuarios: [], // Isso será preenchido posteriormente
      );
}
