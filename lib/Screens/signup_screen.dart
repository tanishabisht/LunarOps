import 'package:flutter/material.dart';
import 'package:uploadlunarops/Services/Authentication/email_auth.dart';

import 'SignUp/Widgets/video_player.dart';

class SignupOptionScreen extends StatefulWidget {
  @override
  _SignupOptionScreenState createState() => _SignupOptionScreenState();
}

class _SignupOptionScreenState extends State<SignupOptionScreen> {
  var passwordNode = FocusNode();
  String? userEmail, userPassword, confirmPassword;
  final GlobalKey<FormState> _formKey = GlobalKey();
  var emailController = TextEditingController();
  var passController = TextEditingController();

  void _SignUp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    if (userPassword == confirmPassword) {
      try {
        await EmailAuth().signup(
            email: userEmail!, password: userPassword!, context: context);
        emailController.clear();
        passController.clear();
      } on Exception catch (error) {
        String error_message = '';
        if (error.toString().contains('EMAIL_EXISTS')) {
          error_message = 'This Email Already Exists';
        }
        if (error.toString().contains('INVALID_EMAIL')) {
          error_message = 'The email Entered is invalid';
        }
        if (error.toString().contains('USER_DISABLED')) {
          error_message = 'The User has been Disabled';
        }
        dialogBox(error_message);
      } catch (genral_error) {
        dialogBox('Unforseen Error has ocurred');
      }
    } else {
      dialogBox("Password and ConfirmPassword is not same");
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    passwordNode.dispose();
    super.dispose();
  }

  void dialogBox(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('An Error has Occured'),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            children: [
              VideoApp(
                vidPath: 'assets/bv.mp4',
              ),
              Center(
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text(
                            'Log In',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 30),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            controller: emailController,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            validator: (value) {
                              if (value.toString().isEmpty) {
                                return 'This field cannot be empty';
                              }

                              if (value!.isEmpty || !value.contains('@')) {
                                return 'Invalid email!';
                              }
                              return null;
                            },
                            onSaved: (val) {
                              userEmail = val!;
                            },
                            decoration: InputDecoration(
                              hintStyle: const TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(15)),
                              hintText: 'Enter E-Mail',
                            ),
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context).requestFocus(passwordNode);
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: passController,
                            focusNode: passwordNode,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            validator: (value) {
                              if (value!.isEmpty || value.length < 5) {
                                return 'Password is too short!';
                              }
                            },
                            onSaved: (val) {
                              userPassword = val!;
                            },
                            onFieldSubmitted: (_) {},
                            obscureText: true,
                            decoration: InputDecoration(
                              hintStyle: const TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(15)),
                              hintText: 'Enter Password',
                            ),
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextButton(
                              onPressed: () {
                                _SignUp();
                              },
                              child: const Text(
                                'Log In',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: TextButton.styleFrom(
                                minimumSize: const Size(double.infinity, 50),
                                backgroundColor: Colors.indigo,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                              )),
                          const SizedBox(
                            height: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
