import 'package:flutter/material.dart';
import 'package:startup_namer/layoutpractice.dart';
import 'package:startup_namer/qrscanner.dart';
import 'listviewfavourite.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Welcome to Flutter',
        theme: ThemeData(
          primaryColor: Colors.blue[200],
        ),
        home: HomeScreen());
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Widget Practice")),
      body: Container(
        child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 45.0),
            child: ListView(children: <Widget>[
              ElevatedButton(
                onPressed: _pressListView,
                child: (Text(
                  'ListView',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                )),
              ),
              ElevatedButton(
                onPressed: _pressedLayout,
                child: (Text(
                  'Layout Practice',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                )),
              ),
              ElevatedButton(
                onPressed: _pressQRView,
                child: (Text(
                  'QR Scan',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                )),
              ),
            ])),
      ),
    );
  }

  void _pressListView() {
    debugPrint('List View Example pressed');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RandomWords()),
    );
  }

  void _pressedLayout() {
    Navigator.of(context).push(_layoutPracticeRoute());
  }

  void _pressQRView() {
    debugPrint('QR View pressed');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QRScan()),
    );
  }

  Route _layoutPracticeRoute() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            LayoutPractice(),
        transitionDuration: Duration(milliseconds: 2000),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.ease;
          final tween = Tween(begin: begin, end: end);
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: curve,
          );

          return SlideTransition(
            position: tween.animate(curvedAnimation),
            child: child,
          );
        });
    /*transitionsBuilder: (context, animation, anotherAnimation, child) {
          animation =
              CurvedAnimation(curve: Curves.easeInQuad, parent: animation);
          return Align(
            child: SizeTransition(
              sizeFactor: animation,
              child: child,
              axisAlignment: 0.0,
            ),
          );
        });*/
  }
}
