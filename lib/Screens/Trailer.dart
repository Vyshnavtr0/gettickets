import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class Trailer extends StatefulWidget {
  final String url;
  const Trailer({Key? key, required this.url}) : super(key: key);

  @override
  State<Trailer> createState() => _TrailerState();
}

class _TrailerState extends State<Trailer> {
//late VideoPlayerController _controller;
  late FlickManager flickManager;
  @override
  void initState() {
    // TODO: implement initState
    flickManager = FlickManager(
      autoPlay: true,
      onVideoEnd: () {
        Navigator.of(context).pop();
      },
      videoPlayerController: VideoPlayerController.network(
        widget.url,
      ),
    );

    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: FlickVideoPlayer(preferredDeviceOrientation: [
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ], preferredDeviceOrientationFullscreen: [
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ], flickManager: flickManager),
        ),
      ),
    );
  }
}
