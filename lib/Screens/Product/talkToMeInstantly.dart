import 'package:flutter/material.dart';
import 'package:kraapp/Screens/Constants/app_color.dart';

class TalkToMeInstantly extends StatefulWidget {
  const TalkToMeInstantly({super.key});

  @override
  _TalkToMeInstantlyState createState() => _TalkToMeInstantlyState();
}

class _TalkToMeInstantlyState extends State<TalkToMeInstantly> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.purple,
        title: Text(
          'KingResearch',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: AppColors.lightShadow),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              size: 25,
              color: AppColors.light,
            )),
      ),
      body: Column(
        children: [Text('some text ')],
      ),
    );
  }
}
