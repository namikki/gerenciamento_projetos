import 'package:flutter/material.dart';
import 'package:gerenciamento_projetos/model/classes_projeto.dart';
import 'package:gerenciamento_projetos/dao/memory/tarefa_dao_memory.dart';
import 'package:gerenciamento_projetos/dao/memory/usuario_dao_memory.dart';

class FormTarefa extends StatefulWidget {
  final Function(Tarefa) onTarefaSubmit;
  final Tarefa? tarefa;
  final List<Usuario> usuarios;

  FormTarefa(
      {required this.onTarefaSubmit, this.tarefa, required this.usuarios});

  @override
  _FormTarefaState createState() => _FormTarefaState();
}

class _FormTarefaState extends State<FormTarefa> {
  final TextEditingController _descricaoController = TextEditingController();
  List<Usuario> _usuarios = []; // Lista de todos os usuários
  List<bool> _selecionados = []; // Lista de usuários selecionados
  bool _tarefaCompleta = false;

  @override
  void initState() {
    super.initState();
    if (widget.tarefa != null) {
      _descricaoController.text = widget.tarefa!.descricaoTarefa;
      _tarefaCompleta = widget.tarefa!.tarefaCompleta;
    }
    loadUsuarios();
  }

  void loadUsuarios() async {
    final usuarioDao = UsuarioDao();
    final allUsuarios = await usuarioDao.getUsuarios();
    List<bool> selecionadosTemp = List<bool>.filled(allUsuarios.length, false);

    if (widget.tarefa != null) {
      final usuariosDaTarefa =
          await usuarioDao.getUsuariosDaTarefa(widget.tarefa!.idTarefa);
      for (var i = 0; i < allUsuarios.length; i++) {
        for (var usuario in usuariosDaTarefa) {
          if (allUsuarios[i].idUsuario == usuario.idUsuario) {
            selecionadosTemp[i] = true;
            break;
          }
        }
      }
    }

    setState(() {
      _usuarios = allUsuarios;
      _selecionados = selecionadosTemp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário de Tarefa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _descricaoController,
              decoration: InputDecoration(labelText: 'Descrição da Tarefa'),
            ),
            const Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Status da Tarefa',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            CheckboxListTile(
              title: Text('Tarefa Completa'),
              value: _tarefaCompleta,
              onChanged: (bool? value) {
                setState(() {
                  _tarefaCompleta = value!;
                });
              },
            ),
            const Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Usuário responsável pela tarefa:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _usuarios.length,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  title: Text(_usuarios[index].nomeUsuario),
                  value: _selecionados[index],
                  onChanged: (bool? value) {
                    setState(() {
                      _selecionados[index] = value!;
                    });
                  },
                );
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final descricao = _descricaoController.text;
                final usuarioTarefaId = _usuarios
                    .asMap()
                    .entries
                    .where((entry) => _selecionados[entry.key])
                    .map((entry) => entry.value.idUsuario)
                    .first;

                if (descricao.isNotEmpty) {
                  final tarefaDao = TarefaDao();

                  if (widget.tarefa == null) {
                    // Cria uma nova tarefa
                    final novaTarefa = Tarefa(
                      idTarefa: DateTime.now().millisecondsSinceEpoch,
                      descricaoTarefa: descricao,
                      usuarioTarefaId: usuarioTarefaId,
                      tarefaCompleta: _tarefaCompleta,
                    );

                    // Insere a nova tarefa no banco de dados
                    final id = await tarefaDao.createTarefa(novaTarefa);
                    // Imprime o id da tarefa inserida
                    print('Tarefa inserida com id: $id');
                  } else {
                    // Atualiza a tarefa existente
                    final tarefaAtualizada = Tarefa(
                      idTarefa: widget.tarefa!.idTarefa,
                      descricaoTarefa: descricao,
                      usuarioTarefaId: usuarioTarefaId,
                      tarefaCompleta: _tarefaCompleta,
                    );

                    // Atualiza a tarefa no banco de dados
                    final id = await tarefaDao.updateTarefa(tarefaAtualizada);
                    // Imprime o id da tarefa atualizada
                    print('Tarefa atualizada com id: $id');
                  }

                  Navigator.pop(context);
                } else {
                  // Adicione tratamento para campos vazios se necessário
                }
              },
              child: Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
