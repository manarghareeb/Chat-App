import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../Components/components.dart';
import '../Constants/constant.dart';
import '../Helper/showSnackBar.dart';
import 'ChatScreen.dart';
import 'RegisterScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static String id = 'LoginScreen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  bool isLoading = false;
  bool isPassword = true;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: KBackgroundColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: ListView(
                children: [
                  Image.asset('assets/download.png',height: 250,),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Chat App',
                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30,),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'LOGIN',
                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  buildTextFormField(
                    labelText: 'Email',
                    prefixIcon: Icons.email,
                    onChanged: (data){
                      email = data;
                    }
                  ),
                  const SizedBox(height: 20,),
                  buildTextFormField(
                    onChanged: (data){
                      password = data;
                    },
                    labelText: 'Password',
                    prefixIcon: Icons.password,
                    obscureText: isPassword,
                    suffixIcon: isPassword ? Icons.visibility_off : Icons.visibility,
                    suffixPressed: (){
                      setState(() {
                        isPassword = !isPassword;
                      });
                    },
                  ),
                  const SizedBox(height: 20,),
                  buildButton(
                    text: 'LOGIN',
                    onPressed: () async {
                      if(formKey.currentState!.validate()){
                        isLoading = true;
                        setState(() {});
                        try {
                          await loginUser();
                          Navigator.pushNamed(context, ChatScreen.id, arguments: email);
                        } on FirebaseAuthException catch (e) {
                          showSnackBar(context, 'message', Colors.red);
                          if (e.code == 'user-not-found') {
                            showSnackBar(context, 'No user found for that email.', Colors.red);
                          } else if (e.code == 'wrong-password') {
                            showSnackBar(context, 'Wrong password provided for that user.', Colors.red);
                          }
                        } catch (e) {
                          showSnackBar(context, 'Something went wrong', Colors.red);
                        }
                        isLoading = false;
                        setState(() {});
                      } else {}
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Don\'t have an account?'),
                      TextButton(
                          onPressed: (){
                            Navigator.pushNamed(context, RegisterScreen.id);
                          },
                          style: TextButton.styleFrom(
                            overlayColor: Colors.white,
                          ),
                          child: const Text('Register')
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> loginUser() async {
    UserCredential credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email!,
        password: password!
    );
  }

}
