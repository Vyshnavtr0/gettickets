import 'dart:convert';
import 'package:getickets/Screens/Trailer.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class MovieDetails extends StatefulWidget {
  final String image;
  final String titile;
  final String details;
  final String date;
  final String age;
  final int id;
  const MovieDetails(
      {Key? key,
      required this.date,
      required this.image,
      required this.age,
      required this.titile,
      required this.details,
      required this.id})
      : super(key: key);

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  var movie;
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
        Uri.parse(
            "https://api-gate2.movieglu.com/filmDetails/?film_id=${widget.id}"),
        headers: requestHeaders);

    final data = await json.decode(response.body);
    setState(() {
      movie = data;
    });
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
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.share_outlined)),
        ],
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_ios)),
      ),
      body: Column(
        children: [
          Expanded(
           // height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 1.8,
                      child: Stack(
                        children: [
                          Image.network(
                            widget.image,
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 1.8,
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: Column(
                              children: [
                                Container(
                                  height: MediaQuery.of(context).size.width / 3,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: [
                                          Colors.black,
                                          Colors.transparent
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        stops: [0.0, 1.0],
                                        tileMode: TileMode.clamp),
                                  ),
                                ),
                                Container(
                                  height: MediaQuery.of(context).size.width / 6,
                                  width: MediaQuery.of(context).size.width / 6,
                                  child: IconButton(
                                      color: Colors.redAccent,
                                      iconSize: 40,
                                      onPressed: () {
                                         Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Trailer(url: movie["trailers"]['high'][0]['film_trailer'].toString(),)
                            ));
                                      },
                                      icon: Icon(Icons.play_arrow)),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Colors.white.withOpacity(0.3)),
                                ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: MediaQuery.of(context).size.width / 1.2,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      Colors.black,
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    stops: [0.0, 1.0],
                                    tileMode: TileMode.clamp),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height / 3.6,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Center(
                                    child: Text(
                                      widget.titile,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: List<Widget>.generate(
                                          movie['genres'].length, (index) {
                                        return Container(
                                          margin:
                                              EdgeInsets.only(left: 8, right: 8),
                                          padding:
                                              EdgeInsets.only(left: 8, right: 8),
                                          decoration: BoxDecoration(
                                              border:
                                                  Border.all(color: Colors.white),
                                              borderRadius:
                                                  BorderRadius.circular(8)), //
                                          child: Text(
                                            movie['genres'][index]['genre_name']
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white),
                                          ),
                                        );
                                      })),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  '${widget.age} | ${widget.date}',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 8, right: 8),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.schedule,
                                                        color: Colors.white70,
                                                        size: 18,
                                                      ),
                                                      Text(
                                                        ' ${movie['duration_mins'].toString()} min',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      left: 8, right: 8),
                                                  padding: EdgeInsets.only(
                                                      left: 8, right: 8),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              2)), //
                                                  child: Text(
                                                    '2D',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Color(0xffC1121E)),
                                                  ),
                                                ),
                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                    children: List<
                                                            Widget>.generate(
                                                        movie['alternate_versions']
                                                            .length, (index) {
                                                      return Container(
                                                        margin: EdgeInsets.only(
                                                            left: 8, right: 8),
                                                        padding: EdgeInsets.only(
                                                            left: 8, right: 8),
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        2)), //
                                                        child: Text(
                                                          movie['alternate_versions']
                                                                      [index]
                                                                  ['version_type']
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color: Color(
                                                                  0xffC1121E)),
                                                        ),
                                                      );
                                                    })),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              ' ♥️ 71%',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              '4.8k ratings>',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              '1,403 reviews>',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              'Read what people are saying',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.white60,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          margin: EdgeInsets.all(8),
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                              border:
                                                  Border.all(color: Colors.white),
                                              borderRadius:
                                                  BorderRadius.circular(4)), //
                                          child: Text(
                                            "Write yours >",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Applicable Coupon",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                              size: 20,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Divider(
                      color: Colors.white60,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        "SUMMARY",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ReadMoreText(
                      widget.details.toString(),
                      trimLines: 3,
                      trimMode: TrimMode.Line,
                      style: TextStyle(fontSize: 11.5, color: Colors.white),
                      lessStyle:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      trimCollapsedText: 'Show more',
                      trimExpandedText: 'Show less',
                      moreStyle:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                  /*Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Crews & Casts",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                    'View all',
                    style: TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                          ],
                        ),
                       
                      ],
                    ),
                  ),*/
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: MediaQuery.of(context).size.width / 1.1,
              height: MediaQuery.of(context).size.width / 7,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.sell,color: Colors.white,),
                    Text("  Book Ticket",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              decoration: BoxDecoration(
                  color: Color(0xFFD70B17), //Colors.red,
                  borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }
}
