import 'package:flutter/material.dart';

class NotificationSetting {
  String title;
  bool value;

  NotificationSetting({
    @required this.title,
    this.value = false,
  });
}


class Checkbox1 extends StatefulWidget {
  @override
  _Checkbox1State createState() => _Checkbox1State();
}

class _Checkbox1State extends State<Checkbox1> {

  bool valuefirst = true;
  bool valuesecond = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Flutter Checkbox Example'),),
        body: Container(
            padding: new EdgeInsets.all(22.0),
            child: Column(
              children: <Widget>[
                SizedBox(width: 10,),
                Text('Checkbox with Header and Subtitle',style: TextStyle(fontSize: 20.0), ),
                CheckboxListTile(
                  secondary: const Icon(Icons.alarm),
                  title: const Text('Ringing at 4:30 AM every day'),
                  subtitle: Text('Ringing after 12 hours'),
                  value: this.valuefirst,
                  onChanged: (bool value) {
                    setState(() {
                      this.valuefirst = value;
                    });
                  },
                ),
                CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.trailing,
                  secondary: const Icon(Icons.alarm),
                  title: const Text('Ringing at 5:00 AM every day'),
                  subtitle: Text('Ringing after 12 hours'),
                  value: this.valuesecond,
                  onChanged: (bool value) {
                    setState(() {
                      this.valuesecond = value;
                    });
                  },
                ),
              ],
            )
        ),
      ),
    );
  }
}