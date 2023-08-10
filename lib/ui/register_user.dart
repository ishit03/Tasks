import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:todo_list/helpers/validate.dart';
import 'package:todo_list/helpers/globals.dart';
import 'package:todo_list/ui/log_in.dart';
import 'package:todo_list/helpers/fire_auth.dart';

class RegisterUser extends StatefulWidget {
  const RegisterUser({super.key});

  @override
  State<RegisterUser> createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  bool passVisible = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(bottom: 50.0),
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).primaryColor)),
                child: const Text(
                  'Tasks',
                  style: TextStyle(fontSize: 40.0, letterSpacing: 10.0),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  child: TextFormField(
                    controller: _nameController,
                    validator: (val) => Validate.validateUser(val!),
                    style: const TextStyle(fontSize: 20.0),
                    decoration: const InputDecoration(
                        filled: true,
                        border: InputBorder.none,
                        labelText: 'User Name',
                        labelStyle: TextStyle(fontSize: 16.0),
                        prefixIcon: Icon(
                          Icons.edit_sharp,
                        )),
                  )),
              Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  child: TextFormField(
                    controller: _emailController,
                    validator: (val) => Validate.validateEmail(val!),
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(fontSize: 20.0),
                    decoration: const InputDecoration(
                        filled: true,
                        prefixIcon: Icon(Icons.person),
                        labelText: 'Email',
                        labelStyle: TextStyle(
                          fontSize: 16.0,
                        ),
                        border: InputBorder.none),
                  )),
              Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  child: TextFormField(
                    controller: _passwordController,
                    validator: (val) => Validate.validatePassword(val!),
                    obscureText: !passVisible,
                    obscuringCharacter: '*',
                    keyboardType: TextInputType.visiblePassword,
                    style: const TextStyle(
                        /*color: Colors.black,*/ fontSize: 20.0),
                    //cursorColor: Colors.grey,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.lock, /*color: Colors.black*/
                        ),
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                passVisible = !passVisible;
                              });
                            },
                            icon: Icon(
                              (passVisible)
                                  ? Icons.visibility_off
                                  : Icons.visibility, /*color: Colors.black*/
                            )),
                        labelText: 'Password',
                        labelStyle: const TextStyle(
                          //color: Colors.grey,
                          fontSize: 16.0,
                        ),
                        border: InputBorder.none),
                  )),
              Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formkey.currentState!.validate()) {
                        SmartDialog.showLoading(
                            msg: 'Signing In',
                            animationType:
                                SmartAnimationType.centerScale_otherSlide,
                            maskColor:
                                const Color.fromRGBO(255, 255, 255, 0.3));
                        User? user = await FireAuth.registerUsingEmailPassword(
                            name: _nameController.text,
                            email: _emailController.text,
                            password: _passwordController.text);
                        SmartDialog.dismiss();
                        if (user != null) {
                          prefs.setString("user", user.uid);
                          if (context.mounted) {
                            SmartDialog.showLoading(
                                msg: 'Signing In',
                                animationType:
                                    SmartAnimationType.centerScale_otherSlide,
                                maskColor:
                                    const Color.fromRGBO(255, 255, 255, 0.3));
                            user.sendEmailVerification();
                            SmartDialog.dismiss();
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Email Verification'),
                                    titleTextStyle: const TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold),
                                    content: const Text(
                                        'A link has been sent to the registered email address. Kindly verify the email address before logging in.'),
                                    contentTextStyle:
                                        const TextStyle(fontSize: 16.0),
                                    actions: <Widget>[
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pushReplacement(
                                                MaterialPageRoute(
                                                    builder: (context) => LogIn(
                                                        email: _emailController
                                                            .text)));
                                          },
                                          child: const Text('OK'))
                                    ],
                                  );
                                });
                          }
                        } else {
                          SmartDialog.show(builder: (context) {
                            return Container(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Flexible(
                                      child: Icon(
                                    Icons.error_outline,
                                    size: 50.0,
                                    color: Colors.red,
                                  )),
                                  Flexible(
                                      child: Text(
                                    FireAuth.errorCode,
                                    style: const TextStyle(fontSize: 24.0),
                                  ))
                                ],
                              ),
                            );
                          });
                        }
                      }
                    },
                    style: ButtonStyle(
                      minimumSize:
                          MaterialStateProperty.all(const Size(120.0, 50.0)),
                    ),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  )),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: 'Already have an account?   ',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 14.0,
                            fontFamily: 'Viga')),
                    TextSpan(
                        text: 'Log In',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 14.0,
                            fontFamily: 'Viga',
                            decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Navigator.pushReplacement(
                              context,
                              PageRouteBuilder(
                                  pageBuilder: (_, __, ___) =>
                                      const LogIn(email: ''),
                                  transitionDuration:
                                      const Duration(milliseconds: 500),
                                  transitionsBuilder: (_, a, __, c) =>
                                      SlideTransition(
                                        position: Tween(
                                                begin: const Offset(-1.0, 0.0),
                                                end: Offset.zero)
                                            .animate(CurvedAnimation(
                                                parent: a, curve: Curves.ease)),
                                        child: c,
                                      ))))
                  ])))
            ],
          ),
        ),
      ),
    ));
  }
}
