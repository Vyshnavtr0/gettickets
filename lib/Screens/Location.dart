import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart' as geocode;
import 'package:getickets/Screens/Home.dart';
import 'package:location/location.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class GetLocation extends StatefulWidget {
  const GetLocation({Key? key}) : super(key: key);

  @override
  State<GetLocation> createState() => _GetLocationState();
}

class _GetLocationState extends State<GetLocation> {
  List cities = [];
  List results = [];
  var location1 = "";
  bool loading = false;
  final auth = FirebaseAuth.instance;
  bool visible = true;
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  final search_controller = TextEditingController();
  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/cities.json');
    final data = await json.decode(response);
    setState(() {
      cities = data["items"];
      results = cities
          .where((elem) =>
              elem["name"]
                  .toString()
                  .toLowerCase()
                  .contains(search_controller.text.toLowerCase()) ||
              elem['state']
                  .toString()
                  .toLowerCase()
                  .contains(search_controller.text.toLowerCase()))
          .toList();
    });
  }

  Future<dynamic> _determinePosition() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();

    var addresses = await geocode.placemarkFromCoordinates(
      _locationData.latitude!,
      _locationData.longitude!,
    );
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    await firebaseFirestore
        .collection("Users")
        .doc(auth.currentUser!.uid)
        .update({
      'lan': _locationData.latitude.toString(),
      'lon': _locationData.longitude.toString(),
      'location': "${addresses.first.locality}"
    });
    setState(() {
      location1 = "${addresses.first.locality}";
    });
    _btnController.success();
    await Future.delayed(Duration(seconds: 1));
    showTopSnackBar(
      context,
      CustomSnackBar.success(
        backgroundColor: Colors.green,
        message: "Your Location is Updated to $location1",
      ),
    );

    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => Home()));

    return;
  }

  @override
  void initState() {
    // TODO: implement initState
    readJson();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 58,
              color: Colors.white,
              child: ListTile(
                  trailing: Visibility(
                    visible: search_controller.text != "" ? true : false,
                    child: IconButton(
                        color: Colors.black.withOpacity(0.5),
                        onPressed: () {
                          search_controller.clear();

                          setState(() {
                            visible = true;
                            results = cities
                                .where((elem) =>
                                    elem["name"]
                                        .toString()
                                        .toLowerCase()
                                        .contains(search_controller.text
                                            .toLowerCase()) ||
                                    elem['state']
                                        .toString()
                                        .toLowerCase()
                                        .contains(search_controller.text
                                            .toLowerCase()))
                                .toList();
                          });
                        },
                        icon: Icon(Icons.clear)),
                  ),
                  title: TextField(
                    keyboardType: TextInputType.text,
                    cursorColor: Color(0xFFD70B17),
                    controller: search_controller,
                    onChanged: (str) {
                      setState(() {
                        visible = false;
                        results = cities
                            .where((elem) =>
                                elem["name"].toString().toLowerCase().contains(
                                    search_controller.text.toLowerCase()) ||
                                elem['state'].toString().toLowerCase().contains(
                                    search_controller.text.toLowerCase()))
                            .toList();
                        if (str == "") {
                          visible = true;
                        }
                      });
                    },
                    decoration: InputDecoration(
                        hintText: "Search for your city",
                        hintStyle:
                            TextStyle(color: Color(0xffA7A7A7), fontSize: 18),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(8),
                        )),
                  ),
                  leading: IconButton(
                      color: Colors.black,
                      onPressed: () {},
                      icon: Icon(Icons.arrow_back_ios))),
            ),
            Visibility(
              visible: loading,
              child: LinearProgressIndicator(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton.icon(
                      onPressed: () {
                        showMaterialModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder: (context) => Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 2,
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(28),
                                    topRight: Radius.circular(28))),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ListTile(
                                  trailing: Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Color(0xFF707070).withOpacity(0.2),
                                    ),
                                    child: IconButton(
                                        onPressed: (() {
                                          Navigator.of(context).pop();
                                        }),
                                        icon: Icon(
                                          Icons.close,
                                          color: Color(0xFF707070)
                                              .withOpacity(0.7),
                                          size: 20,
                                        )),
                                  ),
                                  title: Text(
                                    "Enable Location",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Color(0xff222222),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Divider(),
                                Image.asset(
                                  'assets/images/location.png',
                                  fit: BoxFit.cover,
                                  width:
                                      MediaQuery.of(context).size.width / 1.5,
                                  height: MediaQuery.of(context).size.width / 3,
                                ),
                                Text(
                                  "Enable your location",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color(0xff222222),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "Turn on your mobile location to fetch your\n Location details",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Color(0xff999999),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                RoundedLoadingButton(
                                  child: Text('Turn on location',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16)),
                                  controller: _btnController,
                                  borderRadius: 8,
                                  successColor: Colors.green,
                                  color: Color(0xFFD70B17),
                                  onPressed: () {
                                    _determinePosition();
                                  },
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      icon: Icon(Icons.my_location, color: Color(0xff2FAFFF)),
                      label: Text("Current Location",
                          style: TextStyle(
                              color: Color(0xff2FAFFF), fontSize: 18)))
                ],
              ),
            ),
            Container(
              color: Colors.grey,
              height: 0.5,
              width: MediaQuery.of(context).size.width,
            ),
            Visibility(
              visible: visible,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("POPULAR CITIES",
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
            Visibility(
              visible: visible,
              child: Container(
                  child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          setState(() {
                          loading = true;
                        });
                        var loc = await geocode.locationFromAddress("Gujarat,Ahmedabad");

                        FirebaseFirestore firebaseFirestore =
                            FirebaseFirestore.instance;
                        await firebaseFirestore
                            .collection("Users")
                            .doc(auth.currentUser!.uid)
                            .update({
                          'lan': loc.first.latitude.toString(),
                          'lon': loc.first.longitude.toString(),
                          'location': 'Ahmedabad'
                        });
                        setState(() {
                          loading = false;
                        });
                        //await Future.delayed(Duration(seconds: 1));
                        showTopSnackBar(
                          context,
                          CustomSnackBar.success(
                            backgroundColor: Colors.green,
                            message:
                                "Your Location is Updated to Ahmedabad",
                          ),
                        );
                         Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => Home()));
        },
                        child: SizedBox(
                          height: 100,
                          width: 70,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  color: Colors.grey.withOpacity(0.2),
                                  child: Image.network(
                                    'https://res.cloudinary.com/dvhlfyvrr/image/upload/c_scale,w_150/v1652029429/sidi-bashir-mosque-in-ahmedabad-1322198135-18dddfc8f76e4a2f8cbce7d522ad4cb7_b3n2lm.jpg',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Text("Ahmedabad",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12)),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                         onTap: () async {
                          setState(() {
                          loading = true;
                        });
                        var loc = await geocode.locationFromAddress("Karnataka,Bengaluru");

                        FirebaseFirestore firebaseFirestore =
                            FirebaseFirestore.instance;
                        await firebaseFirestore
                            .collection("Users")
                            .doc(auth.currentUser!.uid)
                            .update({
                          'lan': loc.first.latitude.toString(),
                          'lon': loc.first.longitude.toString(),
                          'location': 'Bengaluru'
                        });
                        setState(() {
                          loading = false;
                        });
                        //await Future.delayed(Duration(seconds: 1));
                        showTopSnackBar(
                          context,
                          CustomSnackBar.success(
                            backgroundColor: Colors.green,
                            message:
                                "Your Location is Updated to Bengaluru",
                          ),
                        );
                         Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => Home()));
        },
                        child: SizedBox(
                          height: 100,
                          width: 70,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  color: Colors.grey.withOpacity(0.2),
                                  child: Image.network(
                                    'https://res.cloudinary.com/dvhlfyvrr/image/upload/c_scale,w_150/v1652030084/9483508eeee2b78a7356a15ed9c337a1-bengaluru-bangalore_yzhz3r.jpg',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Text("Bengaluru",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12)),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                         onTap: () async {
                          setState(() {
                          loading = true;
                        });
                        var loc = await geocode.locationFromAddress("Delhi,Delhi/NCR");

                        FirebaseFirestore firebaseFirestore =
                            FirebaseFirestore.instance;
                        await firebaseFirestore
                            .collection("Users")
                            .doc(auth.currentUser!.uid)
                            .update({
                          'lan': loc.first.latitude.toString(),
                          'lon': loc.first.longitude.toString(),
                          'location': 'Delhi/NCR'
                        });
                        setState(() {
                          loading = false;
                        });
                        //await Future.delayed(Duration(seconds: 1));
                        showTopSnackBar(
                          context,
                          CustomSnackBar.success(
                            backgroundColor: Colors.green,
                            message:
                                "Your Location is Updated to Delhi/NCR",
                          ),
                        );
                         Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => Home()));
        },
                        child: SizedBox(
                          height: 100,
                          width: 70,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  color: Colors.grey.withOpacity(0.2),
                                  child: Image.network(
                                    'https://res.cloudinary.com/dvhlfyvrr/image/upload/c_scale,w_150/v1652030229/top-10-places-to-live-in-delhi-ncr_vpxxsi.jpg',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Text("Delhi/NCR",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12)),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          setState(() {
                          loading = true;
                        });
                        var loc = await geocode.locationFromAddress("Telangana,Hyderabad");

                        FirebaseFirestore firebaseFirestore =
                            FirebaseFirestore.instance;
                        await firebaseFirestore
                            .collection("Users")
                            .doc(auth.currentUser!.uid)
                            .update({
                          'lan': loc.first.latitude.toString(),
                          'lon': loc.first.longitude.toString(),
                          'location': 'Hyderabad'
                        });
                        setState(() {
                          loading = false;
                        });
                        //await Future.delayed(Duration(seconds: 1));
                        showTopSnackBar(
                          context,
                          CustomSnackBar.success(
                            backgroundColor: Colors.green,
                            message:
                                "Your Location is Updated to Hyderabad",
                          ),
                        );
                         Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => Home()));
        },
                        child: SizedBox(
                          height: 100,
                          width: 70,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  color: Colors.grey.withOpacity(0.2),
                                  child: Image.network(
                                    'https://res.cloudinary.com/dvhlfyvrr/image/upload/c_scale,w_150/v1652030311/download_v2fsz7.jpg',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Text("Hyderabad",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12)),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          setState(() {
                          loading = true;
                        });
                        var loc = await geocode.locationFromAddress("West Bengal,Kolkata");

                        FirebaseFirestore firebaseFirestore =
                            FirebaseFirestore.instance;
                        await firebaseFirestore
                            .collection("Users")
                            .doc(auth.currentUser!.uid)
                            .update({
                          'lan': loc.first.latitude.toString(),
                          'lon': loc.first.longitude.toString(),
                          'location': 'Kolkata'
                        });
                        setState(() {
                          loading = false;
                        });
                        //await Future.delayed(Duration(seconds: 1));
                        showTopSnackBar(
                          context,
                          CustomSnackBar.success(
                            backgroundColor: Colors.green,
                            message:
                                "Your Location is Updated to Kolkata",
                          ),
                        );
                         Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => Home()));
        },
                        child: SizedBox(
                          height: 100,
                          width: 70,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  color: Colors.grey.withOpacity(0.2),
                                  child: Image.network(
                                    'https://res.cloudinary.com/dvhlfyvrr/image/upload/c_scale,w_150/v1652030432/Victoria-Statue-front-Memorial-Hall-Kolkata-West_ygjc1z.jpg',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Text("Kolkata",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12)),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          setState(() {
                          loading = true;
                        });
                        var loc = await geocode.locationFromAddress("Maharashtra,Mumbai");

                        FirebaseFirestore firebaseFirestore =
                            FirebaseFirestore.instance;
                        await firebaseFirestore
                            .collection("Users")
                            .doc(auth.currentUser!.uid)
                            .update({
                          'lan': loc.first.latitude.toString(),
                          'lon': loc.first.longitude.toString(),
                          'location': 'Mumbai'
                        });
                        setState(() {
                          loading = false;
                        });
                        //await Future.delayed(Duration(seconds: 1));
                        showTopSnackBar(
                          context,
                          CustomSnackBar.success(
                            backgroundColor: Colors.green,
                            message:
                                "Your Location is Updated to Mumbai",
                          ),
                        );
                         Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => Home()));
        },
                        child: SizedBox(
                          height: 100,
                          width: 70,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  color: Colors.grey.withOpacity(0.2),
                                  child: Image.network(
                                    'https://res.cloudinary.com/dvhlfyvrr/image/upload/c_scale,w_150/v1652030536/download_1_xi96e1.jpg',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Text("Mumbai",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12)),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                         onTap: () async {
                          setState(() {
                          loading = true;
                        });
                        var loc = await geocode.locationFromAddress("Maharashtra,Pune");

                        FirebaseFirestore firebaseFirestore =
                            FirebaseFirestore.instance;
                        await firebaseFirestore
                            .collection("Users")
                            .doc(auth.currentUser!.uid)
                            .update({
                          'lan': loc.first.latitude.toString(),
                          'lon': loc.first.longitude.toString(),
                          'location': 'Pune'
                        });
                        setState(() {
                          loading = false;
                        });
                        //await Future.delayed(Duration(seconds: 1));
                        showTopSnackBar(
                          context,
                          CustomSnackBar.success(
                            backgroundColor: Colors.green,
                            message:
                                "Your Location is Updated to Pune",
                          ),
                        );
                         Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => Home()));
        },
                        child: SizedBox(
                          height: 100,
                          width: 70,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  color: Colors.grey.withOpacity(0.2),
                                  child: Image.network(
                                    'https://res.cloudinary.com/dvhlfyvrr/image/upload/c_scale,w_150/v1652030637/GettyImages-521733846_Darkroom-125adbb08a044a2db915fefc1eb741b2_ysvrpc.jpg',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Text("Pune",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12)),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          setState(() {
                          loading = true;
                        });
                        var loc = await geocode.locationFromAddress("Tamil Nadu,Chennai");

                        FirebaseFirestore firebaseFirestore =
                            FirebaseFirestore.instance;
                        await firebaseFirestore
                            .collection("Users")
                            .doc(auth.currentUser!.uid)
                            .update({
                          'lan': loc.first.latitude.toString(),
                          'lon': loc.first.longitude.toString(),
                          'location': 'Chennai'
                        });
                        setState(() {
                          loading = false;
                        });
                        //await Future.delayed(Duration(seconds: 1));
                        showTopSnackBar(
                          context,
                          CustomSnackBar.success(
                            backgroundColor: Colors.green,
                            message:
                                "Your Location is Updated to Chennai",
                          ),
                        );
                         Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => Home()));
                        },
                        child: SizedBox(
                          height: 100,
                          width: 70,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  color: Colors.grey.withOpacity(0.2),
                                  child: Image.network(
                                    'https://res.cloudinary.com/dvhlfyvrr/image/upload/c_scale,w_150/v1652030051/Chennai_-_bird_s-eye_view_lfnthj.jpg',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Text("Chennai",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12)),
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                ],
              )),
            ),
            Visibility(
              visible: visible,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("OTHER CITIES",
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.separated(
                  physics: BouncingScrollPhysics(),
                  separatorBuilder: ((context, index) {
                    return Container(
                      color: Colors.grey,
                      height: 0.5,
                      width: MediaQuery.of(context).size.width,
                    );
                  }),
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () async {
                        setState(() {
                          loading = true;
                        });
                        var loc = await geocode.locationFromAddress(
                            "${results[index]["state"]},${results[index]["name"]}");

                        FirebaseFirestore firebaseFirestore =
                            FirebaseFirestore.instance;
                        await firebaseFirestore
                            .collection("Users")
                            .doc(auth.currentUser!.uid)
                            .update({
                          'lan': loc.first.latitude.toString(),
                          'lon': loc.first.longitude.toString(),
                          'location': results[index]["name"].toString()
                        });
                        setState(() {
                          loading = false;
                        });
                        //await Future.delayed(Duration(seconds: 1));
                        showTopSnackBar(
                          context,
                          CustomSnackBar.success(
                            backgroundColor: Colors.green,
                            message:
                                "Your Location is Updated to ${results[index]["name"].toString()}",
                          ),
                        );

                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => Home()));
                      },
                      textColor: Colors.white,
                      title: Text(results[index]["name"],
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      subtitle: Text(results[index]["state"],
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 14)),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
