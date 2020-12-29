import 'package:flutter/material.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import '../constants.dart';
import '../speech/speech_playground.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: ListView(
        children: [DarkMode(), CustomInfo()],
      ),
    );
  }
}

class DarkMode extends StatefulWidget {
  @override
  _DarkMode createState() {
    return _DarkMode();
  }
}

class _DarkMode extends State<DarkMode> {
  static bool _value = false;
  final speech = Speech().createState();

  saveSharedPrefs(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("lang", value);
  }

  Future<String> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("lang");
  }

  @override
  Widget build(BuildContext context) {
    final future = getSharedPrefs();
    future.then((value) => {
          if (value == null)
            {speech.initSpeechState()}
          else
            {speech.reloadSpeechState(value)}
        });

    if (DynamicTheme.of(context).brightness == Brightness.dark) {
      _value = true;
    } else {
      _value = false;
    }
    return Card(
        margin: EdgeInsets.all(30),
        child: Column(
          children: [
            SwitchListTile(
                activeTrackColor: Colors.white,
                inactiveTrackColor: Colors.black87,
                title: Text('Dark mode'),
                secondary: Icon(Icons.dashboard_rounded),
                value: _value,
                onChanged: (value) {
                  setState(() {
                    _value = value;
                    _value
                        ? DynamicTheme.of(context)
                            .setBrightness(Brightness.dark)
                        : DynamicTheme.of(context)
                            .setBrightness(Brightness.light);
                  });
                }),
            ListTile(
              leading: Icon(Icons.mic),
              trailing: FlatButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        child: new AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Row(
                                children: [
                                  Icon(Icons.language,
                                      color:
                                          DynamicTheme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Colors.white
                                              : kTitleTextColor),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Select Language',
                                    style: TextStyle(fontSize: 20),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              DropdownButton(
                                isExpanded: true,
                                onChanged: (selectedVal) {
                                  //somehow call this function from the other widget
                                  setState(() {
                                    speech.switchLang(selectedVal);
                                  });

                                  print('changed!');
                                  saveSharedPrefs(selectedVal);

                                  Navigator.pop(context);
                                  final snackBar = SnackBar(
                                    content:
                                        Text('Language successfully changed'),
                                    action: SnackBarAction(
                                      label: 'Undo',
                                      onPressed: () {},
                                    ),
                                  );

                                  Scaffold.of(context).showSnackBar(snackBar);
                                },
                                value: speech.currentLocaleId,
                                items: speech.localeNames
                                    .map(
                                      (localeName) => DropdownMenuItem(
                                        value: localeName.localeId,
                                        child: Text(localeName.name),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ],
                          ),
                        ));
                  },
                  child: Text(
                    'Change',
                  )),
              title: Text(
                'Speech Detection',
              ),
              subtitle:
                  Text('Change Language', style: TextStyle(fontSize: 14.0)),
            ),
          ],
        ));
  }
}

class CustomInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      child: Card(
        child: ListTile(
          title: Text('View Legal Information'),
          subtitle: Text('All legal listed licenses.'),
        ),
      ),
      onTap: () => showAboutDialog(
          context: context,
          applicationIcon: Icon(Icons.map),
          applicationLegalese: 'SADASDA',
          applicationVersion: '1.0.1'),
    );
  }
}
