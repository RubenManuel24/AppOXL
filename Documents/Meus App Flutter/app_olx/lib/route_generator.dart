import 'package:app_olx/views/anuncios.dart';
import 'package:app_olx/views/detalhe_anuncio.dart';
import 'package:app_olx/views/login.dart';
import 'package:app_olx/views/meus_anuncios.dart';
import 'package:app_olx/views/novos_anuncios.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  
  static const String ROUTE_ANUNCIOS = "/";
  static const String ROUTE_LOGIN = "/login";
  static const String ROUTE_MEUS_ANUNCIOS = "/meusAnuncios";
  static const String ROUTE_NOVOS_ANUNCIOS = "/novosAnuncios";
  static const String ROUTE_DETALHE_ANUNCIOS = "/detalheAnuncios";
  
  static Route<dynamic> generateRoute(RouteSettings settings){
    final args = settings.arguments;

    switch(settings.name){
      case ROUTE_ANUNCIOS : 
        return MaterialPageRoute(
          builder: (context) => Anuncios() );
      case ROUTE_LOGIN : 
        return MaterialPageRoute(
          builder: (context) => Login() );
      case ROUTE_MEUS_ANUNCIOS : 
        return MaterialPageRoute(
          builder: (context) => MeusAnuncios() );
      case ROUTE_NOVOS_ANUNCIOS : 
        return MaterialPageRoute(
          builder: (context) => NovosAnuncios() );
     case ROUTE_DETALHE_ANUNCIOS : 
        return MaterialPageRoute(
          builder: (context) => DetalheAnuncio(args) );
      default : {
        return _errorRoute();
      }

    }

  }

  static Route<dynamic> _errorRoute(){

    return MaterialPageRoute(
      builder: (context){
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xff9c27b0),
            title: Text("Tela não encontrada!"),
          ),
          body: Container(
            child: Center(
              child: Text("Tela não encontrada!"),
            ),
          ),
        );

      });
  }

}
