
import 'dart:async';
import 'dart:ui';
import 'package:app_olx/models/anuncios.dart';
import 'package:app_olx/models/categoria.dart';
import 'package:app_olx/models/provincias.dart';
import 'package:app_olx/route_generator.dart';
import 'package:app_olx/utils/configuracoes.dart';
import 'package:app_olx/views/anuncios.dart';
import 'package:app_olx/views/widgets/botao_customizado.dart';
import 'package:app_olx/views/widgets/input_customizado.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:validadores/validadores.dart';
import 'package:firebase_storage/firebase_storage.dart';

class NovosAnuncios extends StatefulWidget {

  @override
  State<NovosAnuncios> createState() => _NovosAnunciosState();
}

class _NovosAnunciosState extends State<NovosAnuncios> {

TextEditingController _controllerTitulo = TextEditingController();
TextEditingController _controllerPreco = TextEditingController();
TextEditingController _controllerTelefone = TextEditingController();
TextEditingController _controllerDescricao = TextEditingController();
AnuncioProduto _anuncioProduto;
BuildContext _dialogcontext;

 final _formKey = GlobalKey<FormState>();
 final List<File> _listImagend = [];

 List<DropdownMenuItem<String>> _listaDeProvincia = [];
 List<DropdownMenuItem<String>> _listaDeCategoria = [];

 _selecionarImagenGaleria() async {
   File imageSelecionada = await ImagePicker.pickImage(source: ImageSource.gallery);
   if(imageSelecionada != null){
      setState(() {
        _listImagend.add(imageSelecionada);
      });
   }
 }

 _dialogoAlert(BuildContext context){
   
   showDialog(
    context: context, 
    barrierDismissible: false,
    builder: (context){
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            const CircularProgressIndicator(color: Color(0xff9c27b0), backgroundColor: Colors.white),
            const SizedBox(height:20),
            const Text("Carregando anúncio...")
          ],
        ),
      );
    }
  );
 }

 //metodos para salvar anuncios no FireBase
 _salvarAnuncios() async {

  _dialogoAlert(_dialogcontext);

  //Upload das imagens no Storage  
  await _uploadImagens();

 //Salvar anuncio no Firestore
 FirebaseAuth auth = FirebaseAuth.instance;
 User usuarioLogado = auth.currentUser;
 String idUsuarioLogado =  usuarioLogado.uid;

 FirebaseFirestore db = FirebaseFirestore.instance;
   db.collection("meus_anuncios")
    .doc(idUsuarioLogado)
    .collection("anuncio")
    .doc(_anuncioProduto.getId)
    .set(_anuncioProduto.toMap())
    .then((_) {

        db.collection("anuncios")
         .doc(_anuncioProduto.getId)
         .set(_anuncioProduto.toMap())
         .then((_) {
            
             Navigator.pop(_dialogcontext);
             Navigator.pop(context);
            
         });

    });

 }

 Future _uploadImagens() async {
    
   FirebaseStorage storage = FirebaseStorage.instance;
   var pastaRaiz = storage.ref();

   for(var imagem in _listImagend){
    
     String nomeImagem = DateTime.now().millisecondsSinceEpoch.toString();
     var arquivo = await pastaRaiz
      .child("meus_anuncios")
      .child(_anuncioProduto.getId) //vamos salvar o id antes de salvar os dados no Storage
      .child(nomeImagem);

      UploadTask uploadTask = arquivo.putFile(imagem);
      var taskSnapshot = await uploadTask;

      String url = await taskSnapshot.ref.getDownloadURL();
      _anuncioProduto.getFoto.add(url);
   }
    
 }

