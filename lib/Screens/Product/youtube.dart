import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:kraapp/Screens/Constants/app_color.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../Models/Response/SingleProductResponse.dart';

class YoutubePlayerScreen extends StatefulWidget {
  final List<String> videoUrls;
  final ContentResponse? product;

  const YoutubePlayerScreen({
    required this.videoUrls,
    required this.product,
  });

  @override
  _YoutubePlayerScreenState createState() => _YoutubePlayerScreenState();
}

class _YoutubePlayerScreenState extends State<YoutubePlayerScreen> {
  late YoutubePlayerController _controller;
  bool isPlayerReady = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    _controller = YoutubePlayerController(
      initialVideoId:
          YoutubePlayer.convertUrlToId(widget.videoUrls.first) ?? '',
      flags: YoutubePlayerFlags(
        autoPlay: false,
      ),
    );
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.purple,
        title: Text(
          "King Research Academy",
          style: TextStyle(
            fontFamily: "poppins",
            fontWeight: FontWeight.w600,
            color: AppColors.lightShadow,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.lightShadow,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: widget.videoUrls.length,
        itemBuilder: (context, index) {
          return OrientationBuilder(builder: (context, orientation) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: double.infinity,
                  height: orientation == Orientation.portrait ? 250 : 150,
                  child: YoutubePlayer(
                    controller: _controller,
                    showVideoProgressIndicator: false,
                    aspectRatio: 16 / 9,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: AppColors.light,
                      border: Border(
                          bottom:
                              BorderSide(color: AppColors.cyan, width: 0.6))),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${widget.product?.Title ?? ""}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.dark,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${widget.product?.Description ?? ""}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          });
        },
      ),
    );
  }
}
