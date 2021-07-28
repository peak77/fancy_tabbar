import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(
        title: "12",
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      // bottomNavigationBar: FABBottomAppBar(
      //   centerItemText: '工作台',
      //   color: Colors.grey,
      //   backgroundColor: Colors.white,
      //   selectedColor: Colors.red,
      //   notchedShape: CircularOuterNotchedRectangle(),
      //   // onTabSelected: _onTapped,
      //   items: [
      //     FABBottomAppBarItem(iconData: Icons.home, text: '首页'),
      //     FABBottomAppBarItem(iconData: Icons.search, text: 'DSI'),
      //     FABBottomAppBarItem(iconData: Icons.account_circle, text: '设区'),
      //     FABBottomAppBarItem(iconData: Icons.more_horiz, text: '我的'),
      //   ],
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   child: Icon(Icons.add),
      //   elevation: 2.0,
      //   mini: true,
      // ),

      // bottomNavigationBar: Container(
      //   width: MediaQuery.of(context).size.width,
      //   height: 50 + math.max(MediaQuery.of(context).padding.bottom, 0.0),
      //   child: CustomPaint(
      //     painter: ConvexPainter(
      //       top: -20,
      //       width: 40,
      //       height: 42,
      //       color: Colors.white,
      //       shadowColor: Color(0xff999999).withAlpha(25),
      //       sigma: 6,
      //       leftPercent: const AlwaysStoppedAnimation<double>(0.5),
      //       textDirection: Directionality.of(context),
      //       cornerRadius: 0,
      //     ),
      //   ),
      // ),
      bottomNavigationBar: FancyBottomNavigation(
        tabs: [
          TabData(
            activeIcon: "assets/images/home_tab_selected.png",
            icon: "assets/images/home_tab_normal.png",
            title: "首页",
          ),
          TabData(
            activeIcon: "assets/images/dsi_tab_selected.png",
            icon: "assets/images/dsi_tab_normal.png",
            title: "搜索",
            onclick: () {},
          ),
          TabData(
            activeIcon: "assets/images/workbench_tab.png",
            icon: "assets/images/workbench_tab.png",
            title: "工作台",
            notched: true,
          ),
          TabData(
            activeIcon: "assets/images/social_tab_selected.png",
            icon: "assets/images/social_tab_normal.png",
            title: "消息",
            badge: '10',
          ),
          TabData(
            activeIcon: "assets/images/mine_tab_selected.png",
            icon: "assets/images/mine_tab_normal.png",
            title: "我的",
          ),
        ],
        initialSelection: 1,
        // needNotched: false,
        // key: bottomNavigationKey,
        barBackgroundColor: Colors.white,
        activeColor: Color(0xff4D91F7),
        color: Color(0xff999999),
        onTabChangedListener: (position, index) {
          setState(() {
            // currentPage = position;
          });
        },
      ),

      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
