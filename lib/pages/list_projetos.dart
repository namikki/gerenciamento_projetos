import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:gerenciamento_projetos/model/classes_projeto.dart';
import 'package:gerenciamento_projetos/pages/form_projeto.dart';

class ListProjetos extends StatefulWidget {
  @override
  _ListProjetosState createState() => _ListProjetosState();
}

class _ListProjetosState extends State<ListProjetos> {
  List<Projeto> projetos = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Projetos'),
      ),
      body: ListView.builder(
        itemCount: projetos.length,
        itemBuilder: (context, index) {
          final projeto = projetos[index];
          return ListTile(
            title: Text(projeto.nomeProjeto),
            subtitle: Text(
                'Início: ${DateFormat('dd/MM/yyyy').format(projeto.dataInicioProjeto)}\n'
                'Prazo: ${DateFormat('dd/MM/yyyy').format(projeto.prazoProjeto)}\n'
                '${projeto.descricaoProjeto}'),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FormProjeto(
                      onProjetoSubmit: (projetoEditado) {
                        setState(() {
                          // Remover o projeto antigo e adicionar o projeto editado
                          projetos.remove(projeto);
                          projetos.add(projetoEditado);
                        });
                      },
                      projeto: projeto,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FormProjeto(
                onProjetoSubmit: (projeto) {
                  setState(() {
                    projetos.add(projeto);
                  });
                },
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
