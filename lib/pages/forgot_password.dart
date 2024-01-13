import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:pickme/global/global.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pickme/pages/signuppage.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => ForgotPasswordState();
}

class ForgotPasswordState extends State<ForgotPassword> {
  final emailTextEditingController = TextEditingController();
  final passwordTextEditingController = TextEditingController();

  bool passwordVisible = false;

  final _formKey = GlobalKey<FormState>();

  void submit() {
    firebaseAuth
        .sendPasswordResetEmail(email: emailTextEditingController.text.trim())
        .then((value) {
      Fluttertoast.showToast(
          msg: "Link sudah dikirim, silahkan cek email anda.");
    }).onError((error, stackTrace) {
      Fluttertoast.showToast(msg: "Terjadi error \n ${error.toString()}");
    });
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text('RESET PASSWORD'), titleSpacing: 15),
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
                          //submit();
                        },
                        child: Text('SEND REQUEST')),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (c) => const SignUpPage()));
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                            color: darkTheme
                                ? Colors.amber.shade400
                                : Colors.blue),
                      ),
                    ),
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
