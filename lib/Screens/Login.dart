import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:getickets/Models/UserModel.dart';
import 'package:getickets/Screens/Location.dart';
import 'package:getickets/Screens/SignUp.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  bool remember = false;
  bool password_visible = true;
  final email_controller = TextEditingController();
  final email_controller2 = TextEditingController();
  final password_controller = TextEditingController();
  final auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? googleSignInAccount;
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
                  ListTile(
                    trailing: TextButton(
                        child: Text("SKIP",
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                        onPressed: (() {
                            Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => GetLocation()));
                        })),
                  ),
                  Spacer(),
                  Container(
                    height: MediaQuery.of(context).size.height / 1.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Welcome Back,",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 36,
                                    fontWeight: FontWeight.w900)),
                            Text("Sign in to continue",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18)),
                          ],
                        ),
                        Spacer(),
                        Spacer(),
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
                              keyboardType: TextInputType.visiblePassword,
                              controller: password_controller,
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
                              TextButton(
                                  child: Text("Forgot Password?",
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: Colors.white,
                                          fontSize: 14)),
                                  onPressed: (() {
                                    showMaterialModalBottomSheet(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(25.0))),
                                      context: context,
                                      backgroundColor: Colors.white,
                                      bounce: true,
                                      builder: (context) => Padding(
                                        padding:
                                            MediaQuery.of(context).viewInsets,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text("Forgot Your Password?",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Color(0xFF222222),
                                                        fontSize: 17)),
                                                Container(
                                                  width: 38,
                                                  height: 38,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                    color: Color(0xFF707070)
                                                        .withOpacity(0.2),
                                                  ),
                                                  child: IconButton(
                                                      onPressed: (() {
                                                        Navigator.of(context)
                                                            .pop();
                                                      }),
                                                      icon: Icon(
                                                        Icons.close,
                                                        color: Color(0xFF707070)
                                                            .withOpacity(0.7),
                                                        size: 20,
                                                      )),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              color: Color(0xFF707070)
                                                  .withOpacity(0.2),
                                              height: 0.5,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.2,
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.2,
                                                height: 56,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                                child: TextField(
                                                  keyboardType: TextInputType
                                                      .emailAddress,
                                                  cursorColor:
                                                      Color(0xFFD70B17),
                                                  controller: email_controller2,
                                                  decoration: InputDecoration(
                                                      hintText:
                                                          "    Email Address",
                                                      hintStyle: TextStyle(
                                                          color:
                                                              Color(0xffA7A7A7),
                                                          fontSize: 16),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.grey),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Color(
                                                                0xFFD70B17)),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      )),
                                                )),
                                            SizedBox(
                                              height: 60,
                                            ),
                                            GestureDetector(
                                              onTap: (() {
                                                if (email_controller2.text !=
                                                    "") {
                                                  reset(email_controller2.text);
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          SpinKitCircle(
                                                            color: Colors
                                                                .white, //Color(0xffE25E31),
                                                            size: 50.0,
                                                          ));
                                                } else {
                                                  showTopSnackBar(
                                                    context,
                                                    CustomSnackBar.error(
                                                      message:
                                                          "Please Enter Your Email Address !",
                                                    ),
                                                  );
                                                }
                                              }),
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.2,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    7,
                                                child: Center(
                                                  child: Text("Submit",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w700)),
                                                ),
                                                decoration: BoxDecoration(
                                                    color: Color(
                                                        0xFFD70B17), //Colors.red,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  })),
                            ],
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: (() {
                            if (email_controller.text != "") {
                              if (password_controller.text != "" &&
                                  password_controller.text.length >= 6) {
                                signIn(email_controller.text,
                                    password_controller.text);
                                showDialog(
                                    context: context,
                                    builder: (context) => SpinKitCircle(
                                          color:
                                              Colors.white, //Color(0xffE25E31),
                                          size: 50.0,
                                        ));
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
                                  message: "Please Enter Your Email Address !",
                                ),
                              );
                            }
                          }),
                          child: Container(
                            width: MediaQuery.of(context).size.width / 1.2,
                            height: MediaQuery.of(context).size.width / 7,
                            child: Center(
                              child: Text("Sign in",
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
                        Spacer(),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                color: Colors.white,
                                height: .5,
                                width: MediaQuery.of(context).size.width / 3,
                              ),
                              Text("OR",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700)),
                              Container(
                                color: Colors.white,
                                height: 0.5,
                                width: MediaQuery.of(context).size.width / 3,
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () async {
                            showDialog(
                                context: context,
                                builder: (context) => SpinKitCircle(
                                      color: Colors.white, //Color(0xffE25E31),
                                      size: 50.0,
                                    ));
                            try {
                              final GoogleSignInAccount? googleSignInAccount =
                                  await _googleSignIn.signIn();
                              final GoogleSignInAuthentication
                                  googleSignInAuthentication =
                                  await googleSignInAccount!.authentication;
                              final AuthCredential credential =
                                  GoogleAuthProvider.credential(
                                accessToken:
                                    googleSignInAuthentication.accessToken,
                                idToken: googleSignInAuthentication.idToken,
                              );
                              await auth.signInWithCredential(credential);

                              FirebaseFirestore firebaseFirestore =
                                  FirebaseFirestore.instance;

                              User? user = auth.currentUser;
                              usermodel userModel = usermodel();

                              userModel.email = user!.email;
                              userModel.uid = user.uid;
                              userModel.name = user.displayName;
                              userModel.photo = user.photoURL;
                              userModel.location = "";
                              userModel.lan = "";
                              userModel.lon = "";

                              await firebaseFirestore
                                  .collection("Users")
                                  .doc(userModel.uid)
                                  .set(userModel.toMap());
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => GetLocation()));
                              showTopSnackBar(
                                context,
                                CustomSnackBar.success(
                                  message: "Account Created Successfully",
                                ),
                              );
                            } on FirebaseAuthException catch (e) {
                              showTopSnackBar(
                                context,
                                CustomSnackBar.error(
                                  message: e.message!,
                                ),
                              );

                              throw e;
                            }
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width / 1.2,
                            height: MediaQuery.of(context).size.width / 7,
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: Image.asset(
                                      'assets/images/G.png',
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 20,
                                  ),
                                  Text("Sign in with Google",
                                      style: TextStyle(
                                        color: Color(0xFF242424),
                                        fontSize: 18,
                                        // fontWeight: FontWeight.w700
                                      )),
                                ],
                              ),
                            ),
                            decoration: BoxDecoration(
                                color: Colors.white,
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
                      Text("Didn’t have an account?",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            // fontWeight: FontWeight.w700
                          )),
                      TextButton(
                          child: Text("Sign Up",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14)),
                          onPressed: (() {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => SignUp()));
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

  void reset(String email) async {
    await auth
        .sendPasswordResetEmail(email: email)
        .then((uid) => {
              Navigator.of(context).pop(),
              showTopSnackBar(
                context,
                CustomSnackBar.success(
                  backgroundColor: Colors.green,
                  message:
                      "Password Reset email send successfully.Check Your Inbox !",
                ),
              ),
              Navigator.of(context).pop(),
            })
        .catchError((e) {
      Navigator.of(context).pop();
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: e.message,
        ),
      );
    });
  }

  void signIn(String email, String password) async {
    await auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((uid) => {
              showTopSnackBar(
                context,
                CustomSnackBar.success(
                  backgroundColor: Colors.green,
                  message: "Login Successful",
                ),
              ),
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => GetLocation()))
            })
        .catchError((e) {
      Navigator.of(context).pop();
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: e.message,
        ),
      );
    });
  }
}
