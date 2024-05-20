import 'package:e_commerce_shopping_app/screens/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'navigation_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;

  bool isLoading = false;
  GlobalKey<FormState> formKey = GlobalKey();
  String? email;
  String? password;

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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Image(
                      image: AssetImage("assets/images/freed.png"), // Correctly instantiate AssetImage
                      width: 400,
                      height: 150,
                    ),
                    const SizedBox(height: 10),
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
                          labelText: "Enter Email", // Note the lowercase 'l' in 'labelText'
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
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
                          labelText: "Password", // Note the lowercase 'l' in 'labelText'
                          border: const OutlineInputBorder(

                          ),
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
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
                    const SizedBox(height:30),
                    Container(
                      width: double.infinity,
                      height: 60,
                      margin: const EdgeInsets.only(left: 22, right: 22),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            isLoading = true;
                            setState(() {
                            });
                            try {
                              UserCredential user = await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(email: email!, password: password!);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Success!",),),
                              );
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const NavigationScreen(),));
                            } on FirebaseAuthException catch (ex) {
                              if (ex.code == "user-not-found") {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("User not found.",),),
                                );
                              } else if (ex.code == "wrong-password") {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Wrong password.",),),
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
                        child: const Text("Login", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
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
                          "Don't Have Account?",
                          style: TextStyle(fontSize: 15),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SignupScreen(),));
                          },
                          child: const Text(
                            'Signup',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFEf6969)),
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
