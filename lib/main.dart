import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:voteaplli/vote.dart';
import 'SignUp.dart';
import 'SingIn.dart';



void main()async { 
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( MyApp());   
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:SignIn(),//Vote(name: 'name', surname: 'surname'),
      debugShowCheckedModeBanner: false, 
    );
  }
}
