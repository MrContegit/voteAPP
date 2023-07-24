import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:voteaplli/gestion_admin/home.dart';
import 'package:voteaplli/publier_resultat.dart';
import 'package:voteaplli/vote.dart';
class PublierResult extends StatefulWidget {
  const PublierResult({super.key, required this.code, required this.statut, required this.name, required this.surname});
  final String code;
  final bool statut;
  final String name;
  final String surname;

  @override
  State<PublierResult> createState() => _PublierResultState();
}

class _PublierResultState extends State<PublierResult> {
 final TextEditingController libelleController = TextEditingController();
  List<String> maListeCandidat=[];
  List<VoteData> votedat=[
  ];
  @override
  void initState() {
    getcandidat();
    super.initState();
  }
  Future getcandidat()async{
    FirebaseFirestore.instance.collection('Candidat')
    .where('libelle_vote',isEqualTo:widget.code).get().then((value){
      value.docs.forEach((element) {
        votedat.add(VoteData(element.data()['Nom'], element.data()['nb_voie']));
        print('***********************${votedat.length}*******************');
      });
      setState(() {
        votedat;
      });
    });
  }
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('${widget.code}'),
          centerTitle: true,
          backgroundColor: Colors.blue,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new),
              onPressed: () {
                if(widget.statut==true){
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => HomePage(name: widget.name,surname: widget.surname,)),
                    (Route<dynamic> route) => false);
                }else{
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => Vote(name: widget.name,surname: widget.surname,)),
                    (Route<dynamic> route) => false);
                }
              }),
        ),
      body: Container(
            child: createChart(context),
          ),
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
        data: votedat, 
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