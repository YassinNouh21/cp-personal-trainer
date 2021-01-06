import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mini_pocket_personal_trainer/animation/logo_animation.dart';
import 'package:mini_pocket_personal_trainer/models/user_model.dart';
import 'package:mini_pocket_personal_trainer/painter/custom_hole_painter.dart';
import 'package:mini_pocket_personal_trainer/screens/home_screen.dart';
import 'package:mini_pocket_personal_trainer/screens/how_to_use_screen.dart';
import 'package:mini_pocket_personal_trainer/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  LogoAnimation _logo;

  int isFirstInit =0;

  Future<int> checkIfIsTheFirstInit() async{
    final prefs = await SharedPreferences.getInstance();
    final launcherCount = prefs.getInt('counter') ?? 0;
    prefs.setInt('counter', launcherCount+1);
    return launcherCount;
  }

  void hasAutoLogged(){
    UserModel.of(context).autoLogin()
      .then((value) => value ? Navigator.of(context)
        .pushReplacement(
          MaterialPageRoute(builder: (context)=> HomeScreen())
        ) :
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context)=> LoginScreen()))
    );
  }

  @override
  void initState() {

    checkIfIsTheFirstInit().then((value) => isFirstInit = value);

    _controller = AnimationController(
       duration: const Duration(milliseconds: 3000),
       vsync: this);
    _logo = LogoAnimation(_controller);

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        isFirstInit > 0 ? hasAutoLogged() : Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HowToUseScreen())
        );
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return  Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.white,
                child: CustomPaint(
                  painter: HolePainter(
                      color: Theme
                          .of(context)
                          .primaryColor,
                      holeSize: _logo.holeSize.value * MediaQuery.of(context).size.width
                  ),
                ),
              ),
              Positioned(
                top: _logo.dropPosition.value * MediaQuery.of(context).size.height,
                left: MediaQuery.of(context).size.width / 2 - _logo.logoSize.value / 2,
                child: Visibility(
                  child: Image.asset("assets/images/logo.png",
                    height: _logo.logoSize.value,
                    width: _logo.logoSize.value,
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.high,
                  ),
                  visible: _logo.logoVisible.value,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 32),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Opacity(
                    opacity: _logo.textOpacity.value,
                    child: Text("Pocket Personal Trainer",
                      style: TextStyle(fontSize: 22,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          decoration: TextDecoration.underline
                      ),
                    ),
                  ),
                ),

              ),
            ],
          );
      },
    );
  }
}