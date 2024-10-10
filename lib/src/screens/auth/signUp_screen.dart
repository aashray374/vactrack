import 'package:flutter/material.dart';
import 'package:vactrack/src/controllers/auth_controller.dart';
import 'package:vactrack/src/screens/home_page.dart';

class Signup extends StatelessWidget {
  const Signup({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailcontroller = TextEditingController();
    TextEditingController passwordcontroller = TextEditingController();
    TextEditingController namecontroller = TextEditingController();
    return Scaffold(
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.only(right: 20, left: 20, top: 20),
              child: Column(children: [
                SizedBox(
                  width: double.infinity,
                  child: TextFormField(
                    controller: namecontroller,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text("Name")),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                SizedBox(
                  width: double.infinity,
                  child: TextFormField(
                    controller: emailcontroller,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text("Email")),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                SizedBox(
                  width: double.infinity,
                  child: TextFormField(
                    controller: passwordcontroller,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text("password")),
                  ),
                ),
                const SizedBox(
                  height: 48,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: ()async {
                      bool completed = await signUp(namecontroller.text,emailcontroller.text, passwordcontroller.text, context);
                      if(completed){
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const HomePage()));
                      }
                    },
                    child: const Text("Register"),
                  ),
                )
              ])),
        ));
  }
}
