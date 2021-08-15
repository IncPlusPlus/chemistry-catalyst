import 'package:chem_catalyst/routes.dart';
import 'package:chem_catalyst/util/app_info.dart';
import 'package:chem_catalyst/widgets.dart';
import 'package:flutter/material.dart';

/// The widget just below the root widget. This would go in main.dart
/// except hot reloading was causing the FutureBuilder to run again.
/// Resolved with this godsend of an answer:
/// https://stackoverflow.com/a/57793517/1687436
class ChemCatalyst extends StatefulWidget {
  @override
  _ChemCatalystState createState() => _ChemCatalystState();
}

class _ChemCatalystState extends State<ChemCatalyst> {
  late Future initializationFuture;

  @override
  void initState() {
    super.initState();
    // Assign the future before its use in FutureBuilder
    initializationFuture = Init.instance.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initializationFuture,
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
