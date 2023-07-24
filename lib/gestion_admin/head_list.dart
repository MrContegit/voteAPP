
import 'package:flutter/material.dart';



class HeadList extends StatelessWidget {
  final int selected;
  final Function callback;
  const HeadList(this.selected,this.callback,{super.key});

  @override
  Widget build(BuildContext context) {
    final Category = ['creer vote','ajouter candidat','publier resultat'];
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 25),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index)=>GestureDetector(
          onTap: ()=>callback(index),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10,horizontal: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: selected ==index ? Colors.blue : Colors.white,
            ),
            child:  Text(
              Category[index],
              style: TextStyle(
                fontWeight: FontWeight.bold
              ),
            ),
          ),
        ), 
        separatorBuilder: (_,index)=> SizedBox(width: 20,), 
        itemCount: Category.length
      )
    );
  }
}