import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:oppo/screens/Work.dart';
import 'screens/Explore.dart';
import 'screens/Settings.dart';
import 'screens/Pandemic.dart';

void main() async {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new DynamicTheme(
      defaultBrightness: Brightness.light,
      data: (brightness) =>
          new ThemeData(primarySwatch: Colors.blue, brightness: brightness),
      themedWidgetBuilder: (context, theme) {
        return new MaterialApp(home: Tabs(), theme: theme);
      },
    );
  }
}

class Tabs extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        bottomNavigationBar: TabBar(
          unselectedLabelColor: Colors.grey,
          labelColor: Theme.of(context).accentColor,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorPadding: EdgeInsets.all(5.0),
          tabs: [
            Tab(icon: Icon(Icons.explore_outlined),),
            Tab(icon: Icon(Icons.work_outline_rounded),),
            Tab(icon: Icon(Icons.favorite_border_sharp),),
            Tab(icon: Icon(Icons.flag),),
          ],
        ),
        appBar: AppBar(
          title: Text('Tabs Demo'),
          actions: [
            Container(margin: EdgeInsets.only(right: 20),child:GestureDetector(
              onTap: ((){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Settings()));
              }),
              child: Icon(Icons.settings_outlined),
            ) )

          ],
        ),
        body: TabBarView(
          children: [
            Explore(),
            WebViewExample(),
            Icon(Icons.directions_bike),
            PandemicLayout()
          ],
        ),
      ),
    );
  }
}

