import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    String videoUrl = 'https://youtu.be/AM01sKA75As?si=IY4ylDEn7ViR3aeZ';

    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: YoutubePlayerBuilder(
            player: YoutubePlayer(
              controller: YoutubePlayerController(
                initialVideoId: YoutubePlayer.convertUrlToId(videoUrl) ?? '',
                flags: YoutubePlayerFlags(autoPlay: false),
              ),
            ),
            builder: (context, player) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  player,
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