//Métodos para add textos na lista da Províncias e Estados
 _capturandoTextsProvinciaCategoria(){

  //Captura de provincias
   _listaDeProvincia = Configuracoes.CapturarProvincias();

  //Captura de provincias com pacote de brazil
  /*for(var estado in Estados.listaEstados){
    _listaDeProvincia.add(
      DropdownMenuItem(
        child: Text(estado) , value: estado,)
   );
     
  }*/
  
  //Captura de categorias
  _listaDeCategoria = Configuracoes.CapturarCategorias();
   
   /*_listaDeEstados.add(
      DropdownMenuItem(
        child: Text("Luanda"), value: 1,)
   );

   _listaDeEstados.add(
      DropdownMenuItem(
        child: Text("Benguela"), value: 2,)
   );

   _listaDeEstados.add(
      DropdownMenuItem(
        child: Text("Bengo"), value: 3,)
   );*/
  
 }

 @override
  void initState() {
    super.initState();
    _capturandoTextsProvinciaCategoria();

    _anuncioProduto = AnuncioProduto.gerarId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff9c27b0),
        title: Text("Novos Anúncios"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //Configurando FormField()
                FormField<List>(
                  initialValue: _listImagend,
                  validator: (imagens){
                        if(imagens.length == 0){
                           return "Necessário selecionar uma imagem!";
                        }
                           return null;
                  },
                  builder: (state){
                     return Column(
                       children: [
                        Container(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _listImagend.length + 1,//3
                            itemBuilder: (context, indice){
                              //indice = 0
                              //1
                              //2
                              // ==  _listImagend.length
                              if(indice == _listImagend.length ){
                                //Add container permanente circular com icon
                                 return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: GestureDetector(
                                    onTap: (){
                                        _selecionarImagenGaleria();
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: Colors.grey[400],
                                      radius: 50,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.add_a_photo,
                                          color: Colors.grey[100],
                                          ),
                                          Text(
                                            "Adicionar",
                                              style: TextStyle(
                                              color: Colors.grey[100]
                                            ),
                                          )
                                        ]
                                      ),
                                    ),
                                  ),
                                );
                              }
                                
                                //Add container de imagens selecionada
                              if(_listImagend.isNotEmpty){
                                   return  Padding(
                                       padding: EdgeInsets.symmetric(horizontal: 8),
                                       child: GestureDetector(
                                        onTap: (){
                                          showDialog(
                                            context: context, 
                                            builder: (contetxt){
                                               return Dialog(
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                       Image.file(_listImagend[indice]),
                                                       TextButton(
                                                        onPressed: (){
                                                          setState(() {
                                                            _listImagend.removeAt(indice);
                                                          });
                                                           Navigator.pop(context);
                                                        }, 
                                                        child: Text("Excluir",
                                                           // ignore: prefer_const_constructors
                                                            style: TextStyle(
                                                            color: Colors.red
                                                           ),
                                                         ),
                                                         style: TextButton.styleFrom(backgroundColor: Colors.white),
                                                        )
                                                    ],  
                                                  ),

                                               );
                                            }
                                            );

                                        },
                                        child: CircleAvatar(
                                           radius: 50,
                                           backgroundImage: FileImage(_listImagend[indice]),
                                           child: Container(
                                             color: Color.fromRGBO(255, 255, 255, 0.3),
                                             child: Icon(Icons.delete,
                                             color: Colors.red,
                                             ),
                                             alignment: Alignment.center,
                                           )
                                        ),
                                       ),
                                    );
                               }
                                return Container();
                            }
                          ),
                        ),
                        if(state.hasError)
                           Text(
                            "[${state.errorText}]",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 14
                            ),
                          ),
                     ],
                   );
                  }
                ),
                //Configurando DropDonw
                Row(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                   // ignore: prefer_const_constructors
                   Expanded(
                    child:Padding(
                      padding: const EdgeInsets.all(8),
                      child: DropdownButtonFormField(
                        onSaved: (provincias){
                          _anuncioProduto.setProvincia = provincias;
                        },
                        isExpanded: true,
                        hint: Text(
                          "Províncias",
                          style: TextStyle(
                            color: Color(0xff9c27b0),
                          ),
                        ),
                        // ignore: prefer_const_constructors
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                        ),
                        items: _listaDeProvincia, 
                        validator: (valor){
                            return Validador()
                                   .add(Validar.OBRIGATORIO, msg: "Campo obrigatório!" )
                                   .valido(valor);
                        },
                        onChanged: (valor){
                           //print("Estado: $valor");
                           setState((){
                              _listaDeProvincia = valor;
                           });
                         }
                       ),
                     )
                    ),
                    SizedBox(width: 5,),
                    Expanded(
                    child:Padding(
                      padding: const EdgeInsets.all(8),
                      child: DropdownButtonFormField(
                        onSaved: (categoria){
                          _anuncioProduto.setCategoria = categoria;
                        },
                        isExpanded: true,
                        hint: Text("Categoria",
                          style: TextStyle(
                            color: Color(0xff9c27b0),
                          ),
                        ),
                        // ignore: prefer_const_constructors
                         style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                        ),
                        items: _listaDeCategoria, 
                        validator: (valor){
                            return Validador()
                                   .add(Validar.OBRIGATORIO, msg: "Campo obrigatório!" )
                                   .valido(valor);
                        },
                        onChanged: (valor){
                           //print("Estado: $valor");
                           setState((){
                              _listaDeCategoria = valor;
                           });
                         }
                       ),
                     )
                    ),
                 ]
                ),
                //Configurando TextFormField (Formularios)
                Padding(
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  child: InputCustomizado(
                    onSaved: (titulo){
                          _anuncioProduto.setTitulo = titulo;
                        },
                    controller: _controllerTitulo,
                    textInputType: TextInputType.text,
                    hintText: "Titutlo",
                    validador: (valor){
                      return Validador()
                              .add(Validar.OBRIGATORIO, msg: "Campo obrigatório!")
                              .valido(valor);
                    },
                   ),
                  ),
                  Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: InputCustomizado(
                    onSaved: (preco){
                          _anuncioProduto.setPreco = preco;
                     },
                    controller: _controllerPreco,
                    textInputType: TextInputType.number,
                    hintText: "Preço",
                    inputFormatter: [
                       FilteringTextInputFormatter.digitsOnly,
                       RealInputFormatter()
                    ],
                    validador: (valor){
                      return Validador()
                              .add(Validar.OBRIGATORIO, msg: "Campo obrigatório!")
                              .valido(valor);
                    },
                   ),
                  ),
                  Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: InputCustomizado(
                    onSaved: (telefone){
                          _anuncioProduto.setTelefone= telefone;
                    },
                    controller: _controllerTelefone,
                    textInputType: TextInputType.number,
                    hintText: "Telefone",
                    inputFormatter: [
                       FilteringTextInputFormatter.digitsOnly,
                    ],
                    validador: (valor){
                      return Validador()
                              .add(Validar.OBRIGATORIO, msg: "Campo obrigatório!")
                              .maxLength(9, msg: "Menos de 9 digitos!")
                              .valido(valor);
                    },
                   ),
                  ),
                  Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: InputCustomizado(
                    onSaved: (descricao){
                          _anuncioProduto.setDescricao= descricao;
                    },
                    controller: _controllerDescricao,
                    textInputType: TextInputType.text,
                    maxLine: 100,
                    hintText: "Descrição",
                    inputFormatter: [
                       FilteringTextInputFormatter.digitsOnly,
                    ],
                    validador: (valor){
                       return Validador()
                              .add(Validar.OBRIGATORIO, msg: "Campo obrigatório!")
                              .maxLength(200, msg: "Descrição (200 caracteres)")
                              .valido(valor);
                    },
                   ),
                  ),
                //Configurnado Botoes
                BotaoCustomizado(
                  textoBotao: "Cadastrar anúncio",
                  onPressed: (){
                    /*
                    var erificao = true;
                    if(_formKey.currentState != null){
                        erificao = _formKey.currentState!.validate();
                      if(erificao){

                    }
                  }
                  */
                     if(_formKey.currentState.validate()){

                       //salva campos
                       _formKey.currentState.save();

                       //configurando o contextDialog
                       _dialogcontext  = context;

                       //salvar anuncios
                       _salvarAnuncios();
                       
                     }
                  }
                  )
              ],)
          ),
        ),
      ),
    );
  }
}