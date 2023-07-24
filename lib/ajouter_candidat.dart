import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'inputfield.dart';

class AjouterCandidat extends StatefulWidget {
  const AjouterCandidat({super.key});

  @override
  State<AjouterCandidat> createState() => _AjouterCandidatState();
}

class _AjouterCandidatState extends State<AjouterCandidat> {
  File? Imagefile;
  late String libelle = 'Libelle';
  final TextEditingController NomController = TextEditingController();
  final TextEditingController EmailController = TextEditingController();
    final listvote = FirebaseFirestore.instance.collection("Vote");
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
      'Nom':NomController.text.trim(),
      'Email':EmailController.text.trim(),
      'image':Imagefile.toString(),
      'libelle_vote':libelle,
      'nb_voie':0,
      
    };
    await docvote.set(json);
    final document2 = await FirebaseFirestore.instance.collection('Vote');
    document2.where('libelle_vote',isEqualTo: libelle)
    .get().then((querySnapshot) {
      List<dynamic> maListe=[];
      querySnapshot.docs.forEach((doc) {
         maListe= doc.data()['ListeCandidat'];
         if(maListe.contains(NomController.text.trim())){
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
          maListe.add(NomController.text.trim());
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
                        items: ListeSalle(),
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
              hintText: 'nom',
              inputController: NomController,
              labelText: 'nom du candidat',
              primaryColor: Colors.blue,
              type: TextInputType.name,
            ),
            const SizedBox(height: 25.0),

            //Email
            CustomInputFieldFb1(
              hintText: 'Email',
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
