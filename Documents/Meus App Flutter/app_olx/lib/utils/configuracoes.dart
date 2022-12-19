import 'package:app_olx/models/categoria.dart';
import 'package:app_olx/models/provincias.dart';
import 'package:flutter/material.dart';

class Configuracoes {

    static List<DropdownMenuItem<String>> CapturarCategorias(){

     List<DropdownMenuItem<String>> listaDeCategoria = [];
     Categoria categoria = Categoria();
     //Captura de categorias
     for(var eletronico in categoria.listaDeCagoria()){

       listaDeCategoria.add(
       DropdownMenuItem(
         child: Text(eletronico) , value: eletronico)
    );
   }return listaDeCategoria;
     
  }


  static List<DropdownMenuItem<String>> CapturarProvincias(){

    List<DropdownMenuItem<String>> listaDeProvincia = [];
    Provincias provincia = Provincias();
    //Captura de categorias
     for(var eletronico in provincia.listaDeProvincias()){

       listaDeProvincia.add(
       DropdownMenuItem(
         child: Text(eletronico) , value: eletronico)
    );
   }
     return listaDeProvincia;
  }

}
