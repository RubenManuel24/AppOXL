import 'package:app_olx/models/anuncios.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
class DetalheAnuncio extends StatefulWidget {
  final AnuncioProduto anuncioProduto;
  
   DetalheAnuncio(this.anuncioProduto, {Key key}) : super(key: key);

  @override
  State<DetalheAnuncio> createState() => _DetalheAnuncioState();
}

class _DetalheAnuncioState extends State<DetalheAnuncio> {
AnuncioProduto _anuncioProdutoDetalhe;

 List<Widget> _getDeListaImagens(){
  //if(widget._anuncioProduto != null && widget._anuncioProduto.getFoto.toString().isNotEmpty){
    List listaImagens = _anuncioProdutoDetalhe.getFoto;
   return listaImagens.map((url){
     return Container(
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        image: DecorationImage(
          image: NetworkImage(url),
          fit: BoxFit.fitWidth
          )
      ),
    );
  }).toList();
 //}
}

Future _ligarVendedor(String telefone) async {
  if(await canLaunchUrl(Uri( scheme: "tel" , path: telefone, ))) {
      await launchUrl(Uri( scheme: "tel" , path: telefone,));
  }
}

@override
  void initState() {
    super.initState();
    _anuncioProdutoDetalhe = widget.anuncioProduto;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff9c27b0),
        title: Text("Anúncios"),
      ),
      body: Stack(
        children: <Widget>[
          ListView(
            children: [
              //Imagem Carosel
           SizedBox(
               child: CarouselSlider(
               items: _getDeListaImagens(),
               options:CarouselOptions(
                enableInfiniteScroll: false,
                enlargeCenterPage: false,
                enlargeFactor: 0.3,
                reverse :false,
                animateToClosest : false,
                //height: double.
               ) ,
              ),
             ),

          Container(
           
           padding: EdgeInsets.all(16),
           child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
           children: [
            //preco
            Text("KZ ${_anuncioProdutoDetalhe.getPreco}",
             style: TextStyle(
              color: Color(0xff9c27b0),
              fontSize: 22,
              fontWeight: FontWeight.w400
             )
            ),
            //Titulo
            Text("${_anuncioProdutoDetalhe.getTitulo}",
               style: TextStyle(
               fontSize: 25,
             )
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 15),
            child: Divider(),
            ),
            //Descriacao
            Text("Descrição",
            style: TextStyle(
             fontWeight: FontWeight.bold
            ),
            ),
            Text("${_anuncioProdutoDetalhe.getDescriacao}"),
            Padding(padding: EdgeInsets.symmetric(vertical: 15),
            child: Divider(),
            ),
            //Contato
            Text("Contato",
            style: TextStyle(
             fontWeight: FontWeight.bold
            ),
            ),
            Text("${_anuncioProdutoDetalhe.getTelefone}"),
          ],
          )
        ),
            ]
          ),
          
        //Botao
        Positioned(
          bottom: 16,
          right: 16,
          left: 16,
          child: TextButton(
            onPressed: (){
              _ligarVendedor(_anuncioProdutoDetalhe.getTelefone);
            }, 
            child: Text("Ligar",
            style: TextStyle(
              color:Colors.white
            )
            ),
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsets>(
                EdgeInsets.fromLTRB(32, 16, 32, 16)
              ),
              backgroundColor: MaterialStateProperty.all<Color>(
                Color(0xff9c27b0)
              ),
              shape:  MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
                )
              )
            ),
            ),
         )
     ],
    ),
   );
 }
}
