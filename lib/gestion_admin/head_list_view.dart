import 'package:flutter/cupertino.dart';
import 'package:voteaplli/creerVote.dart';
import 'package:voteaplli/publier_resultat.dart';

import '../ajouter_candidat.dart';


class HeadListView extends StatelessWidget {
  final int selected;
  final Function callback;
  final PageController pageController;
  final String name;
  final String surname;
  const HeadListView(this.selected, this.callback, this.pageController,{super.key, required this.name, required this.surname});

  void initState(){

  }
  @override
  Widget build(BuildContext context) {
    final category = ['creer vote','ajouter candidat','publier resultat'];
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: PageView(
        controller: pageController,
        onPageChanged: (index) =>callback(index) ,
        children:[
          CreerVote(),
          AjouterCandidat(),
          PublierResultat(name:name, surname: surname,),

        ]
          /*category.map((e) => ListView.separated(
            itemBuilder: (context, index) => FoodItem(
              restaurant.menu[category[selected]]![index]
            ), 
            itemCount: restaurant.menu[category[selected]]!.length, 
            separatorBuilder: (_, index)=>SizedBox(height: 15,),
          )).toList(),*/
      ),
    );
  }
}