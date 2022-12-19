import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:validadores/Validador.dart';
class InputCustomizado extends StatelessWidget {
  
 final TextEditingController controller;
 final String hintText;
 final TextInputType textInputType;
 final List<TextInputFormatter> inputFormatter;
 final bool autofocus;
 final bool obscureText;
 final int maxLine;
 final Function(String) validador;
 final Function(String) onSaved;

  InputCustomizado({
    @required this.controller,
    @required this.hintText,
    this.textInputType = TextInputType.text,
    this.inputFormatter,
    this.autofocus = false,
    this.obscureText = false,
    this.maxLine = 1, 
    this.validador,
    this.onSaved
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
         // controller: this.controller,
          keyboardType: this.textInputType,
          autofocus: this.autofocus,
          validator: this.validador,
          obscureText: this.obscureText,
          onSaved: this.onSaved,
            decoration: InputDecoration(
              hintText: this.hintText,
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20)
              )
        ),
    );
  }
}