import 'dart:async';

import 'package:app_olx/models/anuncios.dart';
import 'package:app_olx/route_generator.dart';
import 'package:app_olx/views/anuncios.dart';
import 'package:app_olx/views/widgets/itemCustomizada.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class MeusAnuncios extends StatefulWidget {

   @override
   State<MeusAnuncios> createState() => _MeusAnunciosState();
}

class _MeusAnunciosState extends State<MeusAnuncios> {

  final _streamController = StreamController<QuerySnapshot>.broadcast();
  String _idUserLogado;

  _removerAnuncio(String idAnuncio) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("meus_anuncios")
     .doc( _idUserLogado )
     .collection("anuncio")
     .doc(idAnuncio)
     .delete()
     .then((_) {
       
        db.collection("anuncios")
         .doc(idAnuncio)
         .delete();

     });
  }

_idUsuarioLogado() async {

 //Salvar anuncio no Firestore
 FirebaseAuth auth = FirebaseAuth.instance;
 User usuarioLogado = auth.currentUser;
 String idUsuarioLogado =  usuarioLogado.uid;
 _idUserLogado = idUsuarioLogado;

 }
   
 Future<Stream<QuerySnapshot>> _adicionarLitenerAnuncios() async {

   await _idUsuarioLogado();

   FirebaseFirestore db = FirebaseFirestore.instance;
   Stream<QuerySnapshot> stream = db
     .collection("meus_anuncios")
     .doc( _idUserLogado )
     .collection("anuncio")
     .snapshots();

     stream.listen((dados) {
        _streamController.add(dados);
      });
  }

  @override
  void initState() {
    super.initState();
    _adicionarLitenerAnuncios();
    
  }
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff9c27b0),
        title: Text("Meus Anúncios"),
      ),
      floatingActionButton:FloatingActionButton(
        backgroundColor: Color(0xff9c27b0),
        onPressed: (){
           Navigator.pushNamed(context, RouteGenerator.ROUTE_NOVOS_ANUNCIOS);
        },
        child: Icon(Icons.add, color: Colors.white,),
        
        ),
      body:StreamBuilder(
        stream: _streamController.stream,
        builder: (context, snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(backgroundColor: Color(0xff9c27b0),),
                    Text("Carregando os dados...")
                  ],
                ),
              );
             break;
            case ConnectionState.active:
            case ConnectionState.done:
             
             if(snapshot.hasError){
              return Text("Erro ao carregar os dados!");
             }
              
           QuerySnapshot querySnapshot = snapshot.data;

            return ListView.builder(
                itemCount: querySnapshot.docs.length,
                itemBuilder: (_, index){

                List<DocumentSnapshot> listeAnuncio = querySnapshot.docs.toList();
                DocumentSnapshot documentSnapshot = listeAnuncio[index];
                AnuncioProduto anuncioProduto = AnuncioProduto.fromCapturaAnuincio(documentSnapshot);

                  return ItemCustomizada( 
                    anuncioProduto: anuncioProduto,
                    onPressedRemove: (){
                      showDialog(
                        context: context, 
                        builder: (_){
                           return AlertDialog(
                            title: Text("Remover item!"),
                            content: Text("Tens certeza que queres eliminar item?"),
                            actions: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    onPressed: (){
                                      Navigator.of(context).pop();
                                    }, 
                                    child: Text("Cancelar",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold
                                    ),
                                    ),
                                    style: TextButton.styleFrom(backgroundColor: Colors.red,)
                                  ),
                                  TextButton(
                                    onPressed: (){
                                      _removerAnuncio(anuncioProduto.getId);
                                      Navigator.of(context).pop();
                                    }, 
                                    child: Text("Remover",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold
                                    ),
                                    ),
                                    style: TextButton.styleFrom(backgroundColor: Colors.red,)
                                  )
                                ],
                              )
                            ],

                           );
                        }
                        );
                    },
                    
                  );
              }
           ) ;       
          }
        })
    );
  }
}

