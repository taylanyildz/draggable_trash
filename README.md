# draggable_trash

Just move the items you want to delete onto the trash can, now they've been deleted.



Not yet ready!.


```dart
DraggableTrash.builder(
    items: [
    Container(
        height: 200.0,
        width: 200.0,
        color: Colors.blue,
      ),
    ],
    actionDelegate: DragTrashActionBuilderDelegate(
    actionCount: 2,
    builder: (context, index, animation) {
        return Container(
        height: 200.0,
        width: 200.0,
        color: Colors.blue,
        );
    },
  ),
),
```

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
