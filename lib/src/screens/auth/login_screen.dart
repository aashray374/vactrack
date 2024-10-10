import 'package:flutter/material.dart';
import 'package:vactrack/src/controllers/auth_controller.dart';
import 'package:vactrack/src/screens/home_page.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  @override
  void dispose() {
    emailcontroller.dispose();
    passwordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(right: 20,left: 20,top: 20),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: TextFormField(
                controller: emailcontroller,
                decoration:const InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  prefixIconColor: Colors.blue,
                  border: OutlineInputBorder(),
                  label: Text("Email")
                ),
              ),
            ),
            const SizedBox(height: 24,),
            SizedBox(
              width: double.infinity,
              child: TextFormField(
                controller: passwordcontroller,
                decoration:const InputDecoration(
                  prefixIcon: Icon(Icons.password_rounded),
                  prefixIconColor: Colors.blue,
                  border: OutlineInputBorder(),
                  label: Text("password")
                ),
              ),
            ),
            const SizedBox(height: 8,),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [TextButton(onPressed:(){
              //reset password screen here
            },child:const Text("Forgot Password?"))],),
            const SizedBox(height: 24,),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: () async{
                bool completed = await signin(emailcontroller.text, passwordcontroller.text, context);
                if(completed){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const HomePage()));
                }
              },
              child:const Text("Login"),),
            )
          ],
        ),
      ),
    );
  }
}