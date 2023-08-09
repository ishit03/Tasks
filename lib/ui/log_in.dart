import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:todo_list/helpers/fire_auth.dart';
import 'package:todo_list/ui/home_page.dart';
import 'package:todo_list/helpers/validate.dart';
import 'package:todo_list/ui/register_user.dart';
import 'package:firebase_core/firebase_core.dart';
import '../helpers/globals.dart';

class LogIn extends StatefulWidget {
  final String email;
  const LogIn({Key? key, required this.email}) : super(key: key);
  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  bool isLoading = true;
  bool passVisible = false;
  bool isValid = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    if (Firebase.apps.isEmpty) {
      return Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    _emailController.text = widget.email;
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
                  controller: _emailController,
                  validator: (val) => Validate.validateEmail(val!),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person),
                    labelText: 'Email',
                    errorText: isValid ? null : 'Invalid Email',
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.error)),
                  ),
                )),
            Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: TextFormField(
                  validator: (val) => Validate.validatePassword(val!),
                  controller: _passwordController,
                  obscureText: !passVisible,
                  obscuringCharacter: '*',
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            passVisible = !passVisible;
                          });
                        },
                        icon: Icon((passVisible)
                            ? Icons.visibility_off
                            : Icons.visibility)),
                    labelText: 'Password',
                  ),
                )),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TextButton(
                  onPressed: () {
                    if (Validate.validateEmail(_emailController.text) != null) {
                      setState(() {
                        isValid = false;
                      });
                    } else {
                      firebaseAuth.sendPasswordResetEmail(
                          email: _emailController.text);
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Password Reset'),
                              titleTextStyle: const TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                              content: Text(
                                  'We have sent password reset link to ${_emailController.text}.'),
                              contentTextStyle: const TextStyle(fontSize: 16.0),
                              actions: <Widget>[
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('OK'))
                              ],
                            );
                          });
                      setState(() {
                        isValid = true;
                      });
                    }
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      fontSize: 16.0,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ),
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
                        maskColor: const Color.fromRGBO(255, 255, 255, 0.3),
                      );
                      User? user = await FireAuth.signInUsingEmailPassword(
                          email: _emailController.text,
                          password: _passwordController.text);
                      SmartDialog.dismiss();
                      if (user != null && user.emailVerified) {
                        prefs.setString("user", user.uid);
                        if (context.mounted) {
                          Navigator.pushReplacement(
                              context,
                              PageRouteBuilder(
                                  pageBuilder: (_, __, ___) =>
                                      HomePage(user: user.uid),
                                  transitionDuration:
                                      const Duration(milliseconds: 500),
                                  transitionsBuilder: (_, a, __, c) =>
                                      SlideTransition(
                                        position: Tween(
                                                begin: const Offset(0.0, 1.0),
                                                end: Offset.zero)
                                            .animate(CurvedAnimation(
                                                parent: a, curve: Curves.ease)),
                                        child: c,
                                      )));
                        }
                      } else {
                        SmartDialog.show(builder: (context) {
                          return Center(
                            child: Container(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                height: 200,
                                width: 200,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.error_outline,
                                      size: 50.0,
                                      color: Colors.red,
                                    ),
                                    Text(
                                      'Invalid Email \nOr Password',
                                      style: TextStyle(fontSize: 24.0),
                                    )
                                  ],
                                )),
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
                    'Log In',
                    style: TextStyle(fontSize: 18.0),
                  ),
                )),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: 'Don\'t have an account yet?  ',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 14.0,
                          fontFamily: 'Viga')),
                  TextSpan(
                      text: 'Sign Up',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 14.0,
                          fontFamily: 'Viga',
                          decoration: TextDecoration.underline),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => {
                              Navigator.pushReplacement(
                                  context,
                                  PageRouteBuilder(
                                      pageBuilder: (_, __, ___) =>
                                          const RegisterUser(),
                                      transitionDuration:
                                          const Duration(milliseconds: 500),
                                      transitionsBuilder: (_, a, __, c) =>
                                          SlideTransition(
                                            position: Tween(
                                                    begin:
                                                        const Offset(1.0, 0.0),
                                                    end: Offset.zero)
                                                .animate(CurvedAnimation(
                                                    parent: a,
                                                    curve: Curves.ease)),
                                            child: c,
                                          )))
                            })
                ])))
          ],
        ),
      )),
    ));
  }
}
