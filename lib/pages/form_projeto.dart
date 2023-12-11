import 'package:flutter/material.dart';
import 'package:gerenciamento_projetos/model/classes_projeto.dart';
import 'package:gerenciamento_projetos/pages/form_tarefa.dart';
import 'package:gerenciamento_projetos/dao/memory/projeto_dao_memory.dart';
import 'package:gerenciamento_projetos/dao/memory/usuario_dao_memory.dart';
import 'package:gerenciamento_projetos/dao/memory/tarefa_dao_memory.dart';

class FormProjeto extends StatefulWidget {
  final Function(Projeto) onProjetoSubmit;
  final Projeto? projeto;

  FormProjeto({required this.onProjetoSubmit, this.projeto});

  @override
  _FormProjetoState createState() => _FormProjetoState();
}

class _FormProjetoState extends State<FormProjeto> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _dataInicioController = TextEditingController();
  final TextEditingController _prazoController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  List<Usuario> _usuarios = []; // Lista de todos os usuários
  List<bool> _selecionados = []; // Lista de usuários selecionados
  List<Tarefa> _tarefas = []; // Lista de tarefas

  @override
  void initState() {
    super.initState();
    if (widget.projeto != null) {
      _nomeController.text = widget.projeto!.nomeProjeto;
      _dataInicioController.text =
          widget.projeto!.dataInicioProjeto.toIso8601String();
      _prazoController.text = widget.projeto!.prazoProjeto.toIso8601String();
      _descricaoController.text = widget.projeto!.descricaoProjeto;
    }
    loadUsuarios();
    loadTarefas(); // Carrega as tarefas associadas ao projeto
  }

  void loadUsuarios() async {
    final usuarioDao = UsuarioDao();
    final allUsuarios = await usuarioDao.getUsuarios();
    List<bool> selecionadosTemp = List<bool>.filled(allUsuarios.length, false);

    if (widget.projeto != null) {
      final usuariosDoProjeto =
          await usuarioDao.getUsuariosDoProjeto(widget.projeto!.idProjeto);
      for (var i = 0; i < allUsuarios.length; i++) {
        for (var usuario in usuariosDoProjeto) {
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

  void loadTarefas() async {
    final tarefaDao = TarefaDao();
    if (widget.projeto != null) {
      final tarefasDoProjeto =
          await tarefaDao.getTarefasDoProjeto(widget.projeto!.idProjeto);
      setState(() {
        _tarefas = tarefasDoProjeto;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário de Projeto'),
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
              controller: _dataInicioController,
              decoration: InputDecoration(labelText: 'Data de Início'),
            ),
            TextField(
              controller: _prazoController,
              decoration: InputDecoration(labelText: 'Prazo'),
            ),
            TextField(
              controller: _descricaoController,
              decoration: InputDecoration(labelText: 'Descrição'),
            ),
            const Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Usuários para o projeto:',
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

            ElevatedButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FormTarefa(
                      onTarefaSubmit: (tarefa) {
                        setState(() {
                          _tarefas.add(tarefa);
                        });
                      },
                      usuarios: _usuarios,
                      projetoId: widget.projeto!.idProjeto,
                    ),
                  ),
                );
              },
              child: Text('Adicionar Tarefa'),
            ),
            // Lista de Tarefas
            const Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Lista de Tarefas:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _tarefas.length,
              itemBuilder: (context, index) {
                final tarefa = _tarefas[index];
                return ListTile(
                  title: Text(tarefa.descricaoTarefa),
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
                                onTarefaSubmit: (tarefaAtualizada) {
                                  setState(() {
                                    _tarefas[index] = tarefaAtualizada;
                                  });
                                },
                                tarefa: tarefa,
                                usuarios: _usuarios,
                                projetoId: widget.projeto!.idProjeto,
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            _tarefas.removeAt(index);
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final nome = _nomeController.text;
                final dataInicio = _dataInicioController.text;
                final prazo = _prazoController.text;
                final descricao = _descricaoController.text;

                if (nome.isNotEmpty &&
                    dataInicio.isNotEmpty &&
                    prazo.isNotEmpty &&
                    descricao.isNotEmpty) {
                  final projetoDao = ProjetoDao();
                  final usuarioDao = UsuarioDao();

                  if (widget.projeto == null) {
                    // Cria um novo projeto
                    final novoProjeto = Projeto(
                      idProjeto: DateTime.now().millisecondsSinceEpoch,
                      nomeProjeto: nome,
                      dataInicioProjeto:
                          DateTime.parse(dataInicio), //YYYY-MM-DD
                      prazoProjeto: DateTime.parse(prazo),
                      descricaoProjeto: descricao,
                      usuarios: _usuarios
                          .asMap()
                          .entries
                          .where((entry) => _selecionados[entry.key])
                          .map((entry) => entry.value.idUsuario)
                          .toList(), // Adicione os usuários aqui se necessário
                    );

                    // Insere o novo projeto no banco de dados
                    final id = await projetoDao.createProjeto(novoProjeto);
                    // Insere as associações de usuários na tabela projetoUsuario
                    for (var usuarioId in novoProjeto.usuarios) {
                      await usuarioDao.createProjetoUsuario(
                          novoProjeto.idProjeto, usuarioId);
                    }
                    // Imprime o id do projeto inserido
                    print('Projeto inserido com id: $id');
                  } else {
                    // Atualiza o projeto existente
                    final projetoAtualizado = Projeto(
                      idProjeto: widget.projeto!.idProjeto,
                      nomeProjeto: nome,
                      dataInicioProjeto: DateTime.parse(dataInicio),
                      prazoProjeto: DateTime.parse(prazo),
                      descricaoProjeto: descricao,
                      usuarios: _usuarios
                          .asMap()
                          .entries
                          .where((entry) => _selecionados[entry.key])
                          .map((entry) => entry.value.idUsuario)
                          .toList(), // Adicione os usuários aqui se necessário
                    );

                    // Atualiza o projeto no banco de dados
                    final id =
                        await projetoDao.updateProjeto(projetoAtualizado);
                    // Atualiza as associações de usuários na tabela projetoUsuario
                    // Primeiro, exclui todas as associações existentes
                    await usuarioDao
                        .deleteProjetoUsuarios(projetoAtualizado.idProjeto);

                    // Em seguida, insere as novas associações
                    for (var usuarioId in projetoAtualizado.usuarios) {
                      await usuarioDao.createProjetoUsuario(
                          projetoAtualizado.idProjeto, usuarioId);
                    }
                    // Imprime o id do projeto atualizado
                    print('Projeto atualizado com id: $id');
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
