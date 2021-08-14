import 'package:create_atom/create_atom.dart';
import 'package:flutter/material.dart';

// Values ripped from https://github.com/Abhi011999/create_atom_flutter/blob/master/example/lib/main.dart
class AtomSplash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        child: Atom(
          size: 200.0,
          nucleusRadiusFactor: 1.0,
          orbitsWidthFactor: 1.0,
          orbit1Angle: 0.0,
          orbit2Angle: 1.047198,
          orbit3Angle: 5.235988,
          nucleusColor: Color(0xffffffff),
          orbitsColor: Color(0xffffffff),
          electronsColor: Color(0xffffffff),
          animDuration1: Duration(milliseconds: 1000),
          animDuration2: Duration(milliseconds: 2000),
          animDuration3: Duration(milliseconds: 3000),
        ),
      ),
    );
  }
}
