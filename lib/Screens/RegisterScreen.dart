import 'package:chat_app/Screens/ChatScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../Components/components.dart';
import '../Constants/constant.dart';
import '../Helper/showSnackBar.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  static String id = 'RegisterScreen';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String? email;
  String? password;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
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
                        'REGISTER',
                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  buildTextFormField(
                    onChanged: (data){
                      email = data;
                    },
                      labelText: 'Email',
                      prefixIcon: Icons.email
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
                    text: 'REGISTER',
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        isLoading = true;
                        setState(() {});
                        try {
                          await registerUser();
                          Navigator.pushNamed(context, ChatScreen.id);
                        }on FirebaseAuthException catch (e) {
                          showSnackBar(context, 'message', Colors.red);
                          if (e.code == 'weak-password') {
                            showSnackBar(context, 'The password provided is too weak.', Colors.red);
                          } else if (e.code == 'email-already-in-use') {
                            showSnackBar(context, 'The account already exists for that email.', Colors.red);
                          }
                        } catch (e) {
                          showSnackBar(context, 'Something went wrong.', Colors.red);
                        }
                        isLoading = false;
                        setState(() {});
                      } else {}
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account ?'),
                      TextButton(
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          style: TextButton.styleFrom(
                            overlayColor: Colors.white,
                          ),
                          child: const Text('Login')
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

  Future<void> registerUser() async {
    var auth = FirebaseAuth.instance;
    UserCredential user = await auth.createUserWithEmailAndPassword(
        email: email!,
        password: password!
    );
  }

}
