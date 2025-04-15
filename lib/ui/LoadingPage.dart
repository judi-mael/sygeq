import 'package:flutter/material.dart';
import 'package:sygeq/main.dart';
import 'package:sygeq/ui/LoadingAnimationData.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: white,
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.only(
              top:
                  _size.height > _size.width
                      ? _size.height / 3.5
                      : _size.width / 5.5,
            ),
            child: Column(
              children: [
                Image(
                  height: _size.height / 7,
                  width: _size.width / 4,
                  image: AssetImage('assets/Images/default_image.png'),
                ),
                Text(
                  'SyGeQ',
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                  ),
                ),
                SizedBox(height: 5),
                animateLoadinPage(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
