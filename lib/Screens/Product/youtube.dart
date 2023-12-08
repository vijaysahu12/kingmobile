import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:kraapp/Screens/Constants/app_color.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePlayerScreen extends StatelessWidget {
  final List<String> videoUrls;

  const YoutubePlayerScreen({required this.videoUrls});

  @override
  Widget build(BuildContext context) {
    FlutterWindowManager.addFlags(FlutterWindowManager
        .FLAG_SECURE); // stop screenShot option(avoid screenShot option)
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.purple,
        title: Text(
          "King Research Acdamey",
          style: TextStyle(
              fontFamily: "poppins",
              fontWeight: FontWeight.w600,
              color: AppColors.lightShadow),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.lightShadow,
            )),
      ),
      body: ListView.builder(
        itemCount: videoUrls.length,
        itemBuilder: (context, index) {
          return YoutubePlayerBuilder(
            player: YoutubePlayer(
              controller: YoutubePlayerController(
                initialVideoId:
                    YoutubePlayer.convertUrlToId(videoUrls[index]) ?? '',
                flags: YoutubePlayerFlags(autoPlay: false),
              ),
            ),
            builder: (context, player) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: player,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Video ${index + 1}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              );
            },
          );
        },
      ),
    );
  }
}