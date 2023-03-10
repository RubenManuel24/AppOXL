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

  FirebaseFirestore db = FirebaseFirestore.instance;
  List<DropdownMenuItem<String>> _listaDeProvincia = [];
  List<DropdownMenuItem<String>> _listaDeCategoria = [];
  String _itemSelecionadoProvincia;
  String _itemSelecionadoCategoria;
  List<String> _listItemMenu = [];

  var _controllerStream = StreamController<QuerySnapshot>.broadcast();

  Future<Stream<QuerySnapshot>> _adicionarListernerAnuncios() async {
      
      Stream<QuerySnapshot> stream = db
        .collection("anuncios")
        .snapshots();
          
      stream.listen((dados){
         _controllerStream.add(dados);
      });
  }

  Future<Stream<QuerySnapshot>> _filtrarAnuncios({ String provincia, String categoria}) async {
      
      Query query = db.collection("anuncios");

      if(provincia != null){
         query = query.where("provincia", isEqualTo: provincia.toString());
      }

      if(categoria != null){
         query = query.where("categoria", isEqualTo: categoria.toString());
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
        title: Text("OLX"),
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
                    onChanged: (provincia){
                      setState(() {
                        _itemSelecionadoCategoria = provincia;
                        _filtrarAnuncios(
                          provincia: provincia
                        );
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
                    hint: Text("Categoria",
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
                    onChanged: (categoria){
                      setState(() {
                        _itemSelecionadoProvincia = categoria;
                        _filtrarAnuncios(
                          categoria: categoria);
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
                return Center(
                 child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      backgroundColor: Color(0xff9c27b0),
                      color: Colors.white,
                      ),
                    Text("Carregando os dados...")
                  ],
                ),
              );
              break;
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
                      Navigator.pushNamed(
                        context,
                         RouteGenerator.ROUTE_DETALHE_ANUNCIOS,
                         arguments: anuncioProduto
                         );
                    },
                  );

                })
                );
             }
             
               
            }
               return Container();
          }
          )

       ],
      )
    ),
  );
 }
}