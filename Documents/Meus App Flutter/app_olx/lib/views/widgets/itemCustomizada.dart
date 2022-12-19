import 'package:app_olx/models/anuncios.dart';
import 'package:flutter/material.dart';
class ItemCustomizada extends StatelessWidget {

  AnuncioProduto anuncioProduto;
  VoidCallback itemOnTap;
  VoidCallback onPressedRemove;

  ItemCustomizada({
    @required this.anuncioProduto,
    this.itemOnTap,
    this.onPressedRemove
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.itemOnTap,
      child: Card(
        child: Padding(padding: EdgeInsets.all(12),
        child: Row(
          children: [
            //As imagens
            SizedBox( 
              width: 120,
              height: 120,
              child:  Image.network(anuncioProduto.getFoto[0],
                fit: BoxFit.cover,
              )
            ),
            //Nome e preco
             Expanded(
               flex: 3,
               child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                      Text(
                            anuncioProduto.getTitulo,
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          ),
                          textAlign: TextAlign.start
                      ),
                      Text("Kz ${anuncioProduto.getPreco}",
                       style: TextStyle(
                            fontSize: 14
                          ),
                      ), 
                  ],
                ),
                )
            ),
            //Icon de Delete
            if(this.onPressedRemove != null)
            Expanded(
              flex: 1,
              child: TextButton(
                onPressed: this.onPressedRemove,
                 child: Icon(Icons.delete, color: Colors.white,),
                 style: TextButton.styleFrom(backgroundColor: Colors.red),
             )
            )
          ]),
      ),
      )
    );
  }
}
