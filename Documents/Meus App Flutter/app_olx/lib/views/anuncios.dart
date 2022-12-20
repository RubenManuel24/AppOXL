import 'dart:async';

import 'package:app_olx/route_generator.dart';
import 'package:app_olx/utils/configuracoes.dart';
import 'package:app_olx/views/widgets/itemCustomizada.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/anuncios.dart';
class Anuncios extends StatefulWidget {

  @override
  State<Anuncios> createState() => _AnunciosState();
}

class _AnunciosState extends State<Anuncios> {


  List<DropdownMenuItem<String>> _listaDeProvincia = [];
  List<DropdownMenuItem<String>> _listaDeCategoria = [];
  String _itemSelecionadoProvincia;
  String _itemSelecionadoCategoria;
  List<String> _listItemMenu = [];

  final _controllerStream = StreamController<QuerySnapshot>.broadcast();

  Future<Stream<QuerySnapshot>> _adicionarListernerAnuncios() async {
      
      FirebaseFirestore db = FirebaseFirestore.instance;
      Stream<QuerySnapshot> stream = db
        .collection("anuncios")
        .snapshots();
          
      stream.listen((dados){
         _controllerStream.add(dados);
      });
  }

  Future<Stream<QuerySnapshot>> _filtrarAnuncios() async {
      
      FirebaseFirestore db = FirebaseFirestore.instance;
      Query query = db .collection("anuncios");

      if(_itemSelecionadoProvincia != null){
         query = query.where("provincia", isEqualTo: _itemSelecionadoProvincia);
      }

      if(_itemSelecionadoCategoria != null){
         query = query.where("categoria", isEqualTo: _itemSelecionadoCategoria);
      }
  
      Stream<QuerySnapshot> stream = query.snapshots();
      stream.listen((dados) { 
         _controllerStream.add(dados);
      });
  }


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

  _capturandoTextsProvinciaCategoria(){

    //Capturar provincia
    _listaDeProvincia = Configuracoes.CapturarProvincias();

    //Capturar Categoria
    _listaDeCategoria = Configuracoes.CapturarCategorias();
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
    _adicionarListernerAnuncios();
    _capturandoTextsProvinciaCategoria();
    
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
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
           children: [
            //Filter Provincia
            Expanded(
                child: DropdownButtonHideUnderline(
                  child: Center(
                    child: DropdownButton(
                    iconEnabledColor: Color(0xff9c27b0) ,
                    isExpanded: true,
                    hint: Text("Províncias",
                    style: TextStyle(
                      color:Color(0xff9c27b0) 
                     ),
                    ),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 19,
                      fontWeight: FontWeight.bold
                    ),
                    value: _itemSelecionadoCategoria,
                    items: _listaDeProvincia, 
                    onChanged: (valor){
                      setState(() {
                        _itemSelecionadoCategoria = valor;
                        _filtrarAnuncios();
                      });
                       
                    }
                  ),
                  )
                )
            ),

            Container(
              color: Colors.grey[200],
              width: 5,
              height: 60,
            ),

            //Filtrar Categoria
            Expanded(
                child: DropdownButtonHideUnderline(
                  child: Center(
                    child: DropdownButton(
                    iconEnabledColor: Color(0xff9c27b0) ,
                    isExpanded: true,
                    hint: Text("Categoia",
                    style: TextStyle(
                      color:Color(0xff9c27b0) 
                     ),
                    ),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 19,
                      fontWeight: FontWeight.bold
                    ),
                    value: _itemSelecionadoProvincia,
                    items: _listaDeCategoria, 
                    onChanged: (valor){
                      setState(() {
                        _itemSelecionadoProvincia = valor;
                        _filtrarAnuncios();
                      });
                       
                    }
                  ),
                  )
                )
            ),
          ],
         ),
         //Listando anuncio
         StreamBuilder(
          stream: _controllerStream.stream,
          builder: (_, snapshot){
            switch(snapshot.connectionState){
              case ConnectionState.none:
              case ConnectionState.waiting: 
              case ConnectionState.active:
              case ConnectionState.done:
             
             QuerySnapshot querySnapshot = snapshot.data;
             if(snapshot != null && snapshot.hasData ){

                  if(querySnapshot.docs.isEmpty){
                  return Container(
                      padding: EdgeInsets.all(20),
                        child: Text("Nenhum anúncio!",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        ),
                        ),
                    );
                }

                return Expanded(
                child: ListView.builder(
                 itemCount: querySnapshot.docs.length,
                 itemBuilder: (_, index){

                  List<DocumentSnapshot> anuncio = querySnapshot.docs.toList();
                  DocumentSnapshot documentSnapshot = anuncio[index];
                  AnuncioProduto anuncioProduto = AnuncioProduto.fromCapturaAnuincio(documentSnapshot);

                  return  ItemCustomizada(
                    anuncioProduto: anuncioProduto,
                    itemOnTap: (){

                    },
                  );

                })
                );
             }
             return Container();
               
              
            }

          }
          )

       ],
      )
    ),
  );
 }
}