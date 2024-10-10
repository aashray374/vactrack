import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vactrack/src/provider/auth_state_provider.dart';
import 'package:vactrack/src/screens/auth/auth_screen.dart';
import 'package:vactrack/src/screens/home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool visible = true;

  @override
  void initState() {
  super.initState();
  Timer(const Duration(milliseconds: 1500), () async {
    setState(() {
      visible = false;
    });

    final user = FirebaseAuth.instance.currentUser;
    
    if (user != null) {
      final authProvider = Provider.of<AuthStateProvider>(context, listen: false);
      authProvider.setUid();
      await authProvider.fetchDetails();
      print(authProvider.username); // Await the user details fetching
    }

    Timer(const Duration(milliseconds: 1000), () {
      if (FirebaseAuth.instance.currentUser == null) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AuthScreen()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
      }
    });
  });
}

  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(child: AnimatedOpacity(duration:const Duration(milliseconds: 1000),
      opacity: visible?1.0:0.0,
      child:Image.asset('assets/images/logo.jpeg'),),)
    );
  }
}