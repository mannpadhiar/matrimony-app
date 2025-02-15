import 'dart:async';

import 'package:flutter/material.dart';
import 'package:untitled/HomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/pages/login_page.dart';

class MainAnimationPage extends StatefulWidget {
  const MainAnimationPage({super.key});

  @override
  State<MainAnimationPage> createState() => _MainAnimationPageState();
}

class _MainAnimationPageState extends State<MainAnimationPage> with SingleTickerProviderStateMixin{

  late AnimationController _controller;
  late Animation<double> _scaleValue;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 4));
    _scaleValue = TweenSequence<double>(
      <TweenSequenceItem<double>>[
        TweenSequenceItem(
            tween: Tween<double>(begin: 1.0, end: 1.5)
                .chain(CurveTween(curve: Curves.fastEaseInToSlowEaseOut)),
            weight: 1),
        TweenSequenceItem(
            tween: Tween<double>(begin: 1.5, end: 1.0)
                .chain(CurveTween(curve: Curves.fastEaseInToSlowEaseOut)),
            weight: 1),
        TweenSequenceItem(
            tween: Tween<double>(begin: 1.0, end: 1.5)
                .chain(CurveTween(curve: Curves.fastEaseInToSlowEaseOut)),
            weight: 1),
        TweenSequenceItem(
            tween: Tween<double>(begin: 1.0, end: 160.0)
                .chain(CurveTween(curve: Curves.fastEaseInToSlowEaseOut)),
            weight: 1),
        TweenSequenceItem(tween: ConstantTween<double>(160.0), weight: .5),
      ],
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );

    Timer(Duration(seconds: 3),() async{
      if(await isLogIn()){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Homepage(),));
      }else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage(),));
      }
    },);
  }

  Future<bool> isLogIn() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLog =  prefs.getBool('isLogin') ?? false;
    return isLog;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller.repeat(reverse: true);
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'splashAnimation',
      child: Stack(
        children: [
          Container(
            color: const Color(0xff8e94f2),
            child: Center(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleValue.value,
                    child: Text('NOTRU',style: TextStyle(fontSize: 25,color: Colors.black,fontWeight: FontWeight.bold),),
                  );
                },
              ),
            ),
          ),

        ],
      ),
    );
  }


}
