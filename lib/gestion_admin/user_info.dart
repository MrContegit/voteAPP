import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:voteaplli/user.dart';

class UserInfo extends StatelessWidget {

  //late User user = User(Nom: 'Nom', Email: 'Email', mdp: 'mdp');
   UserInfo({super.key, required this.name, required this.surname});
   final String name;
   final String surname;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          surname,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        )
                      ),
                     /* SizedBox(width: 10,),
                      Text(
                        restaurant.distance,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.withOpacity(0.4),

                        ),
                      ),*/
                      /*SizedBox(width: 10,),
                      Text(
                        restaurant.label,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.withOpacity(0.4),
                          
                        ),
                      )*/
                    ],
                  ),
                  
                ],
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.asset('assets/images/gestion_vote.jpeg',width: 80,),
              )
            ],
          ),
          SizedBox(height: 5,),
          /*Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '"${restaurant.desc}"',
                style: TextStyle(
                  fontSize: 16, 
                ),
              ),
              Row(
                children: [
                  Icon(Icons.star_outline,
                    color: Color.fromARGB(255, 241, 111, 155)
                  ,),
                  Text(
                    '${restaurant.Score}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(width: 15,),
                ],
              ),
             
            ],
          )*/
        ],
      )
    );
  }
}