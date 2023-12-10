import 'package:flutter/material.dart';
import 'package:gerenciamento_projetos/model/classes_projeto.dart';
import 'package:gerenciamento_projetos/dao/classes_dao.dart';
import 'package:gerenciamento_projetos/dao/memory/projeto_dao_memory.dart';

class FormTarefa extends StatefulWidget {
  final Function(Tarefa) onTarefaSubmit;
  final Tarefa? tarefa; // Tarefa opcional para edição
  final List<Usuario> usuarios; // Lista de usuários disponíveis

  FormTarefa(
      {required this.onTarefaSubmit, required this.usuarios, this.tarefa});

  @override
  _FormTarefaState createState() => _FormTarefaState();
}

class _FormTarefaState extends State<FormTarefa> {
  final TextEditingController _descricaoController = TextEditingController();
  bool _tarefaCompleta = false;
  Usuario? _usuarioSelecionado;

  @override
  void initState() {
    super.initState();
    // Preencher os campos se estiver editando
    if (widget.tarefa != null) {
      _descricaoController.text = widget.tarefa!.descricaoTarefa;
      _tarefaCompleta = widget.tarefa!.tarefaCompleta;
      _usuarioSelecionado = widget.tarefa!.usuarioTarefa;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.tarefa == null ? 'Adicionar Tarefa' : 'Editar Tarefa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _descricaoController,
              decoration: InputDecoration(labelText: 'Descrição da Tarefa'),
            ),
            DropdownButtonFormField<Usuario>(
              value: _usuarioSelecionado,
              onChanged: (Usuario? usuario) {
                setState(() {
                  _usuarioSelecionado = usuario;
                });
              },
              items: widget.usuarios.map((Usuario usuario) {
                return DropdownMenuItem<Usuario>(
                  value: usuario,
                  child: Text(usuario.nomeUsuario),
                );
              }).toList(),
              decoration: InputDecoration(labelText: 'Selecione o Usuário'),
            ),
            CheckboxListTile(
              title: Text('Tarefa Completa'),
              value: _tarefaCompleta,
              onChanged: (value) {
                setState(() {
                  _tarefaCompleta = value!;
                });
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final descricao = _descricaoController.text;

                if (descricao.isNotEmpty && _usuarioSelecionado != null) {
                  final novaTarefa = Tarefa(
                    idTarefa: widget.tarefa?.idTarefa ??
                        DateTime.now().millisecondsSinceEpoch,
                    descricaoTarefa: descricao,
                    tarefaCompleta: _tarefaCompleta,
                    usuarioTarefa: _usuarioSelecionado!,
                  );

                  widget.onTarefaSubmit(novaTarefa);
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
