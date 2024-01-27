import 'package:flutter/material.dart';
import 'package:kraapp/Screens/Constants/app_color.dart';

class OopsScreen extends StatefulWidget {
  const OopsScreen({Key? key}) : super(key: key);

  @override
  State<OopsScreen> createState() => _OopsScreenState();
}

class _OopsScreenState extends State<OopsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.light,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                'https://th.bing.com/th/id/OIP.Q-aZyzPolZdXdbvAh58ikAHaHa?w=186&h=186&c=7&r=0&o=5&dpr=1.8&pid=1.7',
                scale: 2,
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Something went wrong.\nDon\'t worry let\'s try again.',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
