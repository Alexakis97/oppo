import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'speech/speech_playground.dart';
import 'screens/Explore.dart';
import 'screens/Settings.dart';
import 'screens/Pandemic.dart';
import 'blocs/provider.dart';
import 'screens/Work.dart';
import 'blocs/speechprovider.dart';

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
        return new MaterialApp(home: TabsDemo(), theme: theme);
      },
    );
  }
}
class TabsDemo extends StatefulWidget {

  @override
  _TabsDemoState createState() => _TabsDemoState();
}

class _TabsDemoState extends State<TabsDemo>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTabIndex);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabIndex);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabIndex() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Life Buddy'),
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
        ), //   floatingActionButton: _buildFloatingActionButton(context),
        bottomNavigationBar: TabBar(
          controller: _tabController,
          unselectedLabelColor: Colors.grey,
          labelColor: Theme.of(context).accentColor,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorPadding: EdgeInsets.all(5.0),
          tabs: [
            Tab(icon: Icon(Icons.explore_outlined),),
            Tab(icon: Icon(Icons.work_outline_rounded),),
            Tab(icon: Icon(Icons.favorite_border_sharp),),
            Tab(icon: Icon(Icons.coronavirus_outlined),),
          ],
        ),
        body: TabBarView(controller: _tabController, children: [
          Explore(),
          SpeechProvider(child: Work()),
          Icon(Icons.directions_bike),
          Provider(child: PandemicLayout())
        ]),
        floatingActionButton: _bottomButtons(context),
      ),
    );


  }



  Widget _bottomButtons(context1) {
    return _tabController.index == 1
        ? FloatingActionButton(
        onPressed: (){
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SpeechProvider(child:Speech())));},
        backgroundColor: DynamicTheme.of(context1).brightness == Brightness.dark ? Colors.white : Colors.redAccent,
        child: Icon(
          Icons.mic,
          size: 30.0,
        ))
        : null;
  }
}
