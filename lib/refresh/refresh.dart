import 'package:flutter/material.dart';
import '../blocs/bloc.dart';

class Refresh extends StatelessWidget {
  final Widget child;
  final String country;

  const Refresh({this.child, this.country});

  @override
  Widget build(BuildContext context) {
    final bloc = Bloc();
    // TODO: implement build
    return RefreshIndicator(
        child: child,
        onRefresh: () async {
          await bloc.addCountryStream(country);
        });
  }
  //async await combination returns future
}
