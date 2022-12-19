
import 'package:app_olx/models/usuario.dart';
import 'package:app_olx/route_generator.dart';
import 'package:app_olx/views/widgets/botao_customizado.dart';
import 'package:app_olx/views/widgets/input_customizado.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
class Login extends StatefulWidget {

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final TextEditingController _controllerEmail = TextEditingController(text: "ruben@gmail.com");
  final TextEditingController _controllerSenha = TextEditingController(text: "123456789");
  bool _valorSwitch = false;
  String _mensagemErro = "";
  String _textBotao = "Entrar";

  _validarCampos(){

    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    if(email.isNotEmpty && email.contains("@")){
      if(senha.isNotEmpty && email.length > 6){

        Usuario usuario = Usuario();
        usuario.setEmail = email;
        usuario.setSenha = senha;

        //Logar ou cadastrar usuario
        if(_valorSwitch == false){

           //Logar Usuario
           _logarUsuario(usuario);

        }
        else{

           //Cadastrar Usuario
           _cadastrarUsuario(usuario);

        }

      }
      else{
        setState(() {
          _mensagemErro = "Preencha a Senha válida, com mais 6 caracteres!";
       });

      }

    }
    else{
       setState(() {
          _mensagemErro = "Preencha o Email!";
       });
    }

  }

  _logarUsuario(Usuario usuario){
   FirebaseAuth auth = FirebaseAuth.instance;
   auth.signInWithEmailAndPassword(
    email: usuario.getEmail, 
    password: usuario.getSenha
  ).then((firebaseUser) {

    Navigator.pushReplacementNamed(context, RouteGenerator.ROUTE_ANUNCIOS);

  });

  }

  _cadastrarUsuario(Usuario usuario){
   FirebaseAuth auth = FirebaseAuth.instance;
   auth.createUserWithEmailAndPassword(
    email: usuario.getEmail, 
    password: usuario.getSenha
  ).then((firebaseUser) {

    Navigator.pushReplacementNamed(context, RouteGenerator.ROUTE_ANUNCIOS);

  });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
        backgroundColor: Color(0xff9c27b0),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 32),
                  child: Image.asset(
                    "imagem/logo.png",
                    width:200,
                    height:150
                  ),
                  ),
                  InputCustomizado(
                    controller: _controllerEmail, 
                    hintText: "Email",
                    textInputType: TextInputType.emailAddress,
                    autofocus: true,
                    ),
                  SizedBox(height: 5),
                  InputCustomizado(
                    controller: _controllerSenha, 
                    hintText: "Senha",
                    obscureText: true,
                    autofocus: true,
                    ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Logar"),
                    SizedBox(width: 3),
                    Switch(
                      activeColor: Color(0xff9c27b0),
                      value: _valorSwitch, 
                      onChanged: (bool valor){
                        setState(() {
                          _textBotao = "Entrar";
                          _valorSwitch = valor;
                          if(_valorSwitch){
                            _textBotao = "Cadastrar";
                          }
                          
                        });
                      }),
                    SizedBox(width: 3),
                    Text("Cadastrar")
                  ],
                ),
                SizedBox(height: 5),
                BotaoCustomizado(
                  textoBotao: _textBotao, 
                  onPressed:(){
                    _validarCampos();
                    }
                  ),
                 SizedBox(height: 10),
                 Text(_mensagemErro,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 17,
                    fontWeight: FontWeight.bold
                  ),
                 )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
