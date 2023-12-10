import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:gerenciamento_projetos/model/classes_projeto.dart';

class FormProjeto extends StatefulWidget {
  final Function(Projeto) onProjetoSubmit;
  final Projeto? projeto; // Projeto opcional para edição

  FormProjeto({required this.onProjetoSubmit, this.projeto});

  @override
  _FormProjetoState createState() => _FormProjetoState();
}

class _FormProjetoState extends State<FormProjeto> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  DateTime _dataInicioProjeto = DateTime.now();
  DateTime _prazoProjeto = DateTime.now().add(Duration(days: 30));
  List<Usuario> _listaUsuariosProjeto = [];
  List<Tarefa> _listaTarefasProjeto = [];

  @override
  void initState() {
    super.initState();
    // Preencher os campos se estiver editando
    if (widget.projeto != null) {
      _nomeController.text = widget.projeto!.nomeProjeto;
      _descricaoController.text = widget.projeto!.descricaoProjeto;
      _dataInicioProjeto = widget.projeto!.dataInicioProjeto;
      _prazoProjeto = widget.projeto!.prazoProjeto;
      _listaUsuariosProjeto = widget.projeto!.listaUsuariosProjeto;
      _listaTarefasProjeto = widget.projeto!.listaTarefasProjeto;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.projeto == null ? 'Adicionar Projeto' : 'Editar Projeto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(labelText: 'Nome do Projeto'),
            ),
            TextField(
              controller: _descricaoController,
              decoration: InputDecoration(labelText: 'Descrição do Projeto'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _dataInicioProjeto,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 365)),
                );
                if (date != null) {
                  setState(() {
                    _dataInicioProjeto = date;
                  });
                }
              },
              child: Text(
                  'Data de Início: ${DateFormat('dd/MM/yyyy').format(_dataInicioProjeto)}'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _prazoProjeto,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 365)),
                );
                if (date != null) {
                  setState(() {
                    _prazoProjeto = date;
                  });
                }
              },
              child: Text(
                  'Prazo: ${DateFormat('dd/MM/yyyy').format(_prazoProjeto)}'),
            ),
            // Adicione widgets para selecionar os usuários e as tarefas
            // ...
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final nome = _nomeController.text;
                final descricao = _descricaoController.text;

                if (nome.isNotEmpty && descricao.isNotEmpty) {
                  final novoProjeto = Projeto(
                    idProjeto: widget.projeto?.idProjeto ??
                        DateTime.now().millisecondsSinceEpoch,
                    nomeProjeto: nome,
                    dataInicioProjeto: _dataInicioProjeto,
                    prazoProjeto: _prazoProjeto,
                    descricaoProjeto: descricao,
                    listaUsuariosProjeto: _listaUsuariosProjeto,
                    listaTarefasProjeto: _listaTarefasProjeto,
                  );

                  widget.onProjetoSubmit(novoProjeto);
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
