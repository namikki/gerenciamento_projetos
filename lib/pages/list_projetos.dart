import 'package:flutter/material.dart';
import 'package:gerenciamento_projetos/model/classes_projeto.dart';
import 'package:gerenciamento_projetos/pages/form_projeto.dart';
import 'package:gerenciamento_projetos/dao/memory/projeto_dao_memory.dart';
import 'package:gerenciamento_projetos/dao/memory/usuario_dao_memory.dart';
//adicionar o table_projetoUsuario

class ListProjetos extends StatefulWidget {
  @override
  _ListProjetosState createState() => _ListProjetosState();
}

class _ListProjetosState extends State<ListProjetos> {
  List<Projeto> projetos = [];

  @override
  void initState() {
    super.initState();
    loadProjetos();
  }

  void loadProjetos() async {
    final projetoDao = ProjetoDao();
    final allProjetos = await projetoDao.getProjetos();
    setState(() {
      projetos = allProjetos;
    });
  }

  Future<List<Usuario>> getUsuariosDoProjeto(int projetoId) async {
    final usuarioDao = UsuarioDao();
    return await usuarioDao.getUsuariosDoProjeto(projetoId);
  }

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
          return FutureBuilder<List<Usuario>>(
            future: getUsuariosDoProjeto(projeto.idProjeto),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                final usuarios = snapshot.data ?? [];
                return ListTile(
                  title: Text(projeto.nomeProjeto),
                  subtitle: Text('Usuários: ' + usuarios.map((u) => u.nomeUsuario).join(', ')),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.edit),
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
                                projeto: projeto,
                              ),
                            ),
                          ).then((_) => loadProjetos());
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          final projetoDao = ProjetoDao();
                          await projetoDao.deleteProjeto(projeto.idProjeto);
                          loadProjetos();
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    // Adicione a navegação para a página de detalhes
                    // por exemplo, Navigator.push(context, MaterialPageRoute(builder: (context) => DetalhesProjeto(projeto)));
                  },
                );
              } else {
                return CircularProgressIndicator();
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
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
          loadProjetos();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
