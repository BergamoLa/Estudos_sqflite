import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


void main() => runApp(
  MaterialApp(
    home: Home(),
  )

);

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  _recuperarBancoDados() async {
    final caminhoBancodeDados = await getDatabasesPath();
    final localBancodados = join(caminhoBancodeDados, "banco.db");

    var bd = await openDatabase(
      localBancodados,
      version: 1,
      onCreate: (db, dbVersaoRecente){
        String sql = "CREATE TABLE usuarios(id INTEGER PRIMARY KEY AUTOINCREMENT, nome TEXT, idade INTEGER)";
        db.execute(sql);

      }
    );
      return bd;

  }

    _salvar() async {
      Database bd = await _recuperarBancoDados();

        Map<String, dynamic> dadosUsuario = {
          "nome": "Lais covas",
          "idade": 24
        };
        int id = await bd.insert("usuarios", dadosUsuario);
        print("salvo $id");
    }

    _listarUsuarios() async {
      Database bd = await _recuperarBancoDados();
     // String filtro = "Caio";
     String sql2 = "SELECT * FROM usuarios";
      //String sql2 = "SELECT * FROM usuarios WHERE id = 5 ";
      //String sql2 = "SELECT * FROM usuarios WHERE idade >= 30 AND idade <= 58";
      //String sql2 = "SELECT * FROM usuarios WHERE idade BETWEEN 18 AND 46 ";
      //String sql2 = "SELECT * FROM usuarios WHERE idade IN (18,30) ";
      //String sql2 = "SELECT * FROM usuarios WHERE nome LIKE '%"+ filtro + "%' ";  //o % serve como procure nome e o que vier na frente
      //String sql2 = "SELECT * FROM usuarios WHERE 1 = 1 ORDER BY UPPER(nome) ASC";
      List usuarios = await bd.rawQuery(sql2);
      
      for(var usuario in usuarios){
        print(
            "Item id :" + usuario['id'].toString() + " nome: " + usuario['nome'] + "  idade: " + usuario['idade'].toString());
      }

      //print("usuarios" + usuarios.toString());
      

    }


    _recuperarUsuarioById(int id) async {
      Database bd = await _recuperarBancoDados();

      List usuarios = await bd.query(
        "usuarios",
        columns: ["id", "nome", "idade"],
        where: "id = ?",
        whereArgs: [id]


      );
      for(var usuario in usuarios){
        print(
            "Item id :" + usuario['id'].toString() + " nome: " + usuario['nome'] + "  idade: " + usuario['idade'].toString());
      }


    }

  @override
  Widget build(BuildContext context) {
   // _salvar();
   // _listarUsuarios();
    _recuperarUsuarioById(2);
    return Container();
  }
}
