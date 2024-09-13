import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFf7f7f5),
      appBar: AppBar(
        title: Text("Hello"),
        backgroundColor: Colors.blue, // roy did not add appbar, custom
      ),
      body: Column(
        children: [
          Text("Hello world!")
        ],
      ),
    );
  }
}
