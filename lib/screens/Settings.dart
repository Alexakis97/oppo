import 'package:flutter/material.dart';
import 'package:dynamic_theme/dynamic_theme.dart';


class Settings extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    // TODO: implement build



    return  Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body:  ListView(
            children: [
              DarkMode(),
              CustomInfo()
            ],
          ),
    );
  }
  }


class DarkMode extends StatefulWidget{
  @override
  _DarkMode createState() {
    return _DarkMode();
  }

}

class _DarkMode extends State<DarkMode> {

  static bool _value = false;

  @override
  Widget build(BuildContext context) {
  if(DynamicTheme.of(context).brightness == Brightness.dark)
    {
      _value = true;
    }else{
    _value = false;
  }
    return
      Card(
        margin: EdgeInsets.all(30),
        child:SwitchListTile(
            activeTrackColor: Colors.white,
            inactiveTrackColor: Colors.black87,
            title: Text('Dark mode'),
            secondary: Icon(Icons.dashboard_rounded),
            value: _value, onChanged:
            (value)  {
          setState(()  {
            _value = value;
            _value ? DynamicTheme.of(context).setBrightness(Brightness.dark) : DynamicTheme.of(context).setBrightness(Brightness.light);
          });
        }
        ) ,
      );

  }
}

class CustomInfo extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  GestureDetector(
        child: Card(
          child: ListTile(
            title: Text('View Legal Information'),
            subtitle: Text(
                'All legal listed licenses.'
            ),

          ),
        ),
        onTap: ()=> showAboutDialog(
            context: context,
          applicationIcon: Icon(Icons.map),
          applicationLegalese: 'SADASDA',
          applicationVersion: '1.0.1'
        ),
      );
  }

}
