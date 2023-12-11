import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:gerenciamento_projetos/model/classes_projeto.dart';
import 'package:gerenciamento_projetos/database/database_provider.dart';
//import 'package:gerenciamento_projetos/database/table_usuario_dao.dart';
import 'package:gerenciamento_projetos/dao/memory/usuario_dao_memory.dart';
class FormUsuario extends StatefulWidget {
  final Function(Usuario) onUsuarioSubmit;

  FormUsuario({required this.onUsuarioSubmit});

  @override
  _FormUsuarioState createState() => _FormUsuarioState();
}

class _FormUsuarioState extends State<FormUsuario> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário de Usuário'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'E-mail'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final nome = _nomeController.text;
                final email = _emailController.text;

                if (nome.isNotEmpty && email.isNotEmpty) {
                  final novoUsuario = Usuario(
                    idUsuario: DateTime.now().millisecondsSinceEpoch,
                    nomeUsuario: nome,
                    emailUsuario: email,
                  );

                  // Cria uma instância do UsuarioDao
                  final usuarioDao = UsuarioDao();

                  // Insere o novo usuário no banco de dados
                  final id = await usuarioDao.createUsuario(novoUsuario);

                  // Imprime o id do usuário inserido
                  print('Usuário inserido com id: $id');

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
