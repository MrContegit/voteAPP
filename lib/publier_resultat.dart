import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:voteaplli/publierresult.dart';
class PublierResultat extends StatefulWidget {
  PublierResultat({super.key, required this.name, required this.surname});

  final String name;
  final String surname;
  @override
  State<PublierResultat> createState() => _PublierResultatState();
}

class _PublierResultatState extends State<PublierResultat> {
  final TextEditingController libelleController = TextEditingController();
  List<String> maListeCandidat=[];

 @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            child: createChart(context),
          ),
        ),
        SizedBox(height: 20,),
       ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
              return AlertDialog(
                title: Text('libelle Vote',
                style:TextStyle(
                  color:Colors.blue,
                ) ),
                content:TextFormField(
                      controller: libelleController,
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
                      Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => PublierResult(code: libelleController.text.trim(),statut: true,name: widget.name,surname: widget.surname,)),
                      (Route<dynamic> route) => false);
                      
                    },
                  ),
                ],
              );
              });
            
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
              'Publier',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        ),
        SizedBox(height: 50,),
      ],
    );
  }
  Widget createChart(BuildContext context){
    return charts.BarChart(
      retrieveVoteResult(context),
      animate: true ,
    );
  }
  List<charts.Series<VoteData, String>> retrieveVoteResult(BuildContext context){

    List<VoteData> data = [
      VoteData('option1', 2),
      VoteData('option2', 7),
      VoteData('option3', 10),
      VoteData('option4', 22),
    ]; 
    return [
      charts.Series<VoteData, String>(
        id: 'id', 
        data: data, 
        domainFn:  (VoteData vote, _) => vote.option, 
        measureFn:(VoteData vote, _) => vote.total,
        colorFn:(_, pos){
          if(pos! % 2 ==0){
          return charts.MaterialPalette.green.shadeDefault;
        }
        return charts.MaterialPalette.blue.shadeDefault;
       }, 
      )
    ];
  }
}
class VoteData {
  final String option;
  final int total;

  VoteData(this.option, this.total);
}