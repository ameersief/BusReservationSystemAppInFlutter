import 'dart:async';


import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:busreservation/config.dart';

class SignUp extends StatefulWidget{
  State<SignUp> createState(){
    return _SignUpState();
  }
}
class _SignUpState extends State<SignUp>{
  TextEditingController username=TextEditingController();
  TextEditingController password=TextEditingController();
  TextEditingController confirmpass=TextEditingController();
  String error="";
  void dispose(){
    username.dispose();
    password.dispose();
    confirmpass.dispose();
    super.dispose();
  }

  void signup() async{
    if(password.text==confirmpass.text){
      try {
        var response=await http.post(Uri.parse('${Config.baseUrl}/signup'),
        body: jsonEncode({
          "userName":username.text,
          "password":password.text
        }),
        headers: {
          "Content-Type":"application/json"
        }
        ).timeout(const Duration(seconds: 10));
        if(response.statusCode==200){
          if (mounted) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("signup successful")));
          }
        }
        else{
          if (mounted) {
            setState(() {
              error="something went wrong";
            });
          }
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            error="Connection failed";
          });
        }
      }
    }else{
      setState(() {
        error="passwords did not match";
      });
    }
  }
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(padding: EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset("assets/bus.png",height: 200,width: 200,),
            Text(error,style:const TextStyle(
              color: Colors.red,
            )),
              TextField(
                controller: username,
                decoration: const InputDecoration(
                  hintText: "username",
                ),
              ),
              TextField(
                controller: password,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: "password"
                ),
              ),
              TextField(
                controller: confirmpass,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: "confirm password"
                ),
              ),
              const SizedBox(height: 20,),
              ElevatedButton(onPressed: signup, child: const Text("Sign up"))
          ],
        ),),
      ),
    );
  }
}