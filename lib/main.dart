import 'package:chatting/screen/main_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(const ChattingApplication());

class ChattingApplication extends StatelessWidget {
  const ChattingApplication({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
      theme: ThemeData(
          textTheme: Theme.of(context).textTheme.copyWith(
              headline3: Theme.of(context).textTheme.headline3?.copyWith(
                    color: Colors.white,
                  ),
              headline4: Theme.of(context).textTheme.headline4?.copyWith(
                    color: Colors.white,
                  ))),
    );
  }
}
