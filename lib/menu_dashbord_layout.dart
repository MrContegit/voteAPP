import 'package:flutter/material.dart';

final Color backgroundcolor = Color(0XFF4A4A58);
class MenuDashbordPage extends StatefulWidget{
  const MenuDashbordPage({super.key});

  @override
  State<MenuDashbordPage> createState() => _MenuDashbordPageState();
}

class _MenuDashbordPageState extends State<MenuDashbordPage> with SingleTickerProviderStateMixin {
  bool isCollapsed = true;
  late double screenWidth,screenHeight;
  final Duration duration = const Duration(milliseconds: 300);
  late AnimationController _controller;
  late Animation<double>_scaleAnimation;


  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this,duration: duration);
    _scaleAnimation = Tween<double>(begin:1,end: 0.6).animate(_controller);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenWidth = size.width;
    screenHeight = size.height;
    return Scaffold(
      backgroundColor: backgroundcolor,
      body: Stack(
        children: <Widget>[
          dashbord(context)
        ],
      ),
    );
  }

  Widget dashbord(context){
    return AnimatedPositioned(
      top: isCollapsed ?0 : 0.2*screenHeight,
      bottom:isCollapsed ?0 : 0.2*screenWidth,
      left:isCollapsed ?0 : 0.6*screenHeight,
      right:isCollapsed ?0 : -0.4*screenWidth,
      duration:duration,
      child: Material(
        animationDuration: duration,
        borderRadius: BorderRadius.all(Radius.circular(40)),
        elevation: 8,
        color: backgroundcolor,
        child: Container(
          padding: const EdgeInsets.only(left: 16,right: 16,top: 48),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  InkWell(
                    
                    child: Icon(Icons.menu,color: Colors.white,)
                  ),
                  Text("My cards", style: TextStyle(fontSize: 24,color: Colors.white),),
                  Icon(Icons.settings,color: Colors.white,),
                ],
              ),
              SizedBox(height: 50,),
              Container(
                height: 600,
                child: PageView(
                  controller: PageController(viewportFraction: 0.8),
                  scrollDirection: Axis.horizontal,
                  pageSnapping: true,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      color: Colors.white,
                      width: 100,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      color: Colors.white,
                      width: 100,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      color: Colors.white,
                      width: 100,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}