import 'package:gerenciamento_projetos/pages/list_usuarios.dart';
import 'package:gerenciamento_projetos/pages/list_tarefas.dart';
import 'package:gerenciamento_projetos/pages/list_projetos.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Usuários',
      theme: ThemeData(
        colorSchemeSeed: Colors.blueGrey,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      home: ListProjetos(),
      debugShowCheckedModeBanner: false,
    );
  }
}
