import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:voteaplli/vote.dart';

import '../inputfield.dart';

class Candidater extends StatefulWidget {
  const Candidater({super.key, required this.code, required this.name, required this.surname,});
  final String code;
  final String name;
  final String surname;
  @override
  State<Candidater> createState() => _CandidaterState();
}

class _CandidaterState extends State<Candidater> {
  // ignore: non_constant_identifier_names
  File? Imagefile;
  late String libelle = 'Libelle';
  // ignore: non_constant_identifier_names
  final TextEditingController NomController = TextEditingController();
  // ignore: non_constant_identifier_names
  final TextEditingController EmailController = TextEditingController();
  // ignore: non_constant_identifier_names
  List<String> ListeSal=[];
    late String imgUrl='';

  @override
  void initState(){
    final listvote = FirebaseFirestore.instance.collection("Vote").where('identifiant_CD',isEqualTo: widget.code);
    List<String> ListeSalle(){
    List<String> list=[]; 
    listvote.get().then(
      (querySnapshot) {
        print("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          list.add(docSnapshot.data()['libelle_vote']) ;
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
    return list;
  }
  ListeSal = ListeSalle();
  }
  
  void getImage({required ImageSource source})async{
    final file = await ImagePicker().pickImage(source: source);
    if(file?.path != null){
      setState(() {
        Imagefile = File(file!.path);
        
      });
    }
  }


  Future creerCandidat() async{
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context)=>const Center(child: CircularProgressIndicator(),)
    );
    final docvote=FirebaseFirestore.instance.collection('Candidat').doc();
    final json={
      'Id_cand':docvote.id,
      'Nom':widget.name,
      'Email':widget.surname,
      'libelle_vote':libelle,
      'nb_voie':0
      
    };
    await docvote.set(json);
    final imaDoc = await FirebaseStorage.instance.ref('${json['Id_cand']}.jpg');
    await imaDoc.putFile(Imagefile!);
    imgUrl = await imaDoc.getDownloadURL();
     
    setState(() {
      imgUrl;
    });
  
    final document2 = await FirebaseFirestore.instance.collection('Vote');
    document2.where('libelle_vote',isEqualTo: libelle)
    .get().then((querySnapshot) {
      List<dynamic> maListe=[];
      querySnapshot.docs.forEach((doc) {
         maListe= doc.data()['ListeCandidat'];
         if(maListe.contains(widget.name)){
            Future.delayed(Duration(seconds: 2), () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text(
                  'Candidat deja enregistrer.',
                  style: TextStyle(fontSize: 15,color: Colors.yellow),
                )
              ));
            });
         }else{
          maListe.add(widget.name);
          document2.doc(doc.data()['Id_vote']).update({'ListeCandidat':maListe});
          Future.delayed(Duration(seconds: 2), () {
        Navigator.of(context).pop();
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'candidat enregistrer.',
          style: TextStyle(fontSize: 15,color: Colors.blue),
        )
      ));
          
        }
      });
    }); 
    
    
  }


  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Colors.blue,
        title:Text('Candidater'),
        leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_outlined),
              onPressed: () {
              Navigator.push(context,
                MaterialPageRoute(builder:(context)=>Vote(name: widget.name,surname: widget.surname,)));
              }),
        
      ),
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
            if(Imagefile!=null && imgUrl!='')
                Container(
                  width: 200,
                  height: 200,
                  margin: EdgeInsets.fromLTRB(90, 20, 20, 20),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 10,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.white,
                    image: DecorationImage(
                      image:FileImage(Imagefile!),
                      fit: BoxFit.cover
                    )
                  ),
                )
              else
                Container(
                  padding: EdgeInsets.fromLTRB(80,0,20,0),
                  child:Icon(
                        Icons.image,
                        size: 200,
                        color: Colors.blue.withOpacity(0.7),
                  ),
                ),
            //Choix du libelle
            Container(
              decoration:BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 7,
                  )
                ]
                    ),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(20,0,0,0),
                      child: DropdownSearch<String>(
                        popupProps: PopupProps.menu(
                          showSelectedItems: true,
                          disabledItemFn: (String s) => s.startsWith('I'),
                        ),
                        items: ListeSal,
                        dropdownDecoratorProps: const DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            hintText: "country in menu mode",
                          ),
                        ),
                        onChanged: (value) =>setState((){
                            libelle = value.toString();
                        }),
                        selectedItem: libelle,
                      ),
                    )
                  ),
            const SizedBox(height: 25),


            //nom
            CustomInputFieldFb1(
              enable: false,
              hintText: widget.name,
              inputController: NomController,
              labelText: 'nom',
              primaryColor: Colors.blue,
              type: TextInputType.name,
            ),
            const SizedBox(height: 25.0),

            //Email
            CustomInputFieldFb1(
              enable: false,
              hintText: widget.surname,
              inputController: EmailController,
              labelText: 'Email',
              primaryColor: Colors.blue,
              type: TextInputType.emailAddress,
            ),
            const SizedBox(height: 25),

            //photo
            ElevatedButton(
                    onPressed:()=>getImage(source: ImageSource.gallery) ,
                    child: Container(
                      alignment:Alignment.center,
                      height:49,
                      width: 330,
                      decoration: BoxDecoration(
                        color:Colors.blue,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color:Colors.blue.withOpacity(0.3),
                            blurRadius: 10,
                          )
                        ]
                      ),
                      child:Row(
                        children: [
                          Text(
                            'Image',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              
                            ),
                          ),
                          IconButton(
                            onPressed:(){}, 
                            icon: const Icon(Icons.image))
                        ],
                      ),
                    )
                  ),
            
            const SizedBox(height: 45),

            ///Button
            Container(
              child: ElevatedButton(
                  onPressed: () {
                    creerCandidat();
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
                      'Ajouter',
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
