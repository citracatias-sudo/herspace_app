import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ArticlesScreen extends StatelessWidget {
  const ArticlesScreen({super.key});

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Articles")),
      body: Center(
        child:
        Lottie.asset("assets/lottie_animations/Coming soon.json"),
      ),
    );
  }
}
