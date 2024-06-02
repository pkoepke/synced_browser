import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';


// Construct a color from a hex code string, of the format #RRGGBB.
Color hexToColor(String code) {
  return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}

final Color dukeBlue = hexToColor('#001A57');
final Color cardBackground = hexToColor('#424242');
final Color greenHighlight = hexToColor('#17B468');
const double bodyFontSize = 18;
const double inputContentPadding = 8;

// Create a MaterialColor swatch from a single color.
// From https://medium.com/@filipvk/creating-a-custom-color-swatch-in-flutter-554bcdcb27f3
MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}

final dukeBlueMaterialColorSwatch = createMaterialColor(dukeBlue);

ThemeData darkTheme = ThemeData(
  scaffoldBackgroundColor: Colors.black,
  textTheme: darkTextTheme,
  cardColor: Colors.grey[900],
  highlightColor: Colors.grey[500],
  appBarTheme: AppBarTheme(
    color: dukeBlue,
    titleTextStyle: darkTextStyle,
    iconTheme: iconThemeData,
  ),
  colorScheme: ColorScheme.fromSwatch(primarySwatch: dukeBlueMaterialColorSwatch).copyWith(
    surface: Colors.grey[900],
    brightness: Brightness.dark,
  ),
);

IconThemeData iconThemeData = const IconThemeData(color: Colors.white);

TextTheme darkTextTheme = TextTheme(
  bodyMedium: darkTextStyle,
);

TextStyle darkTextStyle = const TextStyle(
  color: Colors.white,
  fontSize: bodyFontSize,
  fontFamily: "NotoSans",
);

TextSelectionThemeData darkThemeTextSelection = TextSelectionThemeData(
  cursorColor: Colors.white,
  selectionColor: Colors.grey[700],
  selectionHandleColor: Colors.white,
);

ThemeData lightTheme = ThemeData(
  scaffoldBackgroundColor: Colors.grey[200],
  textTheme: lightTextTheme,
  cardColor: Colors.white,
  highlightColor: Colors.grey[500],
  appBarTheme: AppBarTheme(
    color: dukeBlue,
    titleTextStyle: darkTextStyle,
    iconTheme: iconThemeData,
  ),
  colorScheme: ColorScheme.fromSwatch(primarySwatch: dukeBlueMaterialColorSwatch).copyWith(
    surface: Colors.white,
    brightness: Brightness.light,
  ),
);

TextTheme lightTextTheme = TextTheme(
  bodyMedium: lightTextStyle,
);

TextStyle lightTextStyle = const TextStyle(
  color: Colors.black,
  fontSize: bodyFontSize,
  backgroundColor: Colors.white,
  fontFamily: "NotoSans",
);

TextSelectionThemeData lightThemeTextSelection = const TextSelectionThemeData();

ThemeData currentTheme = darkTheme; // Start with dark theme by default.

void saveThemePref(String theme) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("theme", theme);
}

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: const WebViewApp(),
    ),
  );
}

class WebViewApp extends StatefulWidget {
  const WebViewApp({super.key});

  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..loadRequest(
        //Uri.parse('https://flutter.dev'),
        Uri.parse('https://paulkoepke.com'),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter WebView'),
      ),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}


/*void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Synced Browser',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
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
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}*/
