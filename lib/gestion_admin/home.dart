import 'package:flutter/material.dart';
import 'package:voteaplli/gestion_admin/user_info.dart';
import 'package:voteaplli/vote.dart';

import 'custom_app_bar.dart';
import 'head_list.dart';
import 'head_list_view.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.name, required this.surname});
    final String name;
  final String surname;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var selected = 0;
  final pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.blue,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_outlined),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => Vote(name: widget.name,surname: widget.surname,)),
                    (Route<dynamic> route) => false);
              }),
          actions: [
            IconButton(
              icon: Icon(Icons.search_outlined),
              onPressed: () {
                //voir les resultats des votes
              },
            )
          ],
        ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //SizedBox(height: 30,),
          /*CustomAppBar(
            rightIcon:Icons.search_outlined,
             leftIcon: Icons.arrow_back_ios_outlined,
          ),*/
          UserInfo(name: widget.name,surname: widget.surname,),
          SizedBox(height: 10,),
          HeadList(
            selected, 
            (int index){
              setState(() {
                selected = index;
              });
              pageController.jumpToPage(index);
            }, 
          ),
          SizedBox(height: 20,),
          Expanded(
            child: HeadListView(
              selected,
              (int index){
                setState(() {
                  selected = index;
                });
              },
              pageController, name: widget.name, surname: widget.surname,
            )
          )
        ],
      ),
    );
  }
}