import 'package:chem_catalyst/routes.dart';
import 'package:chem_catalyst/util/app_info.dart';
import 'package:chem_catalyst/widget/atom_splash.dart';
import 'package:flutter/material.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Init.instance.initialize(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          // Without wrapping the splash in this stuff, some funky errors get thrown.
          // It's similar to https://stackoverflow.com/a/64507142/1687436
          return Directionality(
            textDirection: TextDirection.ltr,
            child: Navigator(
              onGenerateRoute: (settings) => MaterialPageRoute(
                builder: (context) => Container(
                  child: AtomSplash(),
                ),
              ),
            ),
          );
        } else {
          return MaterialApp(
            title: 'Chemistry Catalyst',
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
            ),
            routes: Routes.routes,
          );
        }
      },
    );
  }
}

// From https://github.com/jonbhanson/flutter_native_splash/blob/master/example/lib/main.dart
class Init {
  Init._();
  static final instance = Init._();

  Future initialize() async {
    // This is where you can initialize the resources needed by your app while
    // the splash screen is displayed.
    await AppInfo.instance.initialize();
    // Remove the following example because delaying the user experience is a bad design practice!
    // await Future.delayed(Duration(seconds: 3));
  }
}
