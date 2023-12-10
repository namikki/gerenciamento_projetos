// arquivo: list_usuario.dart
import 'package:flutter/material.dart';
import 'package:gerenciamento_projetos/model/classes_projeto.dart';
import 'package:gerenciamento_projetos/dao/classes_dao.dart';
import 'package:gerenciamento_projetos/dao/memory/projeto_dao_memory.dart';
import 'package:gerenciamento_projetos/pages/form_usuario.dart';

class ListUsuario extends StatefulWidget {
  @override
  _ListUsuarioState createState() => _ListUsuarioState();
}

class _ListUsuarioState extends State<ListUsuario> {
  List<Usuario> usuarios = [];

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
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  usuarios.remove(usuario);
                });
              },
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
          final novoUsuario = await Navigator.push(
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
        },
        child: Icon(Icons.add),
      ),
    );
  }
}