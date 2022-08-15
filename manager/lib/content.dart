import 'package:flutter/material.dart';
import 'package:manager/vision/vision_widget.dart';

class ContentWidget extends StatefulWidget {
  const ContentWidget({Key? key}) : super(key: key);

  @override
  State<ContentWidget> createState() => _ContentWidgetState();
}

class _ContentWidgetState extends State<ContentWidget> {
  int selectedIndex = 0;

  static const List<Widget> _widgets = <Widget>[
    VisionWidget(),
    VisionWidget(),
    VisionWidget(),
    // const Text('1'),
    // const Text('2'),
    // const Text('3'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgets.elementAt(selectedIndex),
      appBar: AppBar(
        title: const Text("Mediscara Manager"),
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.visibility),
            label: 'Vision',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.apartment),
            label: 'Industrial',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.print),
            label: 'Marking',
          ),
        ],
        onTap: _onItemTapped,
        currentIndex: selectedIndex,
      ),
    );
  }
}
