// TODO Implement this library.
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _isPasswordVisible = false;

  GlobalKey<FormState> formKey = GlobalKey();

  Function(String)? onChange;
  String? email;
  String? password;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Scaffold(
          body: Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Image(
                      image: AssetImage(
                          "assets/images/freed.png"), // Correctly instantiate AssetImage
                      width: 400,
                      height: 130,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText:
                              "Enter Name", // Note the lowercase 'l' in 'labelText'
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: TextFormField(
                        validator: (data){
                          if( data!.isEmpty){
                            return "Field is required";
                          }
                        },
                        onChanged: (data) {
                          email = data;
                        },
                        decoration: const InputDecoration(
                          labelText:
                              "Enter Email", // Note the lowercase 'l' in 'labelText'
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: TextFormField(
                        validator: (data){
                          if( data!.isEmpty){
                            return "Field is required";
                          }
                        },
                        onChanged: (data) {
                          password = data;
                        },
                        decoration: InputDecoration(
                          labelText:
                              "Enter Password", // Note the lowercase 'l' in 'labelText'
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(_isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                        controller: TextEditingController(),
                        obscureText: !_isPasswordVisible,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      width: double.infinity,
                      height: 60,
                      margin: const EdgeInsets.only(left: 22, right: 22),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            isLoading = true;
                            setState(() {});
                            try {
                              UserCredential user = await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(email: email!, password: password!);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Account Created! You can now log in.",),),
                              );
                              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
                            } on FirebaseAuthException catch (ex) {
                              if (ex.code == "weak-password") {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("The password provided is too weak.",),),
                                );
                              } else if (ex.code == "email-already-in-use") {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Email already exists.",),),
                                );}
                            } catch (ex) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("There was an error!",),),
                              );
                            }
                            isLoading = false;
                            setState(() {});
                          }
                        },
                        child: const Text("Create Account", style: TextStyle(fontWeight: FontWeight.bold,
                              fontSize: 20, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEf6969),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an Account?",
                          style: TextStyle(fontSize: 15),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFEf6969)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
