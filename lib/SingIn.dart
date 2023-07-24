import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:voteaplli/vote.dart';

import 'SignUp.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  late Map<String,String> user_info={
    'Nom':'',
    'Email':''
  };
  bool _passwordVisible = false;
  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();
  

  Future<void> recupInfo()async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context)=>const Center(child: CircularProgressIndicator(),)
    );
    
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailEditingController.text.trim(),
        password:passwordEditingController.text.trim(),
      ).then((value)async{
        final user= await FirebaseFirestore.instance.collection('Usager_votant')
        .where('Email',isEqualTo:emailEditingController.text.trim())
        .where('mdp',isEqualTo:passwordEditingController.text.trim()).get().then((snapschot){
          snapschot.docs.forEach((element) { 
            user_info['Nom']=element.data()['Nom'];
            user_info['Email']=emailEditingController.text.trim();
            //print('************************************00${user_info}');
          });
          //print('************************************00${user_info}');
          setState(() {
            user_info;
          });
        });
        print('************************************00${user_info}');
        Navigator.push(context,
          MaterialPageRoute( builder:(context)=>Vote(
            name: user_info['Nom'],
            surname: user_info['Email'], 
          )
        )).onError((error, stackTrace){
            print("Error ${error.toString()}");
        }); 
      });
    } on FirebaseAuthException catch(e){
      print(e);
    };
  }

  @override
  void initState() {
    _passwordVisible = false;
    super.initState();
  }

  @override
  void dispose() {
    emailEditingController.dispose();
    passwordEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body:Container(
        padding: EdgeInsets.only(left: 15, right: 15, top: 50),
        margin: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              title(),
              photo(),
              SizedBox(height: 10,),
              idNomField(),
              passwordField(),
              loginButton(),
            ],
          ),
        ),
      ),
      bottomNavigationBar:  Container(
      height: 50,
      color: Colors.black,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children : [
          const Text(
            'Vous n\'avez pas de compte?',
            style: TextStyle(
                color: Colors.white,
              ),
          ),
          GestureDetector(
            onTap:(){
             Navigator.push(context,
              MaterialPageRoute(builder:(context)=>const SignUp())); 
            },
            //InkWell(
            child: Text(
              ' Inscription',
              style: TextStyle(
                color: Colors.blue,
              ),
            ),
          ),
          //),

        ],

      ),
    ),
    );
  }
  Widget title() {
    return Container(
        padding: EdgeInsets.all(20),
        child: Text(
          "Connexion",
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontFamily: 'serif',
            fontSize: 30,
          ),
        ));
  }
  Widget photo() {
    return Container(
        padding: EdgeInsets.fromLTRB(0,0,0,0),
        decoration:BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.7),
              blurRadius: 7,
            )
          ]
        ),
        child: Image.asset(
          'assets/logo.png',
          width: 300,
          height: 300,
        ));
        
  }

  Widget idNomField() {
    return Container(
        padding: EdgeInsets.all(15),
        child: TextFormField(
          controller:emailEditingController,
          maxLines: 1,
          validator: (value) {
            if (value!.isEmpty) {
              return "Please enter email";
            }
            return null;
          },
          decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.blue
                )
              ),
              labelText: "Email",
              prefixIcon: Icon(Icons.person,color: Colors.blue,)),
        ));
  }

  Widget passwordField() {
    return Container(
        padding: EdgeInsets.all(15),
        child: TextFormField(
          controller: passwordEditingController,
          maxLines: 1,
          obscureText: !_passwordVisible,
          validator: (value) {
            if (value!.isEmpty) {
              return "Please enter  your password";
            }
            return null;
          },
          decoration: InputDecoration(
              suffixIcon: IconButton(
                  icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  }),
              border: OutlineInputBorder(),
              labelText: "Password",
              prefixIcon: Icon(Icons.lock,color: Colors.blue,)),
        ));
  }

  Widget loginButton() {
    return Container(
      padding: EdgeInsets.all(10),
      child: MaterialButton(
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10)),
        elevation: 8,
        color: Colors.blue,
        child: Text(
          "Login",
          style: TextStyle(fontSize: 20, color: Colors.black,fontFamily: 'serif',fontWeight: FontWeight.bold),
        ),
        onPressed:() async{
          recupInfo();
          
        }
        ),
    );
  }
}