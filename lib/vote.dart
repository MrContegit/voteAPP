import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voteaplli/acceuilelecteur.dart';
import 'package:voteaplli/category.dart';
import 'package:voteaplli/publierresult.dart';
import 'gestion_admin/candidater.dart';
import 'gestion_admin/home.dart';

class Vote extends StatefulWidget {
  Vote({this.name, this.surname,super.key});

  final String? name;
  final String? surname;

  @override
  _VoteState createState() => _VoteState();
}

class _VoteState extends State<Vote> {
    @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children:[
            SizedBox(height: 50,),
            AppEntete(name: widget.name,surname: widget.surname),
            Body(name: widget.name,surname: widget.surname,),
          ],
        ),
      ),
    ); 
  }
}

class Body extends StatefulWidget{
  const Body({this.name, this.surname,super.key});
  final String? name;
  final String? surname;
  

  @override
  State<Body> createState() => _BodyState();

}
class _BodyState extends State<Body>{
  final TextEditingController codevoteController = TextEditingController();
  final TextEditingController codecandController = TextEditingController();
  
    @override
  Widget build(BuildContext context){
    //Body page d acceuil de l administrateur
    return Column(
      children: [
        SizedBox(height: 20,),
        Padding(
          padding:  const EdgeInsets.only( top: 10, left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
              Text('CATEGORIE',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'serif',
                ),
              ),
              SizedBox(width: 10,),
              Icon(Icons.auto_stories,
              color: Colors.blueGrey,)
              
            ],
          ),
        ),
        Divider(
          height: 55,
          thickness: 3.5,
          color: Colors.blue.withOpacity(0.3),
          indent: 32,
          endIndent: 32,
        ),
        
        GridView.builder(
          shrinkWrap: true,
          itemCount: categoryList.length,
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 0,
          ),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
            crossAxisSpacing: 20,
            mainAxisSpacing: 24
            ), 
          itemBuilder: ((context, index) {
            return GestureDetector(
              onTap:(){
                if(categoryList[index].name=='Admin'){
                  Navigator.push(context,
                    MaterialPageRoute(builder:(context)=>  HomePage(name:widget.name!,surname: widget.surname!,))
                  ); 
                }else if(categoryList[index].name=='Candidater'){
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Code du Candidat',
                        style:TextStyle(
                          color:Colors.blue,
                        ) ),
                        content:TextFormField(
                              controller: codecandController,
                              decoration: InputDecoration(hintText: "Entrez le code du candidat"),
                            ),
                        actions: <Widget>[
                          TextButton(
                            child: Text('CANCEL'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          TextButton(
                            child: Text('valider'),
                            onPressed: () {
                              if(FirebaseFirestore.instance.collection('Vote').where(
                                'identifiant_CD',
                                isEqualTo: codecandController.text.trim()
                              ).count()!=0){
                                Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) => Candidater(code: codecandController.text.trim(),name:widget.name!,surname:widget.surname!)),
                                (Route<dynamic> route) => false);
                              }
                            },
                          ),
                        ],
                      );
                  });

                }else if(categoryList[index].name=="Resultats"){
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Code du vote',
                        style:TextStyle(
                          color:Colors.blue,
                        ) ),
                        content:TextFormField(
                              controller: codevoteController,
                              decoration: InputDecoration(hintText: "Entrez le code du vote"),
                            ),
                        actions: <Widget>[
                          TextButton(
                            child: Text('CANCEL'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          TextButton(
                            child: Text('valider'),
                            onPressed: () {
                              if(FirebaseFirestore.instance.collection('Vote').where(
                                'identifiant_CD',
                                isEqualTo: codevoteController.text.trim()
                              ).count()!=0){
                                Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) => PublierResult(
                                  code: codevoteController.text.trim(),statut: false,
                                  name:widget.name!,
                                  surname:widget.surname!,
                                  )),
                                (Route<dynamic> route) => false);
                              }
                            },
                          ),
                        ],
                      );
                  });
                }else if(categoryList[index].name=='Voter'){
                  
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Code du Vote',
                      style:TextStyle(
                        color:Colors.blue,
                      ) ),
                      content:TextFormField(
                            controller: codevoteController,
                            decoration: InputDecoration(hintText: "Entrez le code du vote"),
                          ),
                      actions: <Widget>[
                        TextButton(
                          child: Text('CANCEL'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        TextButton(
                          child: Text('valider'),
                          onPressed: () {
                            if(FirebaseFirestore.instance.collection('Vote').where(
                              'identifiant_CD',
                              isEqualTo: codevoteController.text.trim()
                            ).count()!=0){
                              Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => AcceuilElecteur(code: codevoteController.text.trim(), nom:widget.name??'',email:widget.surname??'')),
                              (Route<dynamic> route) => false);
                            }
                          },
                        ),
                      ],
                    );
                  });
                }
                
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.1),
                      blurRadius: 4.0,
                      spreadRadius: .05,
                    )
                  ]
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Image.asset(
                        categoryList[index].thumbnail,
                        height:150,
                      ),
                    ),
                    SizedBox(height: 5,),
                    Text(categoryList[index].name,
                    style:TextStyle(
                      color: Colors.black,
                      fontWeight:FontWeight.bold,
                      fontFamily: 'serif',
                      fontSize: 20,
                    ),
                    ),
                    
                    ],
                ),
              ),
            );
          })
        )
      ],
    );
  }
}

class AppEntete extends StatefulWidget {
  const AppEntete({this.name, this.surname,super.key});
  final String? name;
  final String? surname;

  @override
  State<AppEntete> createState() => _AppEnteteState();
}

class _AppEnteteState extends State<AppEntete> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 50,left: 20,right: 20),
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
        color: Colors.blue.withOpacity(0.7),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                  'Bienvenue  ',
                  style: TextStyle(color: Colors.black,
                    fontFamily:'serif',
                    fontSize: 20),), 
                    Column(
                      children: [
                        Text('${widget.name}',
                        style:TextStyle(
                          color: Colors.white,
                          fontFamily:'serif',
                          fontSize: 20),),
                        Text('${widget.surname}',
                        style:TextStyle(
                          color: Colors.white,
                          fontFamily:'serif',
                          fontSize: 20),
                        )
                        
                      ],
                    )
                    
                ],
              ),
              
          
          Container(
            height: 40,
            width: 40,
            decoration: const BoxDecoration(
            shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications,
            color: Colors.white,
            ),
          )
            ],
          ),
          const SizedBox(height: 20,),
        ],
      ),
    );
  }
}

