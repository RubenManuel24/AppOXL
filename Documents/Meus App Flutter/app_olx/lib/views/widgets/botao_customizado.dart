import 'package:flutter/material.dart';
class BotaoCustomizado extends StatelessWidget {
  
  final VoidCallback onPressed;
  final String textoBotao;
  final Color colorBotao;

  BotaoCustomizado({
    @required this.textoBotao,
    @required this.onPressed,
    this.colorBotao = Colors.white
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: this.onPressed,
        child:Text(
         this.textoBotao,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: this.colorBotao
          ),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
            Color(0xff9c27b0)
          ),
          padding: MaterialStateProperty.all<EdgeInsets>(
            EdgeInsets.fromLTRB(32, 16, 32, 16)
          ),
          shape:  MaterialStateProperty.all<RoundedRectangleBorder>(
             RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)
             )
          ),
          ),
    );
  }
}