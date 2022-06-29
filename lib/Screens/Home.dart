
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:getickets/Screens/MovieDetails.dart';
import 'package:getickets/Screens/Trailer.dart';



class Home extends StatefulWidget {
  final dynamic nowmovie;
  final dynamic upmovie;
  const Home({Key? key, this.nowmovie,this.upmovie}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var nowmovie;
  var upmovie;
  
  List<Widget> _createChildren() {
    return new List<Widget>.generate(5, (int index) {
      return MovieSlider(
          context,
          nowmovie['films'][index]["film_name"].toString(),
          nowmovie['films'][index]['images']['poster']['1']['medium']
                  ["film_image"]
              .toString(),
          nowmovie['films'][index]['age_rating'][0]['rating'].toString(),
          nowmovie['films'][index]['release_dates'][0]['release_date']
              .toString(),
          nowmovie['films'][index]['synopsis_long'].toString(),index,nowmovie['films'][index]["film_id"]);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    //fetchMovie();
    setState(() {
      nowmovie = widget.nowmovie;
      upmovie = widget.upmovie;
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text(
                'Delhi/NCR',
                style: TextStyle(fontSize: 14),
              ),
              Icon(
                Icons.expand_more,
                size: 20,
                color: Colors.grey,
              )
            ],
          ),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          IconButton(
              onPressed: () {}, icon: Icon(Icons.notifications_outlined)),
        ],
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.sort)),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            ImageSlideshow(
              width: double.infinity,
              initialPage: 0,
              height: MediaQuery.of(context).size.height / 1.8,
              indicatorColor: Colors.white,
              indicatorBackgroundColor: Colors.grey,
              children: _createChildren(),
              onPageChanged: (value) {
                print('Page changed: $value');
              },
              autoPlayInterval: 8000,
              isLoop: true,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'NOW Showing',
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
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width / 1.8,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Moviecard(
                      context,
                      nowmovie['films'][index]["film_name"].toString(),
                      nowmovie['films'][index]['images']['poster']['1']
                              ['medium']["film_image"]
                          .toString(),
                    );
                  },
                  itemCount: 5,
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'UPCOMING MOVIES',
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
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width / 1.8,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Moviecard(
                      context,
                      upmovie['films'][index]["film_name"].toString(),
                      upmovie['films'][index]['images']['poster']['1']
                              ['medium']["film_image"]
                          .toString(),
                    );
                  },
                  itemCount: 1,
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget MovieSlider(
    BuildContext context,
    String title,
    String images,
    String age,
    String date,
    String details,
    int  index,
    int  id,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 2.2,
        child: Stack(
          children: [
            Image.network(
              images,
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.6,
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: MediaQuery.of(context).size.width / 2.5,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.black, Colors.transparent],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.width / 1.4,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black,
                        Colors.black,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.0, 0.6, 1.0],
                      tileMode: TileMode.clamp),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 3.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Center(
                      child: Text(
                        title.length >= 20
                            ? "${title.substring(0, 20)}.."
                            : title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: Text(
                        details.length >= 100
                            ? "${details.substring(0, 100)}..."
                            : details,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      '$age | $date',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: (() {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Trailer(url: nowmovie['films'][index]["film_trailer"].toString(),)
                            ));
                          }),
                          child: Container(
                            width: MediaQuery.of(context).size.width / 2.5,
                            height: MediaQuery.of(context).size.width / 8,
                            child: Center(
                              child: Text("WATCH TRAILER",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700)),
                            ),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                color: Colors.transparent, //Colors.red,
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                        GestureDetector(
                          onTap: (() {
                             Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => MovieDetails(date: date, image: images, age: age, titile: title,id: id,details: details,)));
                          }),
                          child: Container(
                            width: MediaQuery.of(context).size.width / 2.5,
                            height: MediaQuery.of(context).size.width / 8,
                            child: Center(
                              child: Text("BOOK NOW",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700)),
                            ),
                            decoration: BoxDecoration(
                                color: Color(0xFFD70B17), //Colors.red,
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Know more>>',
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding Moviecard(
    BuildContext context,
    String title,
    String images,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 3,
        height: MediaQuery.of(context).size.width / 2.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                images,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width / 3,
                height: MediaQuery.of(context).size.width / 2.5,
              ),
            ),
            Text(
              title,
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
