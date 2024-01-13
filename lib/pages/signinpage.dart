import 'package:email_validator/email_validator.dart';
// import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pickme/global/global.dart';
import 'package:pickme/pages/forgot_password.dart';
import 'package:pickme/pages/homepage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pickme/pages/signuppage.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => SignInPageState();
}

class SignInPageState extends State<SignInPage> {
  final emailTextEditingController = TextEditingController();
  final passwordTextEditingController = TextEditingController();

  bool passwordVisible = false;

  final _formKey = GlobalKey<FormState>();

  void submit() async {
    if (_formKey.currentState!.validate()) {
      await firebaseAuth
          .signInWithEmailAndPassword(
              email: emailTextEditingController.text.trim(),
              password: passwordTextEditingController.text.trim())
          .then((auth) async {
        currentUser = auth.user;

        await Fluttertoast.showToast(msg: "Berhasil Login");
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (c) => const HomePage()));
      }).catchError((errorMessage) {
        Fluttertoast.showToast(msg: "Terjadi error \n $errorMessage");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text('LOGIN'), titleSpacing: 15),
      body: ListView(
        padding: EdgeInsets.all(4),
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://images.pexels.com/photos/3876401/pexels-photo-3876401.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'),
                radius: 90,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 20, 15, 50),
                child: Form(
                  key: _formKey,
                  child: Column(children: [
                    TextFormField(
                      inputFormatters: [LengthLimitingTextInputFormatter(50)],
                      decoration: InputDecoration(
                          hintText: 'Email',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                          filled: true,
                          fillColor:
                              darkTheme ? Colors.black45 : Colors.grey.shade200,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide:
                                BorderSide(width: 0, style: BorderStyle.none),
                          ),
                          prefixIcon: Icon(Icons.email,
                              color: darkTheme
                                  ? Colors.amber.shade200
                                  : Colors.grey)),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Email can\'t empty';
                        }
                        if (EmailValidator.validate(text) == true) {
                          return null;
                        }
                      },
                      onChanged: (text) => setState(() {
                        emailTextEditingController.text = text;
                      }),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      obscureText: !passwordVisible,
                      inputFormatters: [LengthLimitingTextInputFormatter(50)],
                      decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                          filled: true,
                          fillColor:
                              darkTheme ? Colors.black45 : Colors.grey.shade200,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide:
                                BorderSide(width: 0, style: BorderStyle.none),
                          ),
                          prefixIcon: Icon(Icons.key,
                              color: darkTheme
                                  ? Colors.amber.shade200
                                  : Colors.grey),
                          suffixIcon: IconButton(
                            icon: Icon(
                                passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: darkTheme
                                    ? Colors.amber.shade200
                                    : Colors.grey),
                            onPressed: () {
                              setState(() {
                                passwordVisible = !passwordVisible;
                              });
                            },
                          )),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Password can\'t empty';
                        }

                        if (text.length < 2) {
                          return 'Please input valid Password';
                        }

                        if (text.length < 8) {
                          return 'Password too short';
                        }
                      },
                      onChanged: (text) => setState(() {
                        passwordTextEditingController.text = text;
                      }),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary:
                              darkTheme ? Colors.amber.shade400 : Colors.blue,
                          onPrimary: darkTheme ? Colors.black : Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                          minimumSize: Size(double.infinity, 50),
                        ),
                        onPressed: () {
                          submit();
                        },
                        child: Text('LOGIN')),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (c) => const ForgotPassword()));
                      },
                      child: Text(
                        'Forgot password?',
                        style: TextStyle(
                            color: darkTheme
                                ? Colors.amber.shade400
                                : Colors.blue),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don\'t hava an account? ',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (c) => const SignUpPage()));
                          },
                          child: Text(
                            'Daftar',
                            style: TextStyle(
                                color: darkTheme
                                    ? Colors.amber.shade400
                                    : Colors.blue),
                          ),
                        ),
                      ],
                    )
                  ]),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
