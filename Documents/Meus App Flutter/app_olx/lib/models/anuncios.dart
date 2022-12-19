import 'package:cloud_firestore/cloud_firestore.dart';

class AnuncioProduto {

  String _id;
  String _provincias;
  String _categorias;
  String _titulo;
  String _preco;
  String _telefone;
  String _descricao;
  List<String> _fotos;
  
  AnuncioProduto.fromCapturaAnuincio(DocumentSnapshot documentSnapshot){
    this._id = documentSnapshot.id;
    this._provincias = documentSnapshot["provincia"];
    this._categorias = documentSnapshot["categoria"];
    this._titulo     = documentSnapshot["titulo"];
    this._preco      = documentSnapshot["preco"];
    this._telefone   = documentSnapshot["telefone"];
    this._descricao  = documentSnapshot["descricao"];
    this._fotos      = List<String>.from(documentSnapshot["fotos"]);

  }

  AnuncioProduto.gerarId(){
     FirebaseFirestore db = FirebaseFirestore.instance;
     CollectionReference anuncios = db.collection("meus_anuncios");
     this._id = anuncios.doc().id;

     this.setFotos = [];
  }

  String get getId => this._id;
  
  set setId(String id){
     this._id = id;
  }

  String get getProvincia => this._provincias;

  set setProvincia(String provincia){
     this._provincias = provincia;
  }

  String get getCategoria => this._categorias;
  
  set setCategoria(String categorias){
     this._categorias = categorias;
  }

  String get getTitulo => this._titulo;

  set setTitulo(String titulo){
     this._titulo = titulo;
  }

  String get getPreco => this._preco;

  set setPreco(String preco){
     this._preco = preco;
  }

  String get getTelefone => this._telefone;

  set setTelefone(String telefone){
     this._telefone = telefone;
  }

  String get getDescriacao => this._descricao;

  set setDescricao(String descricao){
     this._descricao = descricao;
  }

  get getFoto => this._fotos;

  set setFotos(List<String> fotos){
     this._fotos = fotos;
  }

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "id"         : _id,
      "provincia"  : _provincias,
      "categoria"  : _categorias,
      "titulo"     : _titulo,
      "preco"      : _preco,
      "telefone"   : _telefone,
      "descricao"  : _descricao,
      "fotos"      : _fotos,
    };
    return map;
  }

}