
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget{

  MyButton({required this.color,required this.title, required this.onPressed});
  final color;
  final String title;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext){

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),

      child: Material(
          elevation: 5,
          color: color,
          borderRadius: BorderRadius.circular(10),
          child: MaterialButton(
            onPressed: onPressed,
            minWidth: 200,
            height: 42,
            child:  Text(title ,
              style: TextStyle(color:Colors.white,fontSize: 16,fontWeight: FontWeight.bold ),
            ),
          )
      ),
    );

  }


}