import 'package:flutter/material.dart';
import 'package:flutter_drag_to_trash/widgets/draggable_trash.dart';

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DraggableTrash.builder(
              items: [],
              actionDelegate: DragTrashActionBuilderDelegate(
                actionCount: 2,
                builder: (context, index, animation) => Container(
                  height: 200.0,
                  width: 200.0,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
