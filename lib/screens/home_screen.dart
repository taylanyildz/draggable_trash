import 'package:draggable_trash/widgets/draggable_trash_action_pane.dart';
import 'package:draggable_trash/widgets/widgets.dart';
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
      body: Center(
        child: Stack(
          children: [
            DraggableTrash.builder(
              alignment: Alignment.center,
              child: Container(
                height: 200.0,
                width: 200.0,
                color: Colors.red,
              ),
              actionPane: DraggableTrashActionPane(),
              actionDelegate: DragTrashActionBuilderDelegate(
                  actionCount: 1,
                  builder: (context, index, animation) {
                    print('index : $index');
                    return DragTrasAction(
                      alignment: Alignment.center,
                      child: Container(
                        width: 400.0,
                        height: 400.0,
                        color: Colors.black,
                      ),
                      index: index,
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
