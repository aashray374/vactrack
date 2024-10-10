import 'package:flutter/material.dart';
import 'package:vactrack/src/screens/auth/login_screen.dart';
import 'package:vactrack/src/screens/auth/signUp_screen.dart';
import 'package:vactrack/src/widgets/tab_item.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _RegisterState();
}

class _RegisterState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  late TabController tabController = TabController(length: 2, vsync: this);

  

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff6C63FF),
      body: Column(
        children: [
          const Expanded(
            flex: 3,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Go ahead and set up your account",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Sign in-up to enjoy best experience",
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: SizedBox(
              width: double.infinity,
              child: Card(
                elevation: 4,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TabBar(
                      indicator:const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      controller: tabController,
                      tabs: const [
                        TabItem(title: "Login"),
                        TabItem(title: "Register"),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: tabController,
                        children: const [
                          Center(child: Login()),  
                          Center(child: Signup()),  
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
