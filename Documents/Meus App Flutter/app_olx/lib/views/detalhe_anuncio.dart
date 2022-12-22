import 'package:app_olx/models/anuncios.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
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
             )
          
        ],
      ),
    );
  }
}
