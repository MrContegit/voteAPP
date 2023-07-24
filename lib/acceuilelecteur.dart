import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voteaplli/vote.dart';


class AcceuilElecteur extends StatefulWidget {
    const AcceuilElecteur({super.key, required this.code, required this.nom,required this.email});
  final String code;
  final String nom;
  final String email;

  @override
  State<AcceuilElecteur> createState() => _AcceuilElecteurState();
}

class _AcceuilElecteurState extends State<AcceuilElecteur> {
  late String cd;
  late int n = 0;
  List<dynamic> maListeCandidat=[];
  @override
  void initState() {
    codeutil();
    getcandidat();
    getElecteur();
    super.initState();
  }
  Future getElecteur()async{
    await FirebaseFirestore.instance.collection('Vote')
    .where('identifiant_EL',isEqualTo: cd).get().then((querySnapshot) {
      List<dynamic> maListe=[];
      querySnapshot.docs.forEach((doc) {
         maListe= doc.data()['ListeElecteurs'];
      });
      setState(() {
        n=maListe.length;
      });
    });   
  }
  
  Future getcandidat()async{
    await FirebaseFirestore.instance.collection('Vote')
    .where('identifiant_EL',isEqualTo:widget.code).get().then((querySnapshot) {
      List<dynamic> maListe=[];
      querySnapshot.docs.forEach((doc) {
         maListe= doc.data()['ListeCandidat'];
      });
      setState(() {
        for (var element in maListe) {
          maListeCandidat.add(element.toString());
        }
      });
    });

     
  }

  Future efectuerVote(String nom,String libelle)async{
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context)=>const Center(child: CircularProgressIndicator(),)
    );
    
    final document2 = await FirebaseFirestore.instance.collection('Vote');
    document2.where('identifiant_EL',isEqualTo: widget.code)
    .get().then((querySnapshot) {
      List<dynamic> maListe=[];
      querySnapshot.docs.forEach((doc) {
         maListe= doc.data()['ListeElecteurs'];
         if(maListe.contains(widget.nom)){
            Future.delayed(Duration(seconds: 2), () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text(
                  'Vous avez deja effectuer un vote.',
                  style: TextStyle(fontSize: 15,color: Colors.yellow),
                )
              ));
            });
         }else{
          maListe.add(widget.nom);
          document2.doc(doc.data()['Id_vote']).update({'ListeElecteurs':maListe});
          final document= FirebaseFirestore.instance.collection('Candidat');
          document.where('Nom',isEqualTo: nom).where('libelle_vote',isEqualTo:libelle )
          .get().then((querySnapshot) =>{
            querySnapshot.docs.forEach((doc) {
              document.doc(doc.data()['Id_cand']).update({'nb_voie':doc.data()['nb_voie']+1});
            }),    
          });
          Future.delayed(Duration(seconds: 2), () {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
                'Vote enregistrer avec success.',
                style: TextStyle(fontSize: 15,color: Colors.blue),
              )
            ));
          });
        }
      });
    });  
  }
  Query<Map<String, dynamic>> codeutil(){
    cd = widget.code;
    return FirebaseFirestore.instance.collection('Vote').where('identifiant_EL',isEqualTo: cd);
  }
  final TextEditingController rechercheController=TextEditingController();
  final TextEditingController deleteController=TextEditingController();


  
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 35,),
                IntrinsicHeight(
                  child: Stack(
                    children: [
                      const Align(
                        child: Text(
                          'LISTES DES VOTES',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          )
                        ),
                      ),
                      Positioned(
                        left: 0,
                        child:Ink(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            child: Center(
                              child: const Icon(Icons.arrow_back),
                            ),
                            onTap:(){
                              Navigator.push(context,
                                MaterialPageRoute(builder:(context)=> Vote(name: widget.nom,surname:widget.email)),);
                            },
                          ),
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(.1),
                                blurRadius: 2.0,
                                spreadRadius: .05,
                              )
                            ]
                          ),
                        )
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25,),             
                Expanded(
                  child: StreamBuilder(
                    stream: codeutil().snapshots(),
                    builder: (context,AsyncSnapshot<QuerySnapshot> streamSnapshot){
                      if(streamSnapshot.hasData){
                        return ListView.separated(
                          shrinkWrap: true,
                          itemCount: streamSnapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final DocumentSnapshot documentSnapshot =
                            streamSnapshot.data!.docs[index];
                            return GestureDetector(
                              onTap: (){},
                              child: Container(
                                decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                ),
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                  
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(documentSnapshot['libelle_vote'],
                                            style: TextStyle(
                                              fontStyle:FontStyle.italic ,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'serif',
                                            ),
                                          ),
                                         
                                          const SizedBox(height: 5,),
                                          // bar de progression
                                          LinearProgressIndicator(
                                            value: (n/documentSnapshot['nb_voiemax']),
                                           backgroundColor: Colors.black12,
                                          ),
                                          SizedBox(height: 30,),
                                          Text('                                Candidats',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 15,),
                                          Column(
                                            children: [
                                              ListView.separated(
                                                scrollDirection: Axis.vertical,
                                                shrinkWrap: true,
                                                padding: EdgeInsets.symmetric(horizontal: 25),
                                               // scrollDirection: Axis.horizontal,
                                                itemBuilder: (context, index)=>GestureDetector(
                                                  onTap: (){
                                                    efectuerVote(maListeCandidat[index],documentSnapshot['libelle_vote']);
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.symmetric(vertical: 10,horizontal: 15),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(15),
                                                      color: maListeCandidat.indexOf(maListeCandidat[index]) ==index ? Colors.blue : Colors.white,
                                                    ),
                                                    child:  Text(
                                                        maListeCandidat[index],
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold

                                                      ),
                                                    ),
                                                  ),
                                                ), 
                                                separatorBuilder: (_,index)=> SizedBox(height: 20,), 
                                                itemCount: maListeCandidat.length
                                              ),
                                            ],
                                          )
                                        ],
                                      )
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context,_){
                            return const SizedBox(height: 10,);
                          }, 
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  )         
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}