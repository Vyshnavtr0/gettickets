import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:getickets/Models/UserModel.dart';
import 'package:getickets/Screens/Location.dart';
import 'package:getickets/Screens/Login.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  bool remember = false;
  bool password_visible = true;
  final name_controller = TextEditingController();
  final email_controller = TextEditingController();
  final password_controller2 = TextEditingController();
  final password_controller = TextEditingController();
  final auth = FirebaseAuth.instance;
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
            image: AssetImage("assets/images/bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          //reverse: true,
          physics: BouncingScrollPhysics(),
          child: SafeArea(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Spacer(),
                  Container(
                    height: MediaQuery.of(context).size.height / 1.3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Get Your Tickets,",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 36,
                                    fontWeight: FontWeight.w900)),
                            Text("Sign Up to continue",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18)),
                          ],
                        ),
                        Spacer(),
                        Spacer(),
                        Spacer(),
                        Text("Username",
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width / 1.2,
                            height: 56,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8)),
                            child: TextField(
                              keyboardType: TextInputType.name,
                              controller: name_controller,
                              cursorColor: Color(0xFFD70B17),
                              decoration: InputDecoration(
                                  hintText: "    Username",
                                  hintStyle: TextStyle(
                                      color: Color(0xffA7A7A7), fontSize: 16),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFFD70B17)),
                                    borderRadius: BorderRadius.circular(8),
                                  )),
                            )),
                        Spacer(),
                        Text("Email Address",
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width / 1.2,
                            height: 56,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8)),
                            child: TextField(
                              keyboardType: TextInputType.emailAddress,
                              controller: email_controller,
                              cursorColor: Color(0xFFD70B17),
                              decoration: InputDecoration(
                                  hintText: "    Email Address",
                                  hintStyle: TextStyle(
                                      color: Color(0xffA7A7A7), fontSize: 16),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFFD70B17)),
                                    borderRadius: BorderRadius.circular(8),
                                  )),
                            )),
                        Spacer(),
                        Text("Password",
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width / 1.2,
                            height: 56,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8)),
                            child: TextField(
                              controller: password_controller,
                              cursorColor: Color(0xFFD70B17),
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: password_visible,
                              decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          password_visible = !password_visible;
                                        });
                                      },
                                      color: Color(0xffA7A7A7),
                                      icon: password_visible
                                          ? Icon(Icons.visibility_outlined)
                                          : Icon(
                                              Icons.visibility_off_outlined)),
                                  hintText: "    Password",
                                  hintStyle: TextStyle(
                                      color: Color(0xffA7A7A7), fontSize: 16),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFFD70B17)),
                                    borderRadius: BorderRadius.circular(8),
                                  )),
                            )),
                        Spacer(),
                        Text("Confirm Password",
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width / 1.2,
                            height: 56,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8)),
                            child: TextField(
                              controller: password_controller2,
                              keyboardType: TextInputType.visiblePassword,
                              cursorColor: Color(0xFFD70B17),
                              obscureText: password_visible,
                              decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          password_visible = !password_visible;
                                        });
                                      },
                                      color: Color(0xffA7A7A7),
                                      icon: password_visible
                                          ? Icon(Icons.visibility_outlined)
                                          : Icon(
                                              Icons.visibility_off_outlined)),
                                  hintText: "    Confirm Password",
                                  hintStyle: TextStyle(
                                      color: Color(0xffA7A7A7), fontSize: 16),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFFD70B17)),
                                    borderRadius: BorderRadius.circular(8),
                                  )),
                            )),
                        Spacer(),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          remember = !remember;
                                        });
                                      },
                                      color: Colors.white,
                                      icon: remember
                                          ? Icon(Icons.check_box)
                                          : Icon(
                                              Icons.check_box_outline_blank,
                                            )),
                                  Text("Remember Me",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: (() {
                            if (name_controller.text != "") {
                              if (email_controller.text != "") {
                                if (password_controller.text != "" &&
                                    password_controller.text.length >= 6) {
                                  if (password_controller2.text != "" &&
                                      password_controller2.text ==
                                          password_controller.text) {
                                    signUp(email_controller.text,
                                        password_controller.text);
                                    showDialog(
                                        context: context,
                                        builder: (context) => SpinKitCircle(
                                              color: Colors
                                                  .white, //Color(0xffE25E31),
                                              size: 50.0,
                                            ));
                                  } else {
                                    showTopSnackBar(
                                      context,
                                      CustomSnackBar.error(
                                        message: "Password doesn't match!",
                                      ),
                                    );
                                  }
                                } else {
                                  showTopSnackBar(
                                    context,
                                    CustomSnackBar.error(
                                      message:
                                          "Please Enter Your Password (Min char 6) !",
                                    ),
                                  );
                                }
                              } else {
                                showTopSnackBar(
                                  context,
                                  CustomSnackBar.error(
                                    message:
                                        "Please Enter Your Email Address !",
                                  ),
                                );
                              }
                            } else {
                              showTopSnackBar(
                                context,
                                CustomSnackBar.error(
                                  message: "Please Enter Your Username !",
                                ),
                              );
                            }
                          }),
                          child: Container(
                            width: MediaQuery.of(context).size.width / 1.2,
                            height: MediaQuery.of(context).size.width / 7,
                            child: Center(
                              child: Text("Sign Up",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700)),
                            ),
                            decoration: BoxDecoration(
                                color: Color(0xFFD70B17), //Colors.red,
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account?",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            // fontWeight: FontWeight.w700
                          )),
                      TextButton(
                          child: Text("Sign in",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14)),
                          onPressed: (() {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => Login()));
                          })),
                    ],
                  ),
                  Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void signUp(String email, String password) async {
    await auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((uid) => {
              postDetailsToFirestore(),
            })
        .catchError((e) {
      Navigator.of(context).pop();
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: e.message!,
        ),
      );
    });
  }

  postDetailsToFirestore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    User? user = auth.currentUser;

    usermodel userModel = usermodel();

    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.name = name_controller.text;
    userModel.lan = "";
    userModel.lon = "";
    userModel.location = "";

    await firebaseFirestore
        .collection("Users")
        .doc(userModel.uid)
        .set(userModel.toMap());
    Navigator.of(context).pop();
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => GetLocation()));
    showTopSnackBar(
      context,
      CustomSnackBar.success(
        backgroundColor: Colors.green,
        message: "Account Created Successfully",
      ),
    );
  }
}
