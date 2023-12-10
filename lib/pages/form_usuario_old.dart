// arquivo: form_usuario.dart
import 'package:flutter/material.dart';
import 'package:gerenciamento_projetos/model/classes_projeto.dart';
import 'package:gerenciamento_projetos/dao/classes_dao.dart';
import 'package:gerenciamento_projetos/dao/memory/projeto_dao_memory.dart';

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
              onPressed: () {
                final nome = _nomeController.text;
                final email = _emailController.text;

                if (nome.isNotEmpty && email.isNotEmpty) {
                  final novoUsuario = Usuario(
                    idUsuario: DateTime.now().millisecondsSinceEpoch,
                    nomeUsuario: nome,
                    emailUsuario: email,
                  );

                  widget.onUsuarioSubmit(novoUsuario);
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
