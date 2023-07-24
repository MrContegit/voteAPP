import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'inputfield.dart';

class CreerVote extends StatefulWidget {
  const CreerVote({super.key});
  @override
  State<CreerVote> createState() => _CreerVoteState();
}

class _CreerVoteState extends State<CreerVote> {
  final TextEditingController identifiantELController = TextEditingController();
  final TextEditingController libelleController = TextEditingController();
  final TextEditingController nbreCanController = TextEditingController();
  final TextEditingController nbreElectController = TextEditingController();
  final TextEditingController dureController = TextEditingController();
  final TextEditingController identifiantCDController = TextEditingController();

  
  // ignore: non_constant_identifier_names
  final List<String> ListeCandidat=[
   // 'gerald','conte'
  ];
  // ignore: non_constant_identifier_names
  final List<String> ListeElecteurs=[];
      List<String> list=[];

  // ignore: non_constant_identifier_names
  List<String> ListesCandidats(String libelle){
    List<String> liste=[];
      FirebaseFirestore.instance.collection("Candidat").where('libelle_vote',isEqualTo:libelle).get().then(
        (querySnapshot) {
          for (var docSnapshot in querySnapshot.docs) {
            liste.add(docSnapshot.data()['Nom']) ;
          }
        },
      );
      return liste;
    }
  Future creervote() async{
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context)=>const Center(child: CircularProgressIndicator(),)
    );
    final docvote=FirebaseFirestore.instance.collection('Vote').doc();
    final json={
      'Id_vote':docvote.id,
      'ListeCandidat':ListeCandidat,
      'ListeElecteurs':ListeElecteurs,
      'duree_vote':int.parse(dureController.text),
      'identifiant_EL':identifiantELController.text.trim(),
      'libelle_vote':libelleController.text.trim(),
      'identifiant_CD':identifiantCDController.text.trim(),
      'nb_voiemax':int.parse(nbreElectController.text),
    };
    Future.delayed(Duration(seconds: 2), () {
        Navigator.of(context).pop();
      });
      await docvote.set(json);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'Vote enregistrer.',
          style: TextStyle(fontSize: 15,color: Colors.blue),
        )
      ));
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        body: SingleChildScrollView(
      child: SafeArea(
          child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),

            //libelle
            CustomInputFieldFb1(
              hintText: 'libelle',
              inputController: libelleController,
              labelText: 'libelle du vote',
              primaryColor: Colors.blue,
              type: TextInputType.name,
            ),
            const SizedBox(height: 10),

            //nombre de candidat
            CustomInputFieldFb1(
              hintText: 'nombre de candidats',
              inputController: nbreCanController,
              labelText: '',
              primaryColor: Colors.blue,
              type: TextInputType.number,
            ),
            const SizedBox(height: 10),

            //nombre d'electeur
            CustomInputFieldFb1(
              hintText: 'nombre d\'electeurs',
              inputController: nbreElectController,
              labelText: '',
              primaryColor: Colors.blue,
              type: TextInputType.number,
            ),
            const SizedBox(height: 10),


            //identifiant electeur
            CustomInputFieldFb1(
              hintText: 'Identifiant du candidat',
              inputController: identifiantCDController,
              labelText: '',
              primaryColor: Colors.blue,
              type: TextInputType.name,
            ),
            const SizedBox(height: 10),


            //identifiant candidat
            CustomInputFieldFb1(
              hintText: 'Identifiant d\'electeurs',
              inputController: identifiantELController,
              labelText: '',
              primaryColor: Colors.blue,
              type: TextInputType.name,
            ),
            const SizedBox(height: 10),


            //dure
            CustomInputFieldFb1(
              hintText: 'dure du vote',
              inputController: dureController,
              labelText: '',
              primaryColor: Colors.blue,
              type: TextInputType.number,
            ),

            const SizedBox(height: 30),

            ///Button
            Container(
              
              child: ElevatedButton(
                  onPressed: () {
                    creervote();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    width: 300,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.3),
                            blurRadius: 10,
                          )
                        ]),
                    child: const Text(
                      'Confirmer',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )),
            ),
          ],
        ),
      )),
    ));
  }
}
