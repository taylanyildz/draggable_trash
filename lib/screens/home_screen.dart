import 'package:draggable_trash/widgets/draggable_to_trash.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({
    Key? key,
    this.title,
  }) : super(key: key);

  final String? title;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          DraggableTrash(
            trashAlignment: Alignment.bottomRight,
            pageAlignment: Alignment.center,
            actions: [
              Container(
                height: 200.0,
                width: 200.0,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
