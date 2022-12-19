import 'package:app_olx/route_generator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class Anuncios extends StatefulWidget {

  @override
  State<Anuncios> createState() => _AnunciosState();
}

class _AnunciosState extends State<Anuncios> {

  List<String> _listItemMenu = [];

  _escolhaMenuItem(String listItemMenu){

    switch(listItemMenu){
      case  "Entrar / Cadastrar" : 
        Navigator.pushNamed( context, RouteGenerator.ROUTE_LOGIN);
      break;
      case  "Meus Anúncios" : 
        Navigator.pushNamed( context, RouteGenerator.ROUTE_MEUS_ANUNCIOS);
      break;
      case  "Deslogar" : 
       _deslogarUsuario();
       Navigator.pushNamed( context, RouteGenerator.ROUTE_LOGIN);
      break;
        
    }

  }

 Future _deslogarUsuario() async {
   FirebaseAuth auth = FirebaseAuth.instance;
   await auth.signOut();
 }

  Future _verificarUsuarioLogado() async{
    FirebaseAuth auth = FirebaseAuth.instance;
    var usuarioLogado = auth.currentUser;
     
    if(usuarioLogado == null){

      _listItemMenu = [
        "Entrar / Cadastrar"
      ];

    }
    else{

      _listItemMenu = [
        "Meus Anúncios",
        "Deslogar"
      ];

    }
     
  }

  @override
  void initState() {
    super.initState();
    _verificarUsuarioLogado();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff9c27b0),
        title: Text("OXL"),
        actions: [
          PopupMenuButton(
            onSelected: _escolhaMenuItem,
            itemBuilder: (context){
              return _listItemMenu.map((item){
                return PopupMenuItem<String>(
                  value: item,
                  child: Text(item)
                  );
              }).toList();
              
            })
        ],

      ),
      body: Container(
        child: Text("Anuncios!"),
      ),
    );
  }
}