import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getickets/Screens/Home.dart';
import 'package:getickets/Screens/Location.dart';
import 'package:getickets/Screens/Login.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:http/http.dart' as http;
class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  var nowmovie;
  var upmovie;
  var location = "";
    var lan = "";
    var lon = "";
    final auth = FirebaseAuth.instance;
    Future<void> nextscreen(ctx) async {
      if (auth.currentUser == null) {
        await Future.delayed(Duration(seconds: 3));
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => Login()));
      } else {
        final user = await FirebaseFirestore.instance
            .collection('Users')
            .doc(auth.currentUser!.uid)
            .get()
            .then((value) {
          setState(() {
            location = value.data()!['location'];
            lon = value.data()!['lon'];
            lan = value.data()!['lan'];
          });
        }).catchError((e) {
          showTopSnackBar(
            context,
            CustomSnackBar.error(
              message: e!.message,
            ),
          );
        });
        if (location != ''&& nowmovie !=null &&upmovie !=null) {

          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) => Home(nowmovie: nowmovie,upmovie: upmovie,)));
        } else {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => GetLocation()));
        }
      }
    }
  Map<String, String> requestHeaders = {
    "api-version": "v200",
    "Authorization": "Basic TVRJQ19YWDpIZ1Z5OE5jdllMQWM=",
    "x-api-key": "sofhDccQlo6JOnMjkQ1bd3WtQKtJrI4P9l8b8l9S",
    "device-datetime": "2022-05-27T07:44:13.167Z",
    "territory": "XX",
    "client": "MTIC"
  };
  Future<void> fetchMovie() async {
    final response = await http.get(
        Uri.parse("https://api-gate2.movieglu.com/filmsNowShowing/?n=5"),
        headers: requestHeaders);
        final response1 = await http.get(
        Uri.parse("https://api-gate2.movieglu.com/filmsComingSoon/?n=5"),
        headers: requestHeaders);


    final data = await json.decode(response.body);
    final data1 = await json.decode(response1.body);
    setState(() {
      nowmovie = data;
      upmovie = data1;
    });
    nextscreen(context);
  }
  @override
  void initState() {
    // TODO: implement initState
    fetchMovie();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    

    
    return Scaffold(
      //backgroundColor: Colors.black,
      body: Container(
        color: Colors.black,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Image.asset(
            "assets/images/logo.png",
            width: MediaQuery.of(context).size.width / 2.5,
            height: MediaQuery.of(context).size.height / 3,
          ),
        ),
      ),
    );
  }
}
