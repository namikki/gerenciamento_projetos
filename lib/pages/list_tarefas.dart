/*import 'package:flutter/material.dart';
import 'package:gerenciamento_projetos/model/classes_projeto.dart';
import 'package:gerenciamento_projetos/dao/classes_dao.dart';
import 'package:gerenciamento_projetos/pages/form_tarefa.dart';

class ListTarefas extends StatefulWidget {
  @override
  _ListTarefasState createState() => _ListTarefasState();
}

class _ListTarefasState extends State<ListTarefas> {
  List<Tarefa> tarefas = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Tarefas'),
      ),
      body: ListView.builder(
        itemCount: tarefas.length,
        itemBuilder: (context, index) {
          final tarefa = tarefas[index];
          return ListTile(
            title: Text(tarefa.descricaoTarefa),
            subtitle: Text(tarefa.tarefaCompleta ? 'Completa' : 'Pendente'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FormTarefa(
                          onTarefaSubmit: (tarefaEditada) {
                            setState(() {
                              // Remover a tarefa antiga e adicionar a tarefa editada
                              tarefas.remove(tarefa);
                              tarefas.add(tarefaEditada);
                            });
                          },
                          tarefa: tarefa,
                          usuarios: [
                            Usuario(
                                idUsuario: 1,
                                nomeUsuario: 'Bianca',
                                emailUsuario: 'b@e.com'),
                            Usuario(
                                idUsuario: 2,
                                nomeUsuario: 'Matheus',
                                emailUsuario: 'm@e.com')
                          ], // Passar a tarefa para a edição
                        ),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      tarefas.remove(tarefa);
                    });
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final novaTarefa = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FormTarefa(
                onTarefaSubmit: (tarefa) {
                  setState(() {
                    tarefas.add(tarefa);
                  });
                },
                usuarios: [
                  Usuario(
                      idUsuario: 1,
                      nomeUsuario: 'Bianca',
                      emailUsuario: 'b@e.com'),
                  Usuario(
                      idUsuario: 2,
                      nomeUsuario: 'Matheus',
                      emailUsuario: 'm@e.com')
                ],
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
*/
