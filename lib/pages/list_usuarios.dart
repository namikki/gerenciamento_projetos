import 'package:flutter/material.dart';
import 'package:gerenciamento_projetos/model/classes_projeto.dart';
import 'package:gerenciamento_projetos/pages/form_usuario.dart';
import 'package:gerenciamento_projetos/dao/memory/usuario_dao_memory.dart';

class ListUsuario extends StatefulWidget {
  @override
  _ListUsuarioState createState() => _ListUsuarioState();
}

class _ListUsuarioState extends State<ListUsuario> {
  List<Usuario> usuarios = [];

  @override
  void initState() {
    super.initState();
    loadUsuarios();
  }

  void loadUsuarios() async {
    final usuarioDao = UsuarioDao();
    final allUsuarios = await usuarioDao.getUsuarios();
    setState(() {
      usuarios = allUsuarios;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Usuários'),
      ),
      body: ListView.builder(
        itemCount: usuarios.length,
        itemBuilder: (context, index) {
          final usuario = usuarios[index];
          return ListTile(
            title: Text(usuario.nomeUsuario),
            subtitle: Text(usuario.emailUsuario),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FormUsuario(
                          onUsuarioSubmit: (usuarioAtualizado) {
                            setState(() {
                              usuarios[index] = usuarioAtualizado;
                            });
                          },
                          usuario: usuario,
                        ),
                      ),
                    ).then((_) => loadUsuarios());
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    final usuarioDao = UsuarioDao();
                    await usuarioDao.deleteUsuario(usuario.idUsuario);
                    loadUsuarios();
                  },
                ),
              ],
            ),
            onTap: () {
              // Adicione a navegação para a página de detalhes ou edição
              // por exemplo, Navigator.push(context, MaterialPageRoute(builder: (context) => DetalhesUsuario(usuario)));
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FormUsuario(
                onUsuarioSubmit: (usuario) {
                  setState(() {
                    usuarios.add(usuario);
                  });
                },
              ),
            ),
          );
          loadUsuarios();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
