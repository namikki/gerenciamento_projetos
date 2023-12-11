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
/*
An error occurred while initializing the web worker.
This is likely due to a failure to find the worker javascript file at sqflite_sw.js

Please check the documentation at https://github.com/tekartik/sqflite/tree/master/packages_web/sqflite_common_ffi_web#setup-binaries to setup the needed binaries.

*/

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
