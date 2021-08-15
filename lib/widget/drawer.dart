import 'package:chem_catalyst/screens.dart';
import 'package:chem_catalyst/util/app_info.dart';
import 'package:chem_catalyst/screens/grams_moles.dart';
import 'package:flutter/material.dart';

/// The app's drawer.
/// Created following https://medium.com/flutter-community/flutter-vi-navigation-drawer-flutter-1-0-3a05e09b0db9
class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Padding(padding: EdgeInsets.all(14)),
          // _createHeader(),
          _createDrawerItem(
            icon: Icons.home,
            text: 'Home',
            onTap: () =>
                Navigator.pushReplacementNamed(context, HomePage.routeName),
          ),
          _createDrawerItem(
            icon: Icons.workspaces_filled,
            text: 'Molar Mass',
            onTap: () =>
                Navigator.pushReplacementNamed(context, MolarMass.routeName),
          ),
          _createDrawerItem(
            icon: Icons.apps,
            text: 'Grams <-> Moles',
            onTap: () => Navigator.pushReplacementNamed(
                context, GramsMolesCalculator.routeName),
          ),
          _createDrawerItem(
            icon: Icons.note,
            text: 'Notes',
            onTap: () =>
                Navigator.pushReplacementNamed(context, TextScreen.routeName),
          ),
          // Divider(),
          // _createDrawerItem(icon: Icons.collections_bookmark, text: 'Steps'),
          // _createDrawerItem(icon: Icons.face, text: 'Authors'),
          // _createDrawerItem(icon: Icons.account_box, text: 'Flutter Documentation'),
          // _createDrawerItem(icon: Icons.stars, text: 'Useful Links'),
          Divider(),
          _createDrawerItem(icon: Icons.bug_report, text: 'Report an issue'),
          ListTile(
            title: Text(AppInfo.instance.version),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  // Widget _createHeader() {
  //   return DrawerHeader(
  //       margin: EdgeInsets.zero,
  //       padding: EdgeInsets.zero,
  //       decoration: BoxDecoration(
  //           image: DecorationImage(
  //               fit: BoxFit.fill,
  //               image:  AssetImage('path/to/header_background.png'))),
  //       child: Stack(children: <Widget>[
  //         Positioned(
  //             bottom: 12.0,
  //             left: 16.0,
  //             child: Text("Flutter Step-by-Step",
  //                 style: TextStyle(
  //                     color: Colors.white,
  //                     fontSize: 20.0,
  //                     fontWeight: FontWeight.w500))),
  //       ]));
  // }

  Widget _createDrawerItem(
      {IconData? icon, required String text, GestureTapCallback? onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}
