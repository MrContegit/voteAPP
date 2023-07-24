import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:voteaplli/vote.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
 bool _passwordVisible = false;
  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();
  TextEditingController nomEditingController = new TextEditingController();
  TextEditingController numeroTelController = new TextEditingController();

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
  Future createUsers({required String name,required String email,required String password,required String numTel}) async {
    final docUser=FirebaseFirestore.instance.collection('Usager_votant').doc();
    final json={
      'Id_user':docUser.id,
      'Nom':name,
      'Email':email,
      'mdp':password,
      'numTel':numTel
    };
    await docUser.set(json);
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
              idNomField2(nomEditingController,'nom',Icons.person),
              idNomField2(numeroTelController,'numeroTel',Icons.phone),
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
            'Vous avez deja un compte?',
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
              ' se connecter',
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

  Widget title() {
    return Container(
        padding: EdgeInsets.all(20),
        child: Text(
          "Inscription",
          style: TextStyle(
            color: Colors.blue,
            fontFamily: 'serif',
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
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
              border: OutlineInputBorder(),
              labelText: "Email",
              prefixIcon: Icon(Icons.person,color: Colors.blue,)),
        ));
  }
  Widget idNomField2(TextEditingController controller,String labe,IconData iconne) {
    return Container(
        padding: EdgeInsets.all(15),
        child: TextFormField(
          controller:controller,
          maxLines: 1,
          validator: (value) {
            if (value!.isEmpty) {
              return "veuillez remplir cette ligne";
            }
            return null;
          },
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: labe,
              prefixIcon: Icon(iconne,color: Colors.blue,)),
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
          "s\'inscrire",
          style: TextStyle(fontSize: 20, color: Colors.black,fontFamily: 'serif',fontWeight: FontWeight.bold),
        ),
        onPressed:(){
                  createUsers(
                    name:nomEditingController.text.trim(),
                    email:emailEditingController.text.trim(),
                    password:passwordEditingController.text.trim(),
                    numTel: numeroTelController.text.trim()
                  );
                  FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: emailEditingController.text.trim(),
                    password: passwordEditingController.text.trim()
                    ).then((value){
                      Navigator.push(context,MaterialPageRoute(
                        builder:(context)=>Vote(
            name: nomEditingController.text.trim(),
            surname: emailEditingController.text.trim(), 
          )));
                    }).onError((error, stackTrace){
                      print("Error ${error.toString()}");
                    });
                }
        ),
    );
  }
}